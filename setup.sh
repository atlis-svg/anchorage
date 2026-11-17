echo anchorage > /etc/hostname
for s in devfs dmesg udev udev-trigger udev-settle; do rc-update add $s sysinit; done
for s in modules sysctl hostname bootmisc syslog; do rc-update add $s boot; done
for s in dbus elogind networkmanager sddm udev-postmount; do rc-update add $s default; done
for s in mount-ro killprocs; do rc-update add $s shutdown; done
adduser -D -s /bin/sh live
passwd -d live
addgroup live wheel
mkdir -p /etc/sddm.conf.d
printf "[Autologin]\nUser=live\nSession=plasma\n" > /etc/sddm.conf.d/autologin.conf
