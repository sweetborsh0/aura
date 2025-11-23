FROM archlinux:latest

# Отключаем sandbox (GitHub Actions не любит landlock)
RUN sed -i 's,#DisableSandbox,DisableSandbox,' /etc/pacman.conf

# Устанавливаем deps одной командой
RUN pacman -Syu --noconfirm base-devel git

# Патчим makepkg для root (иначе ругается)
RUN sed -i 's,exit $E_ROOT,echo "root is allowed",' /usr/bin/makepkg

# Папка для репо
RUN mkdir /local_repository

COPY update_repository.sh /update_repository.sh
RUN chmod +x /update_repository.sh

CMD ["/update_repository.sh"]
