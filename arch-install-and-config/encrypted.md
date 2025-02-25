```bash
fdisk #Create partition tables
```

Boot: 

```bash
mkfs.fat --F 32 /dev/sda1 #fat32: no encryption for boot
```

# Formatting with encryption

Encrypt the rest: 

```bash
cryptsetup luksFormat /dev/sda2  #specify passphrase 
cryptsetup luksFormat /dev/sda3  #specify passphrase 
```

Decipher for further operations

```bash
cryptsetup open /dev/sda2 cryptlvm  #enter passphrase for deciphering
cryptsetup open /dev/sda3 crypthome #cryptname is the name after deciphering
```

## Create Volume

Create physical volume

```bash
pvcreate /dev/mapper/cryptlvm
pvdisplay #print
```

Create volume group

```bash
vgcreate vg0 /dev/mapper/cryptlvm
vgdisplay #print
```

Create logical volume

- For swap:  

```bash
lvcreate -L 16G vg0 -n swap    #name: swap
ls -l /dev/vg0/swap /dev/mapper/vg0-swap  #they are symbolic links to dm-2 (device mapper)
```

- Same for root:  

```bash
lvcreate -l 100%FREE vg0 -n root 
```

## Make swap and filesys

```bash
mkswap /dev/vg0/swap
mkswap /dev/mapper/vg0-swap #alternative
```

Make root and home

```bash
mkfs.ext4 /dev/vg0/root
mkfs.ext4 /dev/mapper/crypthome
```

Done with formatting.

# Mount

```bash
mount /dev/vg0/root /mnt               #mount root to /mnt
ls /mnt
mkdir -p /mnt/{boot,home}              #'-p' is optional
mount /dev/sda1 /mnt/boot              #mount sda1
mount /dev/mapper/crypthome /mnt/home  #mount home
```

Turn on swap

```bash
swapon /dev/vh0/swap
```

# Install components

Configure `pacman` first.

```bash
vim /etc/pacman.d/mirrorlist 
#change the top of the list to 'https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch'
vim /etc/pacman.conf   
#uncomment ParallelDownloads = 5; uncomment Color
```

base: GNU Coreutils; base for developing; linux kernel, headers and firmware; intel waybar;  
text editor; network manager; manual page database; bash completion support; 

```bash
pacman -Sy
pacstrap -K /mnt base base-devel linux-lts linux-lts-headers linux-firmware intel-ucode cryptsetup lvm2 vim neovim networkmanager man-db bash-completion
```



```bash
genfstab -U /mnt >> /mnt/etc/fstab
```



```bash
arch-chroot /mnt
ln sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwlock -systohc  #hardware clock: system to hardcore

vim /etc/locale.gen   #uncomment en_US.UTF-8 UTF-8
locale-gen
vim /etc/locale.conf    #add LANG=en_US.UTF-8
vim /etc/vconsole.conf  
#add keycode 1 = Caps_Lock
#add keycode 58 = Escape

echo archsway >> /etc/hostname
vim /etc/hosts
#127.0.0.1	localhost
#::1	localhost
#127.0.1.1	archsway.localdomain archsway
```

auto decipher sda3(home) with `crypttab`

```bash
cd /root
lsblk
#use dd command to generate random file: input from... output from root's $HOME size:4096
dd if=/dev/urandom of=/root/cryptkey bs=1024 count=4

chmod 400 cryptkey    #read-only by root
cryptsetup luksAddKey /dev/sda3 /root/cryptkey    #add the file to sda3's keys

blkid >> /etc/crypttab    #now we need sda3's UUID
vim /etc/crypttab
#comment the appended contents
#crypthome	UUID=sda3's_uuid_here	/root/cryptkey	luks,discard

vim /etc/mkinitcpio.conf
#change HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block filesystems fsck) to:
#HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt lvm2 filesystems resume fsck) #don't comment this line of course

mkinitcpio -P
```

Create passwd for user root and create a non-root user

```bash
passwd
useradd -G wheel -m nate
passwd nate
visudo  # edit sudo file: uncomment to allow members of group wheel to exec any command
```



Install `grub`

```bash
pacman -Syu grub efibootmgr
```



```bash
blkid >> /etc/default/grub    #now we need the UUID of sda2 and vg0-root
vim /etc/default/grub
#for the appended text: delete all except crypthome, cryptlvm and sda2.
#change GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet" to "loglevel=3 cryptdevice=UUID=uuid_of_sda2_here:cryptlvm root=UUID=uuid_of_vg0-root"

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

exit
umount -R /mnt
swapoff -a
reboot
```







```
set -o vi
ip a
systemctl enable --now NetworkManager.service
pacman -Syu git
git clone https://codeberg.org/unixchad/dotfiles
sudo pacman -Syu ranger
```

