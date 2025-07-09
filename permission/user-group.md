# Manage users

User accounts are defined in the `/etc/passwd` file, and groups in the `/etc/group` file.

Encrypted information of user passwords are stored in the `/etc/shadow` file.

## Add, delete and configure

```bash
useradd -s /usr/bin/bash -m termux  # -m: create home directory; -s: default shell
passwd mia
userdel -r mia # -r: Remove user's home directory and mail spo
```

To change a user's login shell:  
`usermod -s path/to/shell username` or `chsh -s path/to/shell`


## Change group

```bash
usermod -aG termux-sync mia   # add mia to group termux-sync
```


# chown

```bash
chown uname:gname dir-or-file   # change user and group
chown uname dir-or-file             # change user only
chown :gname dir-or-file           # change group only
chown uname: dir-or-file            # change user and change the group to the login group of uname
```

Examples
```bash
chown termux:termux-sync ./foo
chown -R :termux /home/termux
```

# Changing identities

## `su`

If the `-l` option is included, the resulting shell session is a *login shell* for the specified user. `-l` may be abbrievated as `-`. If the user is not specified, the superuser is assumed.

To execute a single command rather than starting an interactive session, use `su -c 'command'`

## `sudo`

- `-i`: start an interactive, login shell session
- `-l`: print priviledges granted by sudo

