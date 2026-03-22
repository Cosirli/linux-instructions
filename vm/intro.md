

```bash
sudo pacman -S libvirt qemu-full virt-manager virt-install bridge-utils dnsmasq openbsd-netcat swtpm
sudo systemctl enable --now libvirtd
sudo virsh net-start default
sudo virsh net-autostart default
sudo usermod -aG libvirt $(whoami)
sudo vi /etc/libvirt/qemu.conf  # user = "YOUR_USERNAME" # group = "libvirt"
sudo systemctl restart libvirtd
```

Nested virtulization


- temporary
```bash
# modprobe kvm_amd nested=1
modprobe kvm_intel nested=1
```

- permanent
```bash
sudo vi /etc/modprobe.d/kvm_intel.conf # options kvm_intel nested=1
sudo mkinitcpio -P
```


