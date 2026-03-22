### tar command

Preserve regular file and directory permissions (modes) by adding the `-p` flag.

Hard & symbolic links are preserved by default.

Preserve atime of source file: `--atime-preserve=system` (note that backup file can preserve mtime only to be the same as the source)

Sparse files: `-S`

ACLs: `--acl`

Extended attributes (like capabilities).

Explicitly enable SElinux support instead of all xattrs by `--selinux`

```bash
cd /home/username
tar -cpvSf - \
    --atime-preserve=system \
    --one-file-system \
    --numeric-owner \
    --acls \
    --xattrs --xattrs-include='*' \
    --delay-directory-restore \
    . | ssh user@ip "cat > /storage/backup.tar"
```

```bash
cd /mnt/home
ssh user@ip "cat /storage/backup.tar" | \
tar -xpvSf - \
    --numeric-owner \
    --acls \
    --xattrs --xattrs-include='*' \
    --delay-directory-restore
```

With pv:

```bash
sudo tar -cpSf - \
    --atime-preserve=system \
    --numeric-owner \
    --acls \
    --xattrs --xattrs-include='*' \
    --one-file-system \
    --delay-directory-restore \
    -C /var . 2>> ./backup_$(date +%Y%m%d).log | \
    pv -s $(sudo du -sb /var | cut -f1) -N "Packing" | \
    split -b 5G -d -a 3 - ./var.tar.part
```

With compression + encryption:

```bash
sudo tar -cpSf - \
    --atime-preserve=system \
    --numeric-owner \
    --acls \
    --xattrs --xattrs-include='*' \
    --one-file-system \
    --delay-directory-restore \
    -C /var . 2>> ./backup_$(date +%Y%m%d).log | \
    zstd -1 --threads=0 | \
    gpg --symmetric --cipher-algo AES256 --pinentry-mode loopback | \
    pv -s $(sudo du -sb /var | cut -f1) -N "Backing up" | \
    split -b 5G -d -a 3 - ./var.tar.zst.gpg.part
```

Restore:

```bash
cd /var
PREFIX=var.tar.zst.gpg.part
sudo cat ${PREFIX}* | \
    pv -s $(du -sb ${PREFIX}* | awk '{print $1}') -N "Restoring" | \
    gpg --decrypt --pinentry-mode loopback | \
    zstd -d --threads=0 | \
    tar -xpSf - \
    --numeric-owner \
    --acls \
    --xattrs --xattrs-include='*' \
    --delay-directory-restore \
    -C .
```
