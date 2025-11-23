#!/bin/bash
set -e

# Пакеты (из input или дефолт)
PACKAGES="${INPUT_PACKAGES:-fastfetch-git amneziavpn-bin dl-desktop-git}"

echo "Собираю пакеты: $PACKAGES"

# Обновляем систему
pacman -Syu --noconfirm

# Билдим каждый
for pkg in $PACKAGES; do
  echo "=== $pkg ==="
  cd /tmp
  rm -rf "$pkg"
  git clone https://aur.archlinux.org/"$pkg".git
  cd "$pkg"
  makepkg --noconfirm --skippgpcheck  # Без проверки подписей, чтоб не падало
  cp *.pkg.tar.zst /local_repository/
  cd ..
done

# База репо
cd /local_repository
repo-add aurci2.db.tar.gz *.pkg.tar.zst

# Files для pacman
find . -name "*.pkg.tar.zst" -exec pacman -Qlp {} \; | sort -u > aurci2.files

echo "Готово! Файлы в /local_repository:"
ls -la /local_repository/

# Output для workflow
echo "package_dir=/local_repository" >> $GITHUB_OUTPUT
