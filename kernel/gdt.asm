; GDT (Global Descriptor Table) setup for x86_64

extern gdt64

section .text

global gdt_init
gdt_init:
    ; Load GDT is already done in bootloader
    ret
