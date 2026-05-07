# Icarus OS Architecture

## Overview

Icarus OS is a modular operating system designed for x86_64 architecture. It follows a classic monolithic kernel design with clear separation between bootloader, kernel, and userspace.

## Components

### Bootloader (boot/)

- **boot.asm** - Multiboot2-compliant bootloader
  - Loads 64-bit long mode
  - Sets up initial paging
  - Hands control to kernel
  
- **linker.ld** - Linker script for kernel layout
- **grub.cfg** - GRUB2 configuration

### Kernel (kernel/)

- **kernel.c** - Main kernel code
- **kernel.h** - Kernel header definitions
- **vga.c** - VGA text mode driver
- **interrupts.asm** - IDT setup
- **gdt.asm** - GDT setup (actually in bootloader)

### C Library (libc/)

- **crt0.asm** - C runtime initialization
- **stddef.h** - Standard definitions
- **stdint.h** - Integer type definitions

### Userspace (userspace/)

(To be implemented)

- Shell
- System utilities
- User programs

## Build Process

```
Makefile
  ├─> boot.asm (nasm) -> boot.o
  ├─> kernel.c (gcc) -> kernel.o
  ├─> vga.c (gcc) -> vga.o
  ├─> interrupts.asm (nasm) -> interrupts.o
  ├─> crt0.asm (nasm) -> crt0.o
  └─> Link with linker.ld -> kernel.bin
      └─> grub-mkrescue -> icarusos.iso

Then boot with QEMU:
qemu-system-x86_64 -cdrom icarusos.iso
```

## Memory Layout

```
0x000000 - 0x0FFFFF   | Real mode area (not used in long mode)
0x100000 - 0x10FFFF   | Kernel (.text, .data, .bss)
0x110000+             | Heap (to be implemented)
```

## Next Steps

1. ✅ Basic bootloader and kernel skeleton
2. ⏳ Implement proper GDT and IDT
3. ⏳ Interrupt handlers
4. ⏳ Memory management (paging, heap)
5. ⏳ Process/thread management
6. ⏳ File system
7. ⏳ Userspace and shell
