#ifndef KERNEL_H
#define KERNEL_H

#include <stddef.h>
#include <stdint.h>

/* VGA functions */
void vga_init(void);
void vga_clear(void);
void vga_putc(char c);
void vga_puts(const char *str);

/* Serial port functions */
void serial_init(void);
void serial_putc(char c);
void serial_puts(const char *str);

/* GDT functions */
void gdt_init(void);

/* IDT functions */
void idt_init(void);

#endif
