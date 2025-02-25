# Partitioning

  

## Partition table

### Master Boot Record

The [Master Boot Record](https://en.wikipedia.org/wiki/Master_boot_record) (MBR) is the first 512 bytes of a storage device.   

### GUID Partition Table

[GUID Partition Table](https://en.wikipedia.org/wiki/GUID_Partition_Table) (GPT) is a partitioning scheme that is part of the [Unified Extensible Firmware Interface](https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface) specification; it uses [globally unique identifiers](https://en.wikipedia.org/wiki/Globally_unique_identifier) (GUIDs), or UUIDs in the Linux world, to define partitions and [partition types](https://en.wikipedia.org/wiki/GUID_Partition_Table#Partition_type_GUIDs). It is designed to succeed the [Master Boot Record](https://wiki.archlinux.org/title/Partitioning#Master_Boot_Record) partitioning scheme method.

At the start of a GUID Partition Table disk there is a [protective Master Boot Record](https://en.wikipedia.org/wiki/GUID_Partition_Table#Protective_MBR_.28LBA_0.29) (PMBR) to protect against GPT-unaware software. This protective MBR just like an ordinary MBR has a [bootstrap code area](https://wiki.archlinux.org/title/Partitioning#Master_Boot_Record_(bootstrap_code)) which can be used for BIOS/GPT booting with boot loaders that support it.  

### **MBR or GPT?** 

If UEFI is supported, choose GPT. Must make sure the choice. Check out the example layouts in Arch wiki.  
To dual-boot Windows 64-bit using [UEFI](https://wiki.archlinux.org/title/UEFI) mode instead of BIOS, the GPT scheme is required. It is recommended to always use GPT for [UEFI](https://wiki.archlinux.org/title/UEFI) boot, as some UEFI implementations do not support booting to the MBR while in UEFI mode.   



## Partition scheme

  r

GPT: boot or efi + root + home + SWAP or swapfile  



## Tools

**`fdisk`**  

Get help

```
fdisk /dev/sda <<< m | less
```

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



in `fdisk`:

EFI booted system can only use GPT partition table.

Create a new GPT partition table.

- Create a new disk label of type GPT
- Add a new partition. Specify:
  - Partition number
  - First sector
  - Last sector
- 

