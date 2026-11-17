C=/etc/calamares
mkdir -p $C/modules /etc/default /etc/doas.d
cat > $C/settings.conf << 'X'
modules-search: [ local, /usr/lib/calamares/modules ]
sequence:
  - show:
      - welcome
      - locale
      - keyboard
      - partition
      - users
      - summary
  - exec:
      - partition
      - mount
      - unpackfs
      - machineid
      - fstab
      - locale
      - keyboard
      - users
      - shellprocess
      - mkinitfs
      - bootloader
      - umount
  - show:
      - finished
branding: anchorage
prompt-install: true
dont-chroot: false
X
cat > $C/modules/unpackfs.conf << 'X'
unpack:
  - source: "/media/cdrom/anchorage.sfs"
    sourcefs: "squashfs"
    destination: ""
X
cat > $C/modules/machineid.conf << 'X'
systemd: false
dbus: true
X
cat > $C/modules/partition.conf << 'X'
efiSystemPartition: "/boot/efi"
defaultFileSystemType: "ext4"
X
cat > $C/modules/users.conf << 'X'
defaultGroups: [ users, wheel, audio, video, input, netdev ]
doAutologin: false
setRootPassword: true
doReusePassword: true
X
cat > $C/modules/shellprocess.conf << 'X'
dontChroot: false
timeout: 60
script:
  - "-deluser --remove-home live"
  - "-rm -f /etc/sddm.conf.d/autologin.conf"
  - "-rm -f /etc/polkit-1/rules.d/49-live.rules"
  - "-rm -f /etc/anchorage-init /boot/anchorage-initrd"
X
cat > /etc/default/grub << 'X'
GRUB_TIMEOUT=3
GRUB_DISTRIBUTOR="Anchorage"
GRUB_CMDLINE_LINUX_DEFAULT="modules=sd-mod,usb-storage,ext4 rootfstype=ext4 quiet"
X
echo "permit persist :wheel" > /etc/doas.d/wheel.conf
