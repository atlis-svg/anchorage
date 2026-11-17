# ⚓ Anchorage

**A KDE Plasma desktop distro based on Alpine Linux, with a graphical installer.**

Anchorage takes Alpine's small, simple base and turns it into a ready-to-use desktop. Boot the live USB, try it out, and click **Install Anchorage** when you're ready.

> Anchorage is an independent project. It is based on Alpine Linux but is not affiliated with or endorsed by the Alpine Linux project.

## Features

- **KDE Plasma 6** desktop, boots straight into a live session
- **Calamares installer**, rebuilt for Qt6 (Alpine dropped its Calamares package in 2024, so Anchorage packages its own)
- **Flatpak + Flathub** ready out of the box, with Discover as the app store
- **Preinstalled apps:** Firefox, Dolphin, Kate, Ark, Gwenview, Okular, Spectacle
- **OpenRC + musl**, the same lightweight foundation as Alpine
- **NetworkManager** and firmware for real hardware
- **doas** for admin tasks
- Boots on both **BIOS and UEFI**
- Updates come straight from Alpine's repos with `apk upgrade`

## Screenshots

*Coming soon*

## Requirements

- 64-bit (x86_64) PC
- **4 GB RAM** minimum (the live session runs from memory)
- **Secure Boot turned off** (the bootloader is not signed yet)
- 20 GB of disk space to install

## Download

ISO downloads: *link coming soon*

To write the ISO to a USB stick on Linux (replace `sdX` with your USB stick, and double check it, this wipes the drive):

```
sudo dd if=anchorage.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

## Building it yourself

Anchorage is built inside an Alpine 3.24 container. Everything below runs inside it unless it says otherwise.

### 1. Set up the build box

On the host:

```
podman run -it --name anc alpine:3.24
```

Inside the box, as root:

```
apk add alpine-sdk doas syslinux xorriso squashfs-tools grub grub-efi grub-bios mtools dosfstools
adduser -D me
addgroup me abuild
echo 'permit nopass :abuild' > /etc/doas.d/abuild.conf
su me
abuild-keygen -a -n
```

Then, back as root, copy your new key into `/etc/apk/keys/`.

### 2. Build Calamares

```
cd ~/calamares
abuild checksum
abuild -r
```

The package ends up in `~/packages/me/x86_64/`.

### 3. Build the root filesystem

```
sh mkroot.sh
doas apk --root ~/rootfs add $(cat packages.txt)
```

Then run each setup script inside the rootfs:

```
doas cp setup.sh ~/rootfs/
doas chroot ~/rootfs sh /setup.sh
```

Do the same for `live.sh`, `brand.sh`, `brand2.sh` and `calcfg.sh`, then delete the scripts from `~/rootfs`.

| Script | What it does |
|---|---|
| `mkroot.sh` | Installs Alpine + Plasma + Calamares into `~/rootfs` |
| `setup.sh` | Hostname, boot services, the `live` user, autologin |
| `live.sh` | Installer autostart, desktop icon, live session permissions |
| `brand.sh` / `brand2.sh` | Calamares branding, OS name, slideshow |
| `calcfg.sh` | The Calamares install steps and module configs |

### 4. Build the initramfs

`init` is Anchorage's own boot script. It finds the USB/CD, mounts the system image and switches into it.

```
doas cp init ~/rootfs/etc/anchorage-init
doas chmod +x ~/rootfs/etc/anchorage-init
echo kernel/fs/overlayfs | doas tee ~/rootfs/etc/mkinitfs/features.d/anchorage.modules
doas chroot ~/rootfs sh -c 'mkinitfs -F "base squashfs cdrom ata scsi usb virtio anchorage" -i /etc/anchorage-init -o /boot/anchorage-initrd $(ls /lib/modules)'
```

### 5. Build the ISO

```
nice -n 19 sh mkiso.sh
```

The finished ISO is `~/iso/anchorage.iso`.

### Manual steps not in the scripts yet

- Wallpaper: copied into `/usr/share/wallpapers/Next/contents/images/` and `images_dark/`
- Calamares slideshow: wallpaper copied to `/usr/share/calamares/branding/anchorage/slide.png`
- Login screen: `/etc/sddm.conf.d/theme.conf` sets the Breeze theme, and `/usr/share/sddm/themes/breeze/theme.conf.user` points it at the wallpaper
- Flathub: `flathub.flatpakrepo` downloaded into `/etc/flatpak/remotes.d/`
- `/etc/issue` and `/etc/motd` rebranded

## How it works

- The whole system is packed into one compressed image (`anchorage.sfs`)
- At boot, Anchorage's initramfs mounts that image read-only and puts a RAM layer on top, so the live session can change things without touching the USB
- Calamares installs by copying that same image onto the disk, then removes the live-only bits and sets up GRUB

## Credits

- [Alpine Linux](https://alpinelinux.org) for the base system and packages
- [KDE](https://kde.org) for Plasma and the apps
- [Calamares](https://calamares.codeberg.page) for the installer framework

Made by **Gravity** under **So Very Tuff Co.**
