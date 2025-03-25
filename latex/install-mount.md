# Install
Use the online installer.
```bash
tar -xzvf install-tl-unx.tar.gz
sudo perl ./install-tl
```

# Config

I encountered some permission issues. At the beginning after you finished the installation steps, only the root can run latex commands. Even `sudo` fails to run the commands and modifying the environment variables helped nothing.  

To make `sudo` available to these commands, you have to `visudo` and add `/usr/local/texlive/2025/bin/x86_64-linux` to `secure_path`.
