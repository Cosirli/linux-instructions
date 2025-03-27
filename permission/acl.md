# ACL

Advanced Control Lists. A more finer permission control over traditional `chmod` (which is used for simple permission changes).

## getfacl
Get permission information for a file or directory.

Example output for `getfacl file-or-dir`
```
# file: etc/environment
# owner: root
# group: root
user::rw-
group::r--
other::r--
```


## setfacl

Set ACL for files or directories.

Using the default switch (`-d`) and the modify switch (`-m`) will only modify the default permissions but leave the existing ones intact:

```bash
setfacl -d -m g::rwx /dir
setfacl -dRm g:termux-sync:rw sync/
setfacl -Rm u:1000:rwx /home/termux/sync/
setfacl -bR ta
```

Umask will still apply to newly created files, and you can "override" umask as well:
```bash
setfacl -s u::rwx,g::r-x,o::r-x,m:rwx,u:john:rwx,d:u:john:rwx,d:u::rwx,d:g::r-x,d:o::r-x,d:m:rwx /home/john/public_html
```

If you want to change folder's entire permission structure including the existing ones, make it recursive with `-R`

Examples:



# more
You cannot set a default owner with `setfacl`. To get new files owned by a specific user, you'd need a setuid bit that works like the setgid bit on directories. Unfortunately that is not implemented.
