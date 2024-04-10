#!/usr/bin/env bash

set -e

RED='\033[0;31m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
ENDCOLOR='\033[0m'

hx_path="/usr/bin/hx"
runtime_path="~/.config/helix/runtime"

if [[ -f "$hx_path" ]]; then
  echo "helix is already installed at $hx_path"
  exit 1
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  os="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  os="macos"
else
  echo -e "Could not detect operating system (${RED}$OSTYPE${ENDCOLOR}); only Linux and MacOS are supported"
  exit 1
fi

echo -e "Detected operating system: ${CYAN}$os${ENDCOLOR}"

arch=$(uname -m)

if [[ "$arch" == "arm64" || "$arch" == "aarch64" ]]; then
  arch="aarch64"
elif [[ "$arch" == "x86_64" ]]; then
  arch="x86_64"
else
  echo -e "CPU architecture ${RED}$arch${ENDCOLOR} is not supported"
  exit 1
fi

echo -e "Detected CPU architecture: ${CYAN}$arch${ENDCOLOR}"

release=$(
  curl --silent "https://api.github.com/repos/helix-editor/helix/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/')

echo -e "Detected latest helix release: ${CYAN}$release${ENDCOLOR}"
foldername="helix-$release-$arch-$os"
filename="$foldername.tar.xz"
echo "Downloading latest helix release: $filename"

tmpdir=$(mktemp -d 2>/dev/null || mktemp -d -t "helix-install")
prev_pwd=$(pwd)

cd "$tmpdir"
curl "https://github.com/helix-editor/helix/releases/latest/download/$filename" \
  --remote-name \
  --location

tar -xf "$filename"
cd "$foldername"

echo -e "Installing ${PURPLE}helix${ENDCOLOR}..."

sudo mv hx /usr/bin
sudo chown root:wheel /usr/bin/hx

echo -e "Installed ${PURPLE}helix${ENDCOLOR} at $hx_path"

if [[ -f "$runtime_path" ]]; then
  echo -e "Runtime directory already exists. Will ${RED}NOT${ENDCOLOR} override."
  exit 0
fi

echo "Installing runtime..."
mkdir -p ~/.config/helix
mv runtime ~/.config/helix/runtime
echo "Installed runtime"

echo "Cleaning up..."
cd "$prev_pwd"
rm -rf "$tmpdir"

echo -e "Done! Type \`${PURPLE}hx${ENDCOLOR}\` to start hacking away!"
