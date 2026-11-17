R=/home/me/rootfs
M=https://dl-cdn.alpinelinux.org/alpine/v3.24
doas apk --root $R --initdb --keys-dir /etc/apk/keys \
  -X $M/main -X $M/community -X /home/me/packages/me \
  add alpine-base linux-lts plasma sddm elogind dbus konsole calamares
printf "$M/main\n$M/community\n" | doas tee $R/etc/apk/repositories
