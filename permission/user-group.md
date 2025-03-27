# Manage users

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
chown [newuser]:[newgroup] dir-or-file
```

Examples
```bash
chown termux:termux-sync ./foo
chown -R :termux /home/termux
```

