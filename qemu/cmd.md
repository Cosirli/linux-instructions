```bash
qemu-img create -f qcow2 arch-kvm.qcow2 20G
qemu-system-x86_64 -enable-kvm \
    -cpu host \
    -smp 4 \
    -m 4G \
    -drive file=arch-kvm.qcow2,format=qcow2,if=virtio \
    -cdrom /home/leon/dat/iso/archlinux-2026.03.01-x86_64.iso \
    -net nic,model=virtio -net user \
    -display none -nographic -serial mon:stdio \
    -boot menu=on
```

- `smp`: virtual CPUs
- 



```bash
virsh attach-disk debian13 ~/dat/iso/archlinux-2026.01.01-x86_64.iso sddebian --type cdrom --mode readonly --config
virsh start debian13
virsh shutdown debian13
```
