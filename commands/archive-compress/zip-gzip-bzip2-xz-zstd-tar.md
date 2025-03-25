# Compression

## Options

Compression preset level settings (`-1` ~ `-9`) for `zip`, `gzip`, `xz` and `bzip2`:
- `-1`: fast setting
- `-6`: default
- `-9`: high compression rate.

`zstd` supports a wide range of compression levels up to 22.


- `-d`: for *decompression*
- `-c`: write to standard output


## zip

```bash
zip -9 a.zip foo bar
zipinfo a.zip
unzip a.zip
```


## gzip

```bash
gzip -9 foo
gzip -kd foo.gz   # `-d` for decompress
gunzip -k foo.gz  # equivalent
```

### rename issues
Use the `-N` or `--name` option when using gunzip recovers the original file name. -N is the default when compressing (so gzip always saves the original file name) but not when decompressing so it has to be used explicitly with gunzip (or `gzip -d`).

```bash
gzip test.txt
mv test.txt.gz rest.txt.gz
gzip -dN rest.txt.gz   # with -N, you'll get test.txt; without -N, you'll get rest.txt
```

## bzip2
Cannot preserve original filename or attributes.

```bash
bzip2 -9ck gpl-3.0.txt > gpl.bz2
```

## xz
Cannot preserve original filename or attributes.

```bash
xz -c --best gpl-3.0.txt > gpl.xz
```

## zstd
Cannot store the input´s filename or attributes either.

```bash
zstd --ultra -22 -k gpl-3.0.txt -o gpl.zst
```



# tar

- `-c`: create a tarball
- `-x`: extract from archive 
- `-f`: specify file name
- `-k`: keep old files, don't overwrite
- `-t`: list files in a tarball
- `-v`: verbose mode

- `-z`:     filter the archive through **gzip**
- `-J`:     filter through **xz**
- `-j`:     filter through **bzip2**
- `--zstd`: filter through **zstd**

`-f` is always the last option.  


```bash
tar czf foo.tar.gz doc.md src.c
tar xzvf foo.tar.gz
```

Access files remotely, no upload/download, just to check contents:
```bash
tar vtf 192.168.122.232:/home/username/foo.bar.gz --rsh-command=/usr/bin/ssh
```
