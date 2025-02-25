# Understanding public key authentication

- **Public-Key Authentication:** Unlike password-based authentication, which relies on something you know (your password), public key authentication utilizes a pair of keys - a **public key** and a **private key**.
- **Public Key:** This key can be shared freely and is placed on the SSH server you want to access.
- **Private Key:** This key is your secret, kept secure on your client machine. It's used to prove your identity to the server possessing the corresponding public key.
- **SSH Key Pair:** Think of it like a lock and key system. The server has the lock (public key), and you have the key (private key) to unlock it.



# Configuring key authentication

## Generate an SSH key pair

````bash
ssh-keygen -t dsa -b 4096 -C "username_on_host@host" -f id_mykey
````



## Copy the public key to the server

Using the `ssh-copy-id` command ensures your key is copied into the correct location (`~/.ssh/authorized_keys`).  

```bash
 ssh-copy-id -i ~/.ssh/id_mykey.pub -p 2291 user1@server_name
```

If this command doesn't work, manually add your public key.  

```bash
ssh user1@server_name -p 2291
mkdir -p ~/.ssh
echo "your-public-key-here" >> ~/.ssh/authorized_keys
```

## Set proper permissions

```
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```



## Ensure you're using the correct key

If you have multiple keys, make sure you're using the correct one when logging in, or you may fail to log in.    

You can specify the private key with the `-i` option.  

```bash
 ssh -i ~/.ssh/id_mykey user1@server_name -p 2291
```



## Configure SSH

```bash
vim ~/.ssh/config
# ...
chmod 600 ~/.ssh/config
```

Example config file:  

```
Host customized_alias
	User user1
	HostName server_name
	Port 2291
	IdentityFile ~/.ssh/id_mykey
```

Now you can:  

```bash
ssh customized_alias
```

which is equivalent to:  

```bash
ssh -i ~/.ssh/id_mykey user1@server_name -p 2291
```



## Changing the passphrase of a private key


To change the passphrase of a private key file instead of creating a new private key (specify a key by the ` -f` option):  

```
$ ssh-keygen -p -f ~/.ssh/id_keyname
```

then provide your old and new passphrase (twice) at the prompts.  