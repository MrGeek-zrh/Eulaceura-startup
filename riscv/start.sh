#!/bin/sh

# Default values
BIOS_FILE="fw_payload_oe_uboot_2304.bin"
DISK_IMAGE="Eulaceura.riscv64-22H1-Server_vm.R1.qcow2"

# Help function
print_usage() {
    echo "Usage: $0 [-b bios_file] [-d disk_image]"
    echo "Options:"
    echo " -b Path to BIOS file (default: $BIOS_FILE)"
    echo " -d Path to disk image file (default: $DISK_IMAGE)"
    echo " -h Display this help message"
    exit 1
}

# Parse command line arguments
while getopts "b:d:h" opt; do
    case $opt in
        b)
            BIOS_FILE="$OPTARG"
            ;;
        d)
            DISK_IMAGE="$OPTARG"
            ;;
        h)
            print_usage
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            print_usage
            ;;
    esac
done

# Check if files exist
if [ ! -f "$BIOS_FILE" ]; then
    echo "Error: BIOS file '$BIOS_FILE' not found!"
    exit 1
fi

if [ ! -f "$DISK_IMAGE" ]; then
    echo "Error: Disk image '$DISK_IMAGE' not found!"
    exit 1
fi

# Launch QEMU with shared network
qemu-system-riscv64 \
    -smp 1 -m 2G \
    -machine virt \
    -bios "$BIOS_FILE" \
    -device virtio-blk-device,drive=hd0 \
    -drive file="$DISK_IMAGE",if=none,id=hd0,format=qcow2 \
    -device virtio-net-device,netdev=net0 \
    -netdev user,id=net0,hostfwd=tcp:127.0.0.1:2222-:22,hostfwd=tcp::2222-:22 \
    -nographic \
    -fsdev local,id=fs0,path=./shared,security_model=none \
    -device virtio-9p-device,fsdev=fs0,mount_tag=hostshare \

