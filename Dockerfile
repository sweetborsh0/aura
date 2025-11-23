FROM archlinux:latest

# Отключаем sandbox (нужно в Actions)
RUN sed -i 's,#DisableSandbox,DisableSandbox,' /etc/pacman.conf

# Устанавливаем ВСЁ, что может понадобиться хоть одному AUR-пакету в 2025 году
# Это ~1.5 ГБ, но билдится один раз и кэшируется
RUN pacman -Syu --noconfirm --needed \
    base-devel git sudo cmake ninja meson \
    vulkan-headers wayland libxcb libxrandr ocl-icd opencl-headers \
    vulkan-icd-loader mesa libpulse libnm xfconf imagemagick chafa \
    ddcutil directx-headers dconf yyjson pciutils glibc libglvnd \
    libx11 libxinerama libxcursor libxkbcommon libwayland-client \
    dbus-glib networkmanager pulseaudio alsa-lib rpm-tools xf86-video-amdgpu \
    python python-pip rust cargo go nodejs npm jdk-openjdk \
    && pacman -Scc --noconfirm || true

# Разрешаем makepkg от root
RUN sed -i 's,exit $E_ROOT,echo "root is allowed",' /usr/bin/makepkg

# Папка для репо
RUN mkdir /repo

COPY update_repository.sh /update_repository.sh
RUN chmod +x /update_repository.sh

WORKDIR /repo
CMD ["/update_repository.sh"]
