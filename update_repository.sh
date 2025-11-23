#!/bin/bash
set -e

PACKAGES="${INPUT_PACKAGES:-fastfetch-git amneziavpn-bin dl-desktop-git}"

echo "Собираю: $PACKAGES"

# Обновляем систему
pacman -Syu --noconfirm

for pkg in $PACKAGES; do
    echo "=== $pkg ==="
    cd /tmp
    rm -rf "$pkg"
    pacman -Sy git
    git clone --depth 1 https://aur.archlinux.org/"$pkg".git
    cd "$pkg"
    makepkg -s --noconfirm --needed --skippgpcheck
    cp *.pkg.tar.zst /repo/
done

cd /repo
repo-add aura.db.tar.gz *.pkg.tar.zst

echo "package_dir=/repo" >> $GITHUB_OUTPUT

echo "ГОТОВО! Пакеты:"
ls -lah /repo
