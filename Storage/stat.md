# stat

Display file or file system status. 

```bash
stat [OPTION]... FILE...
```

## Options
- `-t`: Display info in terse form.
- `-c`: `--format=FORMAT` Use the specified FORMAT instead of the default; output a newline  after each use of FORMAT.

## Format

### basic info
- `%n`: file name
- `%s`: total size in bytes

```bash
stat test.txt -c "%s %n"
350 test.txt
```


### permission info

```bash
stat test.txt -c "%a %A %g %G %u %U"
640 -rw-r----- 1000 groupname 1000 username
```


### timestamp info

- `%w`: time of file birth, human-readable; - if unknown
- `%W`: time of file birth, seconds since Epoch; 0 if unknown

- `%x`: last access, human-readable
- `%X`: last access, seconds since Epoch

- `%y`: last data modification, human-readable
- `%Y`: last data modification, seconds since Epoch

- `%z`: last status change, human-readable
- `%Z`: last status change, seconds since Epoch




### filesys info
- `%h`: number of hard links
- `%i`: inode number

```bash
stat test.txt -c "%h %i %m %b %B"
1 648733 /home 512 1000
```
