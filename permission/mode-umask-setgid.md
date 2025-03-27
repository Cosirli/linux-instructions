# chmod and umask

## Mode
Each MODE is of the form `[ugoa]*([-+=]([rwxXst]*|[ugo]))+|[-+=][0-7]+`.


## chmod
### SYNOPSIS
```bash
chmod [OPTION]... MODE[,MODE]... FILE...
chmod [OPTION]... OCTAL-MODE FILE...
chmod [OPTION]... --reference=RFILE FILE...
```

### DESCRIPTION
`chmod` changes the file mode bits of each given file according to MODE, which can be either a *symbolic* representation of changes to make, or an *octal number* representing the bit pattern for the new mode bits.

Format for a symbolic mode: `[ugoa...][[-+=][perms...]...]`, where perms is either zero or more letters from the set `rwxXst`, or a single letter from the set `ugo`.

Multiple symbolic modes can be given, separated by commas.


Example commands: set a file's mode to `600`:
```bash
# set authorized_keys's mode
chmod -c 600 authorized_keys
chmod -v u=rw,go= authorized_keys
chmod -v a=,u+rw authorized_keys
# set foo's mode
chmod -v --reference=authorized_keys foo
```

combine with find: `find . -type d -exec chmod g+x {} +`


### OPTIONS
```bash

```
- `-v`, `--verbose`
- `-c`, `--changes`: like verbose but report only when a change is made
- `-f`, `--silent`: suppress most error messages
- `-R`: recursive



# Umask

`umask` (User Mask or User File Creation Mask) is a setting that controls the default permissions given to files and directories when they are created.

## Default Permissions
- Files: `666` (rw-rw-rw-)
- Directories: `777` (rwxrwxrwx)

## How `umask` Works
`umask` sets *which permissions to subtract* from the default permissions to determine the permissions of the file or directory. The value of `umask` is a 3-digit octal number. 

To calculate, given a *file (default permission `666`)* as an example:

- A umask of 026 would subtract:
  - 0 (for user) from 6 → **6**
  - 2 (for group) from 6 → **4**
  - 6 (for others) from 6 → **0**

Permissions for this file will be `644` (rw-r--r--). For directories, it will be `755` (rwxr-xr-x).

## Using command `umask`:
To set a `umask` for the current session :

```bash
umask 022
```

Now new files are created with `644` permissions, and directories with `755` permissions.

# SUID and SGID
SUID (`setuid`, Set User ID) and SGID (Set Group ID) are special permissions that alter how files and directories behave when they are executed or accessed.

## SUID and SGID on files
When SUID is set on a *executable file*, it runs with the *owner's permissions* instead of the user who runs it. Similarly, when SGID is set, the executable runs with the **group's privileges** of the group itself instead of the user’s group.

### Mode `s` and `S` on a file
Using the numeric mode of `chmod`, SUID is `4000`, SGID is `2000`. Depending on whether mode `x` *(execute)* is set, SUID/SGID appears in two forms:
- `s`: `setuid/setgid` bit is set, and mode `x` is also set.
- `S`: `setuid/setgid` bit is set, but mode `x` is not set. Often a misconfiguration since SUID/SGID only matters for files that are executable.

```bash
chmod 4754 filename
chmod 6755 filename
chmod u+s filename
```

## `setgid` on directories

Normally, when you create a file, it gets the group of the user creating it. 

When you set the **setgid** bit on directory DIR, new **files and subdirs** created under DIR will inherit its group ownership.

Usage: 
```bash
chmod -R g+s DIR
```



# Related issues

## copy or move files
When you want to `cp` files and set their attributes to those of the destination directory, use the `--no-preserve=ATTR_LIST` option. ATTR_LIST is a comma-separated list of attributes. Attributes are: 

- *mode* for permissions (including any ACL and xattr permissions)
- *ownership* for user and group
- *timestamps* for file timestamps
- *links* for hard links
- *context* for security context
- *xattr* for extended attributes
- *all* for all attributes.



mv is the wrong tool for this purpose; you want cp and then rm. 

Since you're moving the file to another filesystem this is exactly what mv is doing behind the scenes anyway, except that mv is also trying to preserve file permission bits and owner/group information. This is because mv would preserve that information if it were moving a file within the same filesystem and mv tries to behave the same way in both situations. Since you don't care about the preservation of file permission bits and owner/group information, don't use that tool. Use cp --no-preserve=mode and rm instead.

## find files with special mode

Use the `-perm` option for `find`. Glob or regex are not supported, but you can use `-` and `/` to modify match behavior.

- `-perm mode`: exact match
- `-perm -mode`: (AND) all specified bits must be set
- `-perm /mode`: (OR) any specified bit is set

```bash
find . -perm /4000 -type f 2> /dev/null
```
