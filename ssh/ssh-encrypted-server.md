# LUKS Decrypt via SSH

How to remotely unlock a LUKS-encrypted partition via ssh? Whether it is a server, or an encrypted KVM.

## Debian

The Debian server should install Dropbear first

```bash
sudo apt install dropbear-initramfs
```

#### On the client, 

Generate and copy keys:

```bash
ssh-keygen -t rsa -b 4096 -C "LUKS decryption for debian vm" -f $HOME/.ssh/rsa_debianvm_decrypt
scp -i ~/.ssh/rsa_debianvm_decrypt ~/.ssh/rsa_debianvm_decrypt.pub root@192.168.1.2:/etc/dropbear/initramfs/authorized_keys
```

ssh config:

```bash
Host debianvm-decrypt
    HostName 192.168.1.2
    User root
    Port 2222
    IdentityFile ~/.ssh/rsa_debianvm_decrypt
    IdentitiesOnly yes
# RequestTTY yes
```

#### One the server

Verify public key:

```bash
chmod 600 /etc/dropbear/initramfs/authorized_keys
ls -l
```

Configure DHCP and update GRUB:

```bash
vi /etc/default/grub
# change the line to: GRUB_CMDLINE_LINUX_DEFAULT="quiet ip=:::::eno1:dhcp"

update-grub
```

Configure unlock:

```bash
echo 'DROPBEAR_OPTIONS="-I 180 -RFEsjk -p 2222 -c /usr/bin/cryptroot-unlock"' >> /etc/dropbear/initramfs/dropbear.conf
```

- `-I`: timeout
- `-s`: disable password logins
- `-j`: disable ssh local port forwarding
- `-k`: disable remote port forwarding
- `-c`: forced command


Generate initramfs:

```bash
update-initramfs -k all -u
```


After reboot, we can unlock it remotely:

```bash
ssh debianvm-decrypt
```

Or

```bash
ssh root@192.168.1.2 -i ~/.ssh/rsa_debianvm_decrypt -o IdentitiesOnly=yes -p 2222
```


## References

[Remotely Unlock an Encrypted Linux Server Using Dropbear](https://www.dwarmstrong.org/remote-unlock-dropbear/)
