#!/usr/bin/env bash
# Create hosts/<hostname> for the machine you are on, from hosts/_template.
#
#   ./scripts/new-host.sh <hostname> [username]
#
# - generates hardware-configuration.nix for this machine
# - detects an Nvidia GPU (and AMD/Intel iGPU) and fills in the PCI bus IDs
# - git-adds the new host (flakes only see tracked files)
set -euo pipefail

die() { echo "error: $*" >&2; exit 1; }

host="${1:-}"
user="${2:-dabu}"
[ -n "$host" ] || die "usage: $0 <hostname> [username]"
[[ "$host" =~ ^[a-zA-Z0-9][a-zA-Z0-9-]*$ ]] || die "hostname may only contain letters, digits and '-'"
[[ "$user" =~ ^[a-z_][a-z0-9_-]*$ ]] || die "invalid username '$user'"

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dest="$repo/hosts/$host"
[ -d "$repo/hosts/_template" ] || die "hosts/_template not found in $repo"
[ ! -e "$dest" ] || die "hosts/$host already exists"

cp -r "$repo/hosts/_template" "$dest"

echo ">> generating hardware-configuration.nix"
"${NIXOS_GENERATE_CONFIG:-nixos-generate-config}" --show-hardware-config >"$dest/hardware-configuration.nix"

# --- GPU detection -----------------------------------------------------------
lspci_cmd=(lspci)
command -v lspci >/dev/null 2>&1 || lspci_cmd=(nix --extra-experimental-features "nix-command flakes" run nixpkgs#pciutils --)
gpus="$("${lspci_cmd[@]}" 2>/dev/null | grep -Ei 'vga compatible|3d controller|display controller' || true)"

# "05:00.0 VGA ..." -> "PCI:5:0:0" (NixOS wants decimal bus:device:function)
busid() {
  local addr="${1%% *}" bus dev fn
  bus="${addr%%:*}"
  dev="${addr#*:}"; dev="${dev%%.*}"
  fn="${addr##*.}"
  printf 'PCI:%d:%d:%d' "0x$bus" "0x$dev" "0x$fn"
}

nvidia_line="$(grep -i nvidia <<<"$gpus" | head -n1 || true)"
amd_line="$(grep -Ei 'amd|ati |advanced micro' <<<"$gpus" | head -n1 || true)"
intel_line="$(grep -i intel <<<"$gpus" | head -n1 || true)"

nvidia_import=""
gpu_vars=""
if [ -n "$nvidia_line" ]; then
  echo ">> Nvidia GPU found: $nvidia_line"
  nvidia_import="../../nixos/nvidia.nix"
  gpu_vars=" nvidiaBusId = \"$(busid "$nvidia_line")\";"
  if [ -n "$amd_line" ]; then
    gpu_vars+=" amdgpuBusId = \"$(busid "$amd_line")\";"
    echo ">> AMD iGPU found (hybrid laptop): $amd_line"
  elif [ -n "$intel_line" ]; then
    gpu_vars+=" intelBusId = \"$(busid "$intel_line")\";"
    echo ">> Intel iGPU found (hybrid laptop): $intel_line"
  fi
  [ -n "$amd_line$intel_line" ] && gpu_vars="${gpu_vars} "
else
  echo ">> no Nvidia GPU found, skipping nixos/nvidia.nix"
fi

# --- fill in the template ----------------------------------------------------
if [ -n "$nvidia_import" ]; then
  sed -i "s|@NVIDIA_IMPORT@|$nvidia_import # Nvidia driver (bus IDs in variables.nix)|" "$dest/configuration.nix"
else
  sed -i '/@NVIDIA_IMPORT@/d' "$dest/configuration.nix"
fi
sed -i -e "s|@HOSTNAME@|$host|" -e "s|@USERNAME@|$user|" -e "s|@GPU@|$gpu_vars|" "$dest/variables.nix"

if git -C "$repo" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git -C "$repo" add "$dest"
  echo ">> staged hosts/$host in git (flakes need tracked files)"
fi

cat <<EOF

Done. Next steps:
  1. Review hosts/$host/variables.nix (timezone, keyboard layout, git name/email).
  2. sudo nixos-rebuild switch --flake $repo#$host
  3. Make sure user '$user' has a password: sudo passwd $user
  4. Reboot, log in through the greeter and pick Hyprland.

If Hyprland shows a black screen on a hybrid Nvidia laptop, set AQ_DRM_DEVICES in
hosts/$host/home.nix (home.sessionVariables.AQ_DRM_DEVICES = "/dev/dri/cardX:/dev/dri/cardY";).
Check the card order with: ls -l /dev/dri/by-path
EOF
