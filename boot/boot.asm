; Icarus OS Bootloader
; x86_64 multiboot2 bootloader entry point

extern kernel_main

MAGIC equ 0xe85250d6
ARCH equ 0
HEADER_LENGTH equ header_end - header_start
CHECKSUM equ -(MAGIC + ARCH + HEADER_LENGTH)

section .multiboot_header
align 8
header_start:
    dd MAGIC
    dd ARCH
    dd HEADER_LENGTH
    dd CHECKSUM
    
    ; End tag
    dw 0
    dw 0
    dd 8
header_end:

section .bss
align 16
stack_bottom:
    resb 16384
stack_top:

section .text
bits 32
global _start

_start:
    ; Set up stack for 32-bit mode
    mov esp, stack_top
    
    ; Save multiboot info on stack
    ; eax = magic number (will be passed in rdi in 64-bit)
    ; ebx = multiboot info pointer (will be passed in rsi in 64-bit)
    
    ; Load 64-bit GDT
    lgdt [gdt_descriptor]
    
    ; Enable PAE (Physical Address Extension)
    mov eax, cr4
    or eax, 0x20
    mov cr4, eax
    
    ; Set up page table (identity mapping first 2MB)
    mov edi, 0x1000
    xor eax, eax
    mov ecx, 4096
    rep stosd
    
    mov dword [0x1000], 0x2003
    mov dword [0x2000], 0x3003
    mov dword [0x3000], 0x4003
    
    mov dword [0x4000], 0x0000003f  ; 0MB-2MB
    
    ; Load page directory
    mov eax, 0x1000
    mov cr3, eax
    
    ; Enable long mode
    mov ecx, 0xc0000080
    rdmsr
    or eax, 0x100
    wrmsr
    
    ; Enable paging
    mov eax, cr0
    or eax, 0x80000001
    mov cr0, eax
    
    ; Jump to 64-bit code
    jmp 0x08:long_mode_start

bits 64
long_mode_start:
    ; Set up data segments
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    
    ; Call kernel_main
    call kernel_main
    
    ; Kernel should never return
kernel_halt:
    cli
    hlt
    jmp kernel_halt

section .data
align 16
gdt64:
    dq 0
    ; Code segment
    dq 0x00209a0000000000
    ; Data segment
    dq 0x0000920000000000

gdt_descriptor:
    dw $ - gdt64 - 1
    dq gdt64
