# Icarus OS Makefile

AS = nasm
CC = gcc
ASFLAGS = -f elf64
CFLAGS = -ffreestanding -fno-stack-protector -fno-builtin -fno-pic -mno-red-zone -mno-mmx -mno-sse -mno-sse2 -Wall -Wextra -O2
LDFLAGS = -ffreestanding -nostdlib -fno-PIE -no-pie -lgcc

BOOT_SRC = boot/bootloader.asm
KERNEL_SRC = kernel/kernel.c kernel/vga.c kernel/gdt.c kernel/interrupts.c
KERNEL_OBJ = $(KERNEL_SRC:.c=.o) boot/boot.o

TARGET = icarusos.iso
KERNEL_BIN = kernel.bin

.PHONY: all clean run

all: $(TARGET)

$(TARGET): $(KERNEL_BIN)
	mkdir -p iso/boot/grub
	cp $(KERNEL_BIN) iso/boot/
	cp boot/grub.cfg iso/boot/grub/
	grub-mkrescue -o $(TARGET) iso

$(KERNEL_BIN): $(KERNEL_OBJ) libc/crt0.o
	$(CC) $(LDFLAGS) -T boot/linker.ld -o $@ $^

boot/boot.o: boot/boot.asm
	$(AS) $(ASFLAGS) $< -o $@

kernel/%.o: kernel/%.c
	$(CC) $(CFLAGS) -I. -c $< -o $@

libc/crt0.o: libc/crt0.asm
	$(AS) $(ASFLAGS) $< -o $@

clean:
	rm -rf *.o **/*.o $(KERNEL_BIN) $(TARGET) iso/

run: $(TARGET)
	qemu-system-x86_64 -cdrom $(TARGET) -m 256

debug: $(TARGET)
	qemu-system-x86_64 -cdrom $(TARGET) -m 256 -s -S
