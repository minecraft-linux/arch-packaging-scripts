#!/bin/bash
# based on @mikroskeem's work: https://gist.github.com/mikroskeem/3a485627680943d164f18af4e3d42907

sources=(
    https://aur.archlinux.org/lib32-check.git
    https://aur.archlinux.org/lib32-libevdev.git
    https://aur.archlinux.org/mcpelauncher-msa-git.git
    https://aur.archlinux.org/mcpelauncher-msa-ui-qt-git.git
    https://aur.archlinux.org/mcpelauncher-linux-git.git
    https://aur.archlinux.org/mcpelauncher-ui-git.git
)

mkdir -p build
pushd build > /dev/null
for src in "${sources[@]}"; do
  name="$(basename "$src")"
  name="${name/\.git}"
  if [ ! -d "${name}" ]; then
    git clone "$src" "$name"
  else
    pushd "${name}" > /dev/null
    git reset --hard
    git clean -f -d -x
    git pull
    popd > /dev/null
  fi
  pushd "$name" > /dev/null
  makepkg -sfiC --noconfirm || exit 1
  popd > /dev/null
done
popd > /dev/null
mkdir -p output
mv build/*/*.pkg.tar.xz output/
rm output/lib32-check*
