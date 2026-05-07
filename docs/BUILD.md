# Build and Development Guide

## Prerequisites

```bash
# Ubuntu/Debian
sudo apt-get install build-essential nasm grub-pc-bin xorriso qemu-system-x86

# Fedora/RHEL
sudo dnf install gcc nasm grub2-tools xorriso qemu-system-x86

# macOS
brew install nasm qemu grub
```

## Building

```bash
# Build the OS
make

# Clean build artifacts
make clean
```

## Running

```bash
# Run in QEMU
make run

# Debug with QEMU
make debug
```

When running with `make debug`, you can connect a GDB debugger:
```bash
gdb kernel.bin
(gdb) target remote :1234
(gdb) break kernel_main
(gdb) continue
```

## Project Structure Notes

- Bootloader must be compiled as 32-bit code initially, then switches to 64-bit
- Kernel is compiled as 64-bit only
- All code is position-independent where possible
- Proper alignment is crucial for data structures (GDT, IDT, paging)

## Debugging Tips

- Use `make debug` to run with GDB support
- Check QEMU output for kernel messages
- VGA output is the primary debugging tool
- Add `vga_puts()` calls to trace execution

## Common Issues

1. **Bootloader not found**: Ensure GRUB can find the kernel. Check grub.cfg
2. **Triple fault**: Usually indicates invalid GDT/IDT or memory corruption
3. **No output**: Check VGA memory location (0xb8000)
4. **Compilation errors**: Ensure correct calling conventions (System V AMD64 ABI)
