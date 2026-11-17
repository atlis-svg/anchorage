doas chown root:root ~/rootfs
doas rm -f ~/rootfs/setup.sh
rm -rf ~/isoroot
mkdir -p ~/isoroot/boot/grub
doas cp ~/rootfs/boot/vmlinuz-lts ~/rootfs/boot/anchorage-initrd ~/isoroot/boot/
doas chmod 644 ~/isoroot/boot/anchorage-initrd
cat > ~/isoroot/boot/grub/grub.cfg << 'G'
set timeout=3
menuentry "Anchorage" {
    linux /boot/vmlinuz-lts quiet
    initrd /boot/anchorage-initrd
}
G
doas mksquashfs ~/rootfs ~/isoroot/anchorage.sfs -comp xz -noappend
grub-mkrescue -o ~/iso/anchorage.iso ~/isoroot
