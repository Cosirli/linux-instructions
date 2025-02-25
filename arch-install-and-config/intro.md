# Arch basic installation

## Configure font, keymapping


```bash
setfont /usr/share/kbd/consolefonts/LatGrkCyr-12x22.psfu.gz    # set a comfortable console font
setfont /usr/share/kbd/consolefonts/iso01-12x22.psfu.gz        # alternative ...
# loadkeys colemak    # keyboard layout configuration
```

configure key maps

```bash
cat > keys.conf
keycode 1 = Caps_Lock
keycode 58 = Escape
^C

loadkeys keys.conf
```

configure Vim

## Internet connection and time sync

### opt 1

```bash
ip link    # check for available network devices
ip link set devicename up
```

 Scanning for WIFI available

```bash
iwlist devicename scan | grep ESSID
```

Set up WIFI connection

```bash
wpa_passphrase WIFINAME WIFIPASSWD > internet.conf    # generate a config file to make connections
wpa_supplicant -c internet.conf -i devicename &       # choose .conf file and device, & for silent connect
```

Assign an IP address

```bash
dhcpcd &    # silent mode
```

Sync system time

```bash
timedatectl set-ntp true
```

### opt 2

```
iwctl --help | less
iwctl device list
iwctl --passphrase 123456 station wlan0 connect wifiname
iwctl --passphrase 123456 station wlan0 connect-hidden hiddenwifiname
```



## Basic Disk Partitioning

Check disk info (or use `cfdisk`)

```
fdisk -l    
```

Partitioning in fdisk

```
fdisk /dev/mmcblk1
```

`fdisk` 

| command | action                                 |
| ------- | -------------------------------------- |
| p       | print the partition table              |
| g       | create a new empty GPT partition table |
| n       | create a new partition                 |
| w       | write                                  |
| m       | print help menu                        |

**MBR or GPT?** If UEFI is supported, choose GPT. Must make sure the choice. Check out the example layouts in Arch wiki.  
To dual-boot Windows 64-bit using [UEFI](https://wiki.archlinux.org/title/UEFI) mode instead of BIOS, the GPT scheme is required. It is recommended to always use GPT for [UEFI](https://wiki.archlinux.org/title/UEFI) boot, as some UEFI implementations do not support booting to the MBR while in UEFI mode.   

GPT: boot or efi + root + home + SWAP or swapfile  

```bash
fdisk /dev/sda <<< m
```

in `fdisk`:

EFI booted system can only use GPT partition table.

Create a new GPT partition table.

- Create a new disk label of type GPT
- Add a new partition. Specify:
  - Partition number
  - First sector
  - Last sector
- 

## Decide Partition Format

make boot

```
mkfs.fat -F32 /dev/mmcblk1p1
```

make root: `ext4`, `btrfs`, ...

```
mfs.ext4 /dev/mkcblk1p2
```

make `SWAP`

```
mkswap /dev/mmcblk1p3
```

open swap: `swapon /dev/mmcblk1p3`

We didn't create HOME in this silly example.

## pacman configuration

Mirror: 

```bash
vim /etc/pacman.d/mirrorlist
#change the top of the list to 'https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch'
```

Other: 

```bash
vim /etc/pacman.conf
#find `Color`, open (uncomment) it.  
#find `ParallelDownloads = 5;`, uncomment it.
```

## mount

```bash
mount /dev/mmcblk1p2 /mnt           #mount root to /mnt
ls /mnt
mkdir -p /mnt/boot                     #'-p' is optional
mount /dev/mmcblk1p1 /mnt/boot      #mount boot
```

## Installation

```bash
pacstrap /mnt base linux linux-firmware
```

Generate file `fstab` to ensure auto mount next time 

```bash
genfstab -U /mnt >> /mnt/etc/ >> /mnt/etc/fstab
```



## Enter Arch

```bash
arch-chroot /mnt
```

```bash
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc        #HardWare clock time sync
exit                     #exit chroot

vim /mnt/etc/locale.gen  #uncomment en_US.UTF-8 UTF-8
arch-chroot /mnt
locale-gen
exit

vim /mnt/etc/locale.conf    #add LANG=en_US.UTF-8
vim /mnt/etc/vconsole.conf  
#add keycode 1 = Caps_Lock
#add keycode 58 = Escape

vim /mnt/etc/hostname  #input hostname, say it is cw
vim /mnt/etc/hosts     #enter TABs here!     
#127.0.0.1	localhost
#::1	localhost
#127.0.1.1	cw.localdomain cw
```

Add a boot loader for multi-system boot: `grub`

```bash
arch-chroot /mnt
passwd            #set password
pacman -S grub efibootmgr intel-ucode os-prober
mkdir /boot/grub
grub-mkconfig > /boot/grub/grub.cfg  #optional: '-o'

uname -m  #print system architecture: suppose it is x86_64

grup-install --target=x86_64-efi --efi-directory=/boot
#if BIOS + MBR: --target=i386-pc 
```



```bash
pacman -S vim neovim wpa_supplicant dhcpcd
exit     #exit chroot
killall wpa_supplicant dhcpcd
```



```bash
pacman -Syyu
pacman -S man bash-devel
pacman -S 
```



## Add User

```bash
useradd -m -G wheel david             # -m for home dir, -G wheel for group
passwd david                          # add password
ln -s /usr/bin/vim /usr/bin/vi        # link vim to vi
update-alternatives --config editor   # change default editor

visudo    # edit sudo file: uncomment to allow members of group wheel to exec any command
exit
```

## GUI

Server: xorg or wayland. take xorg as an example: 

```bash
sudo pacman -S xorg xorg-server
```

Desktop Environment or Windows Manager: KDE Plasma, GNOME, dwm, Xfce, i3, sway, ... 

```bash
# @TheCW's demonstration
sudo pacman -S deepin deepin-extra


pacman -Qs lightdm  # check if display manager already installed
vim /etc/lightdm/lightdm.conf    # uncomment and change to greeter-session=lightdm-deepin-greeter
sudo systemctl enable lightdm    # systemd: emmm
sudo systemctl start lightdm

# you may install yay
git clone https://aur.archlinux.org/yay.git --depth=1
cd yay
sudo pacman -S fakeroot
sudo pacman -S make
makepkg -si
pacman -Qs yay
# yay -S google-chrome

# TLP: Battery management tool
# fonts: github.com/theniceboy/.config
# yay -S netease-cloud-music 
```



https://s.fxymm.com/api/v1/client/subscribe?token=05b54777a9aba3b0fd9d172e39a24b1c