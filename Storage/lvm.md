## Without Logical Volume Manager

Simulate a scenario where some log files fill up the filesys space

```bash
watch df -h
cat /dev/zero > /var/log/app.log   # Disk space would run out
```

One way to resolve it, at the cost of losing your logfile: 

```bash
truncate -s 0 /var/log/app.log
```

But with LVM:

```bash
lvextend --resizefs -l +100%FREE /dev/mapper/vg0-rootlv
```

## LVM 


Basic building blocks:



- **Physical volume (PV)**
    - Unix block device node, usable for storage by LVM. Examples: a hard disk, an MBR or GPT partition, a loopback file, a device mapper device (e.g. dm-crypt). It hosts an LVM header.
- **Volume group (VG)**
    - Group of PVs that serves as a container for LVs. PEs are allocated from a VG for a LV.
- **Logical volume (LV)**
    - "Virtual/logical partition" that resides in a VG and is composed of PEs. LVs are Unix block devices analogous to physical partitions, e.g. they can be directly formatted with a file system.
- **Physical extent (PE)**
    - The smallest contiguous extent (default 4 MiB) in the PV that can be assigned to a LV. Think of PEs as parts of PVs that can be allocated to any LV.


To auto-mount, write into `/etc/fstab` or `/etc/crypttab` if LUKS in use


### Physical Volume

```bash
pvcreate /dev/sda1
pvdisplay
pvs
```

### Volume Group

Create a new volume group: 

```bash
vgcreate vg_name pv_1, pv_2, pv_3
```

Extend a volume group (add a PV):

```bash
vgextend vg_name pv_4  # /dev/sda1
```

### Logical Volume

Create a LV named `vg_name-lv0` with specified init size in VG `vg_name`:

```bash
lvcreate vg_name -L 5G -n vg_name-lv0
```

Format it into ext4:

```bash
mkfs.ext4 /dev/mapper/vg_name-lv0
```

Extend by 10G and manually resize to filesys:

```bash
lvextend -L +10G /dev/mapper/vg_name-lv0
resize2fs /dev/mapper/vg_name-lv0
```

Extend to all free space in the VG and auto-resize to filesys:

```bash
lvextend --resizefs -l +100%FREE /dev/mapper/vg_name-lv0
```

Test mount:
```bash
blkid
# edit fstab / crypttab
mount -a  # mount file systems in fstab
```


### Snapshots

`-s` means it is a snapshot

```bash
lvcreate /dev/mapper/vg_name-lv0 -L 1G -s -n vg_name-lv0-snapshot_20240101
```

```bash
mkdir /mnt/vg0/snapshot
mount /dev/mapper/vg_name-lv0-snapshot_20240101 /mnt/vg0/snapshot
```

Recover:

```bash
# umount the volume and its snapshot (if mounted) first
lvconvert --merge /dev/mapper/vg_name-lv0-snapshot_20240101
lvchange -a n /dev/mapper/vg_name-lv0
lvchange -a y /dev/mapper/vg_name-lv0
```



