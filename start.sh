#!/bin/sh
dd if=/dev/zero of=varstore.img bs=1M count=64

qemu-system-aarch64 \
    -machine virt,accel=hvf \
    -cpu host \
    -m 6G \
    -smp 2 \
    -bios /opt/homebrew/share/qemu/edk2-aarch64-code.fd \
    -drive file=Eulaceura.aarch64-22H1-Server_vm.R1.qcow2,if=virtio \
    -device virtio-net-pci,netdev=net0 \
    -netdev user,id=net0 \
    -nographic \
    -drive if=pflash,format=raw,unit=1,file=varstore.img,size=64M \
    -fsdev local,id=fs0,path=./riscv,security_model=none \
    -device virtio-9p-device,fsdev=fs0,mount_tag=hostshare

