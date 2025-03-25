To allow different users, including `sudo` or `root`, to share the same Neovim configuration file (and other configuration files), you need to ensure that the configuration file (typically `init.vim` or `init.lua`) is readable and writable by all users who need to access it.

Here’s a general guide on how to set this up:

### 1. **Place the Configuration in a Shared Location**

Instead of using the default location (`~/.config/nvim`), you can store the Neovim configuration in a directory that both your user and `sudo` (or `root`) can access. For example, you can place it in a directory like `/etc/nvim` or `/opt/nvim_config`.

#### Example: Shared Configuration in `/etc/nvim`

1. Create a shared directory:

   ```bash
   sudo mkdir -p /etc/nvim
   ```

2. Copy your configuration files into the shared directory:

   ```bash
   cp ~/.config/nvim/init.vim /etc/nvim/
   cp ~/.config/nvim/init.lua /etc/nvim/  # If using Lua config
   ```

3. Change ownership of the shared directory and configuration files so that both your user and `root` can access them. Use `chown` and `chmod` to set the appropriate permissions:

   ```bash
   sudo chown -R $USER:root /etc/nvim
   sudo chmod -R 755 /etc/nvim
   ```

   This ensures that your user and root can read and modify the files, but other users cannot unless explicitly allowed.

### 2. **Set up `nvim` to Use the Shared Configuration**

Now you need to tell both your user and root to use the shared configuration.

#### For your normal user:
Modify your `~/.bashrc` or `~/.zshrc` to set the `XDG_CONFIG_HOME` environment variable to the shared configuration directory.

Add this line to your shell configuration (`~/.bashrc` or `~/.zshrc`):

```bash
export XDG_CONFIG_HOME=/etc/nvim
```

This tells Neovim to look for its configuration in `/etc/nvim`.

#### For `root` or `sudo`:
When you switch to `root` (via `sudo` or `su`), the `$HOME` directory might be different (typically `/root`). To make sure `root` uses the same shared configuration, you can either set the `XDG_CONFIG_HOME` variable for `root` in `/root/.bashrc` (or `/root/.zshrc`), or you can directly call Neovim with the `XDG_CONFIG_HOME` set.

For example, add the following to `/root/.bashrc`:

```bash
export XDG_CONFIG_HOME=/etc/nvim
```

Or, you can run Neovim with the `XDG_CONFIG_HOME` environment variable explicitly set, like this:

```bash
sudo XDG_CONFIG_HOME=/etc/nvim nvim
```

### 3. **Alternative: Symbolic Link**

If you prefer to keep the configuration in the default `~/.config/nvim` directory but want to share it between users, you can create a symbolic link from the shared directory to each user's Neovim configuration directory.

1. Move your current configuration to a shared location, such as `/etc/nvim`:
   
   ```bash
   sudo mv ~/.config/nvim /etc/nvim
   ```

2. Create a symbolic link from `~/.config/nvim` to the shared location:

   ```bash
   ln -s /etc/nvim ~/.config/nvim
   ```

3. Make sure both your user and `root` can access the shared directory with appropriate permissions:

   ```bash
   sudo chown -R $USER:root /etc/nvim
   sudo chmod -R 755 /etc/nvim
   ```

### 4. **Handling Permissions**
Ensure that the configuration files have appropriate permissions so that both your user and `root` can read and write them:

```bash
sudo chown -R $USER:root /etc/nvim
sudo chmod -R 755 /etc/nvim
```

This ensures that:
- The user has full access (read/write).
- `root` can also read/write.
- Others (non-root users) can read, but not modify, the files.

### 5. **Optional: Sharing Plugins and Other Files**

If you want to share additional directories, such as the `autoload`, `plugin`, or `colors` directories, you can similarly make sure they are located in the shared directory (`/etc/nvim` or another location) and ensure proper permissions are set.

For example:

```bash
sudo mkdir -p /etc/nvim/autoload
sudo mkdir -p /etc/nvim/plugin
sudo mkdir -p /etc/nvim/colors
```

Then move the corresponding directories from `~/.config/nvim` to `/etc/nvim`:

```bash
sudo mv ~/.config/nvim/autoload /etc/nvim/
sudo mv ~/.config/nvim/plugin /etc/nvim/
sudo mv ~/.config/nvim/colors /etc/nvim/
```

### Conclusion

By storing your Neovim configuration in a shared location like `/etc/nvim` and ensuring proper ownership and permissions, you can easily allow multiple users, including `root`, to share the same configuration. This setup works for most systems and gives you the flexibility to manage your Neovim configuration centrally while still allowing both regular users and `root` to access and modify it.
