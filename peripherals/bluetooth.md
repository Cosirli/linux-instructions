## Configuring and pairing Bluetooth devices on Arch Linux.

### 1. **Install Bluetooth Utilities**
First, ensure that the necessary Bluetooth tools are installed.

#### Install Bluetooth and related packages:

```bash
sudo pacman -S bluez bluez-utils blueman pulseaudio-bluetooth pulseaudio pavucontrol
```

- **bluez**: The core Bluetooth protocol stack.
- **bluez-utils**: Utilities for managing Bluetooth devices.

#### Enable and start the Bluetooth service:

```bash
sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service
```

This will ensure that the Bluetooth service starts automatically on boot.

### 2. **Verify Bluetooth Device**
Make sure your Bluetooth device is detected:

```bash
lsusb | grep -i bluetooth
lspci | grep -i bluetooth
```

These commands will help you check if your system recognizes the Bluetooth hardware.

### 3. **Use `bluetoothctl` to Pair Devices**
`bluetoothctl` is a command-line utility for managing Bluetooth devices.

```bash
bluetoothctl
```

Once inside the `bluetoothctl` shell, you can use the following commands:

- **Turn on the Bluetooth controller** (if it's not already enabled):

    ```bash
    power on
    ```

- **Enable agent** (to allow pairing):

    ```bash
    agent on
    default-agent
    ```

- **Start scanning for devices**:

    ```bash
    scan on
    ```

    This will start scanning for nearby Bluetooth devices. You will see a list of available devices appear.

- **Pair with a device**:

    Once you've found the device you want to pair with (you'll see something like `XX:XX:XX:XX:XX:XX` for the device address), use:

    ```bash
    pair XX:XX:XX:XX:XX:XX
    ```

    Replace `XX:XX:XX:XX:XX:XX` with the Bluetooth MAC address of your device.

- **Trust the device**:

    ```bash
    trust XX:XX:XX:XX:XX:XX
    ```

    This will ensure that the device automatically connects in the future.

- **Connect to the device**:

    ```bash
    connect XX:XX:XX:XX:XX:XX
    ```

    This command will establish a connection with the paired device.

- **Exit `bluetoothctl`**:

    ```bash
    exit
    ```

### 4. **Test the Connection**
Once paired and connected, you can test the connection with the device (for example, for audio or file transfers).

#### Audio:
If you're using Bluetooth audio devices (headphones or speakers), you may need to install PulseAudio Bluetooth support:

```bash
sudo pacman -S pulseaudio-bluetooth
```

Then restart the PulseAudio service:

```bash
pulseaudio --start
```

After that, your Bluetooth audio device should show up in your audio settings.

#### File Transfers:
For file transfers, you can use the `obexftp` tool:

```bash
sudo pacman -S obexftp
```

This will allow you to transfer files between your system and your Bluetooth device.

---

### Troubleshooting:

- **Missing Bluetooth device**: If the Bluetooth device isn't showing up, try rebooting your system or checking if the Bluetooth adapter is properly connected.

---

To set up automatic Bluetooth earbud connection on Arch Linux after pairing, you need to ensure that your Bluetooth service is properly configured and your system is able to reconnect to the device without manual intervention.

---

### Auto-connect to your Bluetooth earbuds:

---

### 1. **Ensure Proper Bluetooth Configuration**
Make sure you have paired and trusted your Bluetooth earbuds using `bluetoothctl` as described previously.

Once paired, ensure your earbuds are trusted:

```bash
bluetoothctl
# Inside bluetoothctl
trust XX:XX:XX:XX:XX:XX  # Replace with your earbuds MAC address
```

The `trust` command ensures that your system will automatically connect to the device when it's in range.

### 2. **Install `pulseaudio-bluetooth` for Audio Support**

```bash
sudo pacman -S pulseaudio-bluetooth
```

After installing the package, restart the PulseAudio service:

```bash
pulseaudio --start
```

### 3. **Enable `bluetooth` Service on Boot**

```bash
sudo systemctl enable bluetooth
```

### 4. **Create a `bluetooth-autoconnect` Service (Optional)**

If you want to automate the connection process further (for example, connecting to your Bluetooth earbuds as soon as they're powered on), you can use a custom systemd service to automatically connect.

#### Create a systemd service:

1. Create a new service file for autoconnect:

   ```bash
   sudo nano /etc/systemd/system/bluetooth-autoconnect.service
   ```

2. Add the following content to the file, modifying the `XX:XX:XX:XX:XX:XX` with your earbuds’ MAC address:

   ```ini
   [Unit]
   Description=Bluetooth Auto Connect to Earbuds
   After=bluetooth.service

   [Service]
   Type=oneshot
   ExecStart=/usr/bin/bluetoothctl connect XX:XX:XX:XX:XX:XX
   ExecStartPost=/usr/bin/bluetoothctl connect YY:YY:YY:YY:YY:YY  # Earbuds 2
   TimeoutStartSec=30
   Restart=no

   [Install]
   WantedBy=default.target
   ```

   - The `ExecStart` command connects to the Bluetooth device automatically.
   - `TimeoutStartSec` gives the system some time to establish the connection.
   - `Restart=no` ensures the service does not attempt to reconnect continuously.

3. Save the file and exit the editor.

4. Enable the service to run at boot:

   ```bash
   sudo systemctl enable bluetooth-autoconnect.service
   ```

5. Start the service immediately (optional):

   ```bash
   sudo systemctl start bluetooth-autoconnect.service
   ```

### 5. **Check Auto-Connect Behavior**
With this setup, your Bluetooth earbuds should automatically connect when the system boots up or when you power on the earbuds (provided they're in range). The systemd service will handle the connection process on boot.

### 6. **Optional: Use `blueman` (Graphical Tool)**
If you prefer a graphical tool for managing Bluetooth devices, you can install **blueman**:

```bash
sudo pacman -S blueman
```

`Blueman` has options for automatically connecting devices and managing Bluetooth connections easily through the GUI.

---

### Troubleshooting Auto-Connection:
- **Earbuds Not Connecting**: Make sure the Bluetooth device is trusted. Also, check the system logs for any errors related to Bluetooth:

  ```bash
  journalctl -xe | grep bluetooth
  ```

- **Audio Issues**: If you're using Bluetooth earbuds for audio and they don't connect correctly, ensure PulseAudio is managing the Bluetooth device. You may need to restart PulseAudio or reconnect manually once to set it as the default audio device.

  ```bash
  pulseaudio --start
  ```

---

This setup should help you get Bluetooth earbuds connected automatically to your Arch Linux system after pairing. Let me know if you need further assistance!
