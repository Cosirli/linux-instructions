

If we use `-C` for `tar`, it changes directory first and its exclude rule should be based on relative path.


Absolute path wouldn't work. This excludes nothing:

```
/root/dname
```


Don't put a trailing slash. This excludes nothing

```
dname/
./dname/
```




This ignores the file fname

```
fname
```

This ignores the directory dname

```
dname
./dname
```

This ignores the directory's content, hidden files are also ignored

```
dname/*
```


Good example:

```bash
tar -cpSf dotlocal-without-libvirt-images.tar \
    --exclude 'share/libvirt/images' \
    --atime-preserve=system \
    --numeric-owner \
    --acls \
    --xattrs --xattrs-include='*' \
    --one-file-system \
    --delay-directory-restore \
    --total 2>&1 \
    -C $HOME/.local/ .
```
