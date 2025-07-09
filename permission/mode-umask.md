# Mode
Each MODE is of the form `[ugoa]*([-+=]([rwxXst]*|[ugo]))+|[-+=][0-7]+`.

```bash
ls -l file_name

-rw-r--r-- 12 username users 12.0K Apr  28 10:10 file_name
|[-][-][-]-   [------] [---]  | |      |       |
| |  |  | |      |       +-----------> 7. Group
| |  |  | |      +-------------------> 6. Owner
| |  |  | +--------------------------> 5. Alternate Access Method (e.g., ACL)
| |  |  +----------------------------> 4. Others Permissions (modes)
| |  +-------------------------------> 3. Group Permissions (modes)
| +----------------------------------> 2. Owner Permissions (modes)
+------------------------------------> 1. Type

```

1. Type could be:
- `-`: regular file
- `d`: directory
- `l`: symbolic link, with mode attributes always being `drwxrwxrwx`
- `c`: character special file, a device that handles data as *a stream of bytes*, such as `/dev/null`
- `b`: block special file, a device that handles data in blocks

2. File mode for directories: 
- r --- allows directory contents to be listed, but no file information is available
- w --- allows files within that directory to be renamed, created or removed if the execute attribute is also set
- x --- allows the directory to be entered and directory metadata to be accessed.

## SUID and SGID
SUID (`setuid`, Set User ID) and SGID (Set Group ID) are special permissions that alter how files and directories behave when they are executed or accessed.

### SUID and SGID on files
When SUID is set on a *executable file*, it runs with the *owner's permissions* instead of the user who runs it. Similarly, when SGID is set, the executable runs with the **group's privileges** of the group itself instead of the user’s group.

Using the numeric mode of `chmod`, SUID is `4000`, SGID is `2000`. Depending on whether mode `x` *(execute)* is set, SUID/SGID appears in two forms:
- `s`: `setuid/setgid` bit is set, and mode `x` is also set.
- `S`: `setuid/setgid` bit is set, but mode `x` is not set. Often a misconfiguration since SUID/SGID only matters for files that are executable.

```bash
chmod 4754 filename
chmod 6755 filename
chmod u+s filename
```

### `setgid` on directories

Normally, when you create a file, it gets the group ownership of the file's creator.

If the **setgid** bit is set on directory DIR, newly created **files and subdirs** under DIR will inherit the group ownership of the directory rather rather than that of the creator.

Usage: 
```bash
chmod -R g+s DIR
```

## Sticky bit
On files, the sticky bit is ignored, but if applied to a directory, it prevents users from deleting or renaming files (unless the user is either the owner or the superuser).

Usage: 
```bash
chmod +t DIR
```


# chmod
## SYNOPSIS
```bash
chmod [OPTION]... MODE[,MODE]... FILE...
chmod [OPTION]... OCTAL-MODE FILE...
chmod [OPTION]... --reference=RFILE FILE...
```

## DESCRIPTION
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


## OPTIONS
- `-v`, `--verbose`
- `-c`, `--changes`: like verbose but report only when a change is made
- `-f`, `--silent`: suppress most error messages
- `-R`: recursive



# umask

`umask` (User Mask or User File Creation Mask) is a setting that controls the default permissions given to files and directories when they are created. It uses octal notation to express a *mask* of bits to be removed from a file's mode attributes.

## Default Mode
The operating system typically uses a default mode *before* applying the process’s `umask`. The umask is essentially a “mask” that strips (or “masks out”) permission bits from the default mode. 

Default mode:

- Files: `666` (rw-rw-rw-)
- Directories: `777` (rwxrwxrwx)

```bash
final_mode = default_mode & ~umask
```

- A umask of 026 would subtract:
  - 0 (for user) from 6 → **6**
  - 2 (for group) from 6 → **4**
  - 6 (for others) from 6 → **0**

Permissions for this file will be `644` (rw-r--r--). For directories, it will be `755` (rwxr-xr-x).

## Use case:
To set a `umask` for the current session :
```bash
umask -S      # display current value symbolically
umask 022     # now new files are created with mode `644`, and directories with mode `755`
umask a+r     # add read permission for all users
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
