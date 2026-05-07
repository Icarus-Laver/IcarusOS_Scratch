# Icarus OS

A x86_64 operating system built from scratch in C and Assembly, targeting QEMU/VirtualBox.

## Project Structure

- **boot/** - Bootloader (x86_64 multiboot)
- **kernel/** - Core kernel (process management, memory, interrupts)
- **libc/** - C standard library implementation
- **userspace/** - User programs and shell
- **tools/** - Build tools and utilities
- **docs/** - Documentation and specifications

## Requirements

- `gcc` - C compiler (with x86_64 support)
- `nasm` - Assembly assembler
- `make` - Build automation
- `qemu-system-x86_64` - For testing
- `grub-mkrescue` - For creating bootable ISO

## Build

```bash
make
```

This will compile the bootloader, kernel, and create a bootable ISO image.

## Run

```bash
make run
```

Launches the OS in QEMU.

## Development Stages

1. **Stage 1** - Bootloader (multiboot, load kernel into memory)
2. **Stage 2** - Basic kernel (GDT, IDT, interrupts)
3. **Stage 3** - Memory management (paging, heap)
4. **Stage 4** - Process management (basic scheduling)
5. **Stage 5** - File system (simple FAT or ext2)
6. **Stage 6** - User space and shell
7. **Stage 7** - System utilities and libraries
