#!/bin/bash
# Test script for Icarus OS

cd "$(dirname "$0")" || exit 1

echo "Building Icarus OS..."
make clean && make

if [ $? -ne 0 ]; then
    echo "Build failed!"
    exit 1
fi

echo ""
echo "=========================================="
echo "Starting Icarus OS in QEMU"
echo "=========================================="
echo ""
echo "You should see a terminal window with:"
echo "  - '=== Icarus OS ===' as the title"
echo "  - 'Kernel loaded and running'"
echo "  - 'x86_64 architecture'"
echo "  - 'IDT initialized'"
echo "  - 'Kernel halting...'"
echo ""
echo "If you don't see output:"
echo "  1. The bootloader may not be running correctly"
echo "  2. The kernel may be crashing before VGA output"
echo "  3. The GDT/IDT initialization may have an issue"
echo ""
echo "Close the QEMU window to exit."
echo ""

qemu-system-x86_64 -cdrom icarusos.iso -m 256
