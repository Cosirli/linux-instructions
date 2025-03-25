# SCP

SCP (Secure Copy Protocol) allows you to copy files or directories between a local machine and a remote machine (or between two remote machines).

## Syntax: 

```bash
scp [options] <source> <destination>
```

- `-i`: Specify a SSH private keyfile (`i` for identity) (passed to `ssh`)
- `-r`: Copy recursively
- `-P`: Use a different port
- `-3`: Copies between two remote hosts are transferred through the local host.
- `-4`: Forces scp to use IPv4 addresses only.
- `-6`: Forces scp to use IPv6 addresses only.
- `-A`: Allows forwarding of ssh-agent to the remote system.
- `-C`: Compression enable. (passed to `ssh`)
- `-J`: Connect to target host through an intermediary **jump host (proxy)** as specified.




## Use cases:  

```bash
scp username@hostname:/path/to/remote/file /path/to/local/directory
scp -r /path/to/local/directory username@hostname:/path/to/remote/directory
scp -P 2222 /path/to/local/file username@hostname:/path/to/remote/directory
```

# SFTP

FTP, the File Transfer Protocol, was a popular, unencrypted method of transferring files between two remote systems, and it has been deprecated due to a lack of security. SFTP (SSH File Transfer Protocol) is a 



## TLDR

  Interactive program to copy files between hosts over SSH.

```bash
  For non-interactive file transfers, see `scp` or `rsync`. More information: https://manned.org/sftp.

  - Connect to a remote server and enter an interactive command mode:
    sftp remote_user@remote_host

  - Connect using an alternate port:
    sftp -P remote_port remote_user@remote_host

  - Connect using a predefined host (in `~/.ssh/config`):
    sftp host

  - Transfer remote file to the local system:
    get /path/remote_file

  - Transfer local file to the remote system:
    put /path/local_file

  - Transfer remote directory to the local system recursively (works with `put` too):
    get -R /path/remote_directory

```

## Interactive commands

### Bash-like commands
In interactie mode, a set of commands similar to bash are available. These commands are run on the remote machine, but you can prefix `l` for that command to run on your local machine, for example:  

- Get list of files on remote machine: `ls`
- Get list of files on local machine: `lls`
- Other available commands: `cd`, `pwd`, `mv`, `chmod`, `df`, ...

### File transfer

Upload

```bash
put [-afpR] local-path [remote-path]
```

Download

```bash
get [-afpR] remote-path [local-path]
```

- `-a`: Attempt to resume partial transfers.
- `-f`: Call `fsync` after transfer to flush the file to disk.
- `-p`: Permissions and access times are copied.
- `-R`: Recursively copy directories.

To download *multiple* files using patterns or wildcards, use the `mget` command.  
To upload *multiple* files using patterns or wildcards, use the `mput` command.

```bash
mget /etc/*.conf
mput ~/doc/*.txt
```

Resume upload/download. Equivalent to `put -a`/`get -a`: 
```bash
reput [-fpR] local-path [remote-path]
reget [-fpR] remote-path [local-path]
```


### Other

Execute command in local shell: `!command`

```bash
help
version
bye # exit
```

# rsync

```bash

```

## TLDR

Transfer files either to or from a remote host (but not between two remote hosts), by default using SSH.
To specify a *remote* path, use `user@hostname:path/to/file_or_directory`.

```bash
rsync -e 'ssh -p 2222 -i ~/.ssh/id_rsa' -avz /path/to/src 2 user@host:/path/to/destination
```

```bash
  More information: https://download.samba.org/pub/rsync/rsync.1.

  - Transfer a file:
    rsync path/to/source path/to/destination

  - Use archive mode (recursively copy directories, copy symlinks without resolving, and preserve permissions, ownership and modification times):
    rsync [-a|--archive] path/to/source path/to/destination

  - Compress the data as it is sent to the destination, display verbose and human-readable progress, and keep partially transferred files if interrupted:
    rsync [-zvhP|--compress --verbose --human-readable --partial --progress] path/to/source path/to/destination

  - Recursively copy directories:
    rsync [-r|--recursive] path/to/source path/to/destination

  - Transfer directory contents, but not the directory itself:
    rsync [-r|--recursive] path/to/source/ path/to/destination

  - Use archive mode, resolve symlinks, and skip files that are newer on the destination:
    rsync [-auL|--archive --update --copy-links] path/to/source path/to/destination

  - Transfer a directory from a remote host running `rsyncd` and delete files on the destination that do not exist on the source:
    rsync [-r|--recursive] --delete rsync://host:path/to/source path/to/destination

  - Transfer a file over SSH using a different port than the default (22) and show global progress:
    rsync [-e|--rsh] 'ssh -p port' --info=progress2 host:path/to/source path/to/destination
```
