
Test resize on Debian 13 VM. The setup after graphical install:

```
NAME               MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINTS
sr0                 11:0    1 1024M  0 rom
vda                254:0    0   16G  0 disk
├─vda1             254:1    0  380M  0 part  /boot
├─vda2             254:2    0  286M  0 part  /boot/efi
├─vda3             254:3    0  5.6G  0 part
│ └─vda3_crypt     253:0    0  5.6G  0 crypt
│   ├─vg0-root--lv 253:1    0  3.6G  0 lvm   /
│   └─vg0-swap--lv 253:2    0  1.9G  0 lvm   [SWAP]
└─vda4             254:4    0  2.8G  0 part
  └─vda4_crypt     253:3    0  2.8G  0 crypt /home
```

Rename vda3_crypt as cryptlvm, vda4_crypt as crypthome by vgrename, and edit configs to take effect permanently:

```bash
# On a live USB
cryptsetup open /dev/vda3 cryptlvm
cryptsetup open /dev/vda4 crypthome
vgrename vg000 vg0
mount --mkdir /dev/vg0/root-lv /mnt && mount --mkdir /dev/vda1 /mnt/boot && \
mount --mkdir /dev/vda2 /mnt/boot/efi && mount --mkdir /dev/mapper/crypthome /mnt/home
arch-chroot /mnt
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
vi /etc/crypttab   # EDIT ...
vi /etc/fstab      # EDIT ...
vi /etc/initramfs-tools/conf.d/resume # EDIT ...
update-grub && update-initramfs -k all -u
```

Now:


```
NAME               MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
sr0                 11:0    1   1.3G  0 rom   
vda                254:0    0    16G  0 disk  
├─vda1             254:1    0   380M  0 part  
├─vda2             254:2    0   286M  0 part  
├─vda3             254:3    0   5.6G  0 part  
│ └─cryptlvm       253:0    0   5.6G  0 crypt 
│   ├─vg0-root--lv 253:1    0   3.6G  0 lvm   
│   └─vg0-swap--lv 253:2    0   1.9G  0 lvm   
└─vda4             254:4    0   2.8G  0 part  
  └─crypthome      253:3    0   2.8G  0 crypt
```


## Attempt 1: Enlarge SWAP in a different partition.

What we want: enlarge `/home`, and enlarge `SWAP` by adding an new encrypted partition into volume group vg0, then extend logical volume `swap-lv`.

### Partitioning and Resizing

To enlarge `/home` and `SWAP`, if you've luksOpen-ed, you have to luksClose first:

```bash
swapoff -a
umount -R /mnt
vgchange -an vg0
cryptsetup close /dev/mapper/cryptlvm
cryptsetup close crypthome
# cryptsetup close /dev/mapper/crypthome
````

Then fdisk:

- delete partition 4, then create new partion of size 4G (thus `/home` is extended to 4G).
- create new partition,

Check header stays intact by cryptsetup luksDump and

```bash
dd if=/dev/vda5 bs=512 count=1 | hexdump -C
```

Then resize luks volume and fs:

```bash
cryptsetup open /dev/vda4 crypthome
cryptsetup resize /dev/mapper/crypthome
cryptsetup status crypthome
e2fsck -f /dev/mapper/crypthome
resize2fs /dev/mapper/crypthome
```

After that, encrypt `/dev/vda4` as `cryptswp2`.

Something Weird: By the time we've enlarged home and swap, cryptsetup luksDump would complain the device is invalid. But we can normally open and close the crypt devices. After reboot, it stops complaining.

```bash
cryptsetup open /dev/vda3 cryptlvm
vgscan
vgchange -a y
pvcreate /dev/mapper/cryptswp2
vgextend vg0 /dev/mapper/cryptswp2
vgdisplay vg0
lvs vg0
lvextend -l +100%FREE vg0/swap-lv # swap doesn't support resize2fs
mkswap /dev/vg0/swap-lv
```

Now to check LV's internal layout:

```bash
lvs -o lv_name,devices,seg_size,lv_size vg0/swap-lv
```

#### Debug

If you created a LV (no need, in fact) prior to creating a PV, following operations would complain. like this:

```bash
lvs -a -o +devices
  WARNING: Couldn't find device with uuid 3e4ej2-AY6P-90u2-3fsD-v84r-e1DB-FBcBF7.
  WARNING: VG vg0 is missing PV 3e4ej2-AY6P-90u2-3fsD-v84r-e1DB-FBcBF7 (last written to [unknown]).
  LV      VG  Attr       LSize    Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert Devices
  root-lv vg0 -wi-ao----   <3.65g                                                     /dev/mapper/cryptlvm(0)
  swap-lv vg0 -wi-ao----    1.92g                                                     /dev/mapper/cryptlvm(934)
  swaplv2 vg0 -wi-----p- 1020.00m                                                     [unknown](0)
```

The cause is clear: PV cannot be found. To resolve this, if an LV is created on top of it, remove it first, then remove missing PV from VG. You can further remove the PV to let LVM not to regard it as a PV by `pvremove`

```bash
lvremove vg0/swaplv2
vgreduce --removemissing vg0
pvremove /dev/mapper/swaplv2
```

Debian's `crypttab` config is slightly different from arch's. After luksAddKey, edit the `/etc/crypttab`:

```
crypthome UUID=<uuid-of-/dev/vda4> /root/cryptkey luks,discard,x-initrd.attach
```

NOTE: The crypttab config above would cause a BOOT FAILURE! Read more to see why.

#### Configuration and boot

Mount and chroot. After that, edit `PATH` to use Debian's tools, not archlinux's:

```bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```

Edit `/etc/crypttab` and make sure the names are correct, and add `cryptswp2` here.

Check `/etc/fstab` to make sure as well.

Generate initramfs, reboot. Oops! Now you cannot enter your system because root partition cannot be found.

Why? Because we enabled hibernation. We unlock LVM and init hibernation in the initramfs phase. When you enter a passphrase, it tries to unlock the LVM, which includes `cryptswp2`, which is another encrypted partition that needs a key. But you intend to use a key stored in the root partition, which haven't been unlocked. It is clear to see, that a circular dependency, or a deadlock is preventing you from decryption.

To solve it in a Debian way, edit `/etc/crypttab`:

```
cryptlvm UUID=<uuid-of-/dev/vda3> none luks,discard,keyscript=/lib/cryptsetup/scripts/decrypt_keyctl
crypthome UUID=<uuid-of-/dev/vda4> none luks,discard,keyscript=/lib/cryptsetup/scripts/decrypt_keyctl
cryptswp2 UUID=<uuid-of-/dev/vda5> none luks,discard,keyscript=/lib/cryptsetup/scripts/decrypt_keyctl
```

Normally, if you have multiple encrypted partitions, the system tries to mount them one by one. If they all use the same key, you'd have to type it five times.

`decrypt_keyctl` changes this flow: Cache once, use everywhere. It prompts for a passphrase and stores it in the Session Keyring. On reaching other partitions, the cached key are checked first. That solves the deadlock issue.

Final result:

```
NAME               MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINTS
sr0                 11:0    1  1.4G  0 rom
vda                254:0    0   16G  0 disk
├─vda1             254:1    0  380M  0 part  /boot
├─vda2             254:2    0  286M  0 part  /boot/efi
├─vda3             254:3    0  5.6G  0 part
│ └─cryptlvm       253:0    0  5.6G  0 crypt
│   ├─vg0-root--lv 253:2    0  3.6G  0 lvm   /
│   └─vg0-swap--lv 253:3    0  2.9G  0 lvm   [SWAP]
├─vda4             254:4    0    4G  0 part
│ └─crypthome      253:4    0    4G  0 crypt /home
└─vda5             254:5    0    1G  0 part
  └─cryptswp2      253:1    0 1008M  0 crypt
    └─vg0-swap--lv 253:3    0  2.9G  0 lvm   [SWAP]
```


## Attempt 2: Shrink `/` and enlarge SWAP, then add a separate `/var` mountpoint

Attempt 1 is Debian-specific in that it uses a `decrypt_keyctl` script. For archlinux, the `encrypt` hook supports at most one `cryptdevice`, and there's no such script as in Debian. But it is possible (in theory) to resolve it with the `sd-encrypt` hook by switching from busybox-based initramfs to systemd-based initramfs. 

In other methods, we can keep SWAP in the same partition as specified by the HOOK `cryptdevice` (in our setup, the cryptlvm), and enlarge it within cryptdevice. To achieve this, we must shrink the `/` partition. I consider adding a separate `/var` mountpoint on a dm-crypted device to spare space for `/`.


### Resize Logical volume

Reference: [archwiki](https://wiki.archlinux.org/title/Resizing_LVM-on-LUKS)

```bash
cryptsetup luksOpen /dev/vda3 cryptlvm
# shrink root-lv
e2fsck -f /dev/vg0/root-lv
lvresize -L -600M --resizefs vg0/root-lv
# enlarge swap
lvresize -l +100%FREE vg0/swap-lv 
mkswap /dev/vg0/swap-lv
```


### Create new `/var` and rsync data

```bash
fdisk /dev/vda # create new partition
cryptsetup luksFormat /dev/vda5
cryptsetup open /dev/vda5 cryptvar
mkfs.ext4 /dev/mapper/cryptvar
```

rsync to new `/var`

```bash
mount --mkdir /dev/vg0/root-lv /mnt && mount --mkdir /dev/vda1 /mnt/boot && \
mount --mkdir /dev/vda2 /mnt/boot/efi && mount --mkdir /dev/mapper/crypthome /mnt/home
mount --mkdir /dev/vda5 /mnt/new_var
rsync -avHAUX --numeric-ids --info=progress2 /mnt/var /mnt/new_var
rm -rf /mnt/var
umount /mnt/new_var
mount --mkdir /dev/vda5 /mnt/var
```

Edit fstab, crypttab and update grub & initramfs. luksAddKey.





