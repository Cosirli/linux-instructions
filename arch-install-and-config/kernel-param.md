

To pass kernel parameters, edit `/etc/default/grub`, using the form:

```bash
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 cryptdevice=UUID=uuid_of_sda2_here:cryptlvm root=UUID=uuid_of_vg0-root"
```

```bash
hibernate.compressor=lz4   # algo that resumes faster than lzo. (/sys/module/hibernate/parameters/compressor)
```
