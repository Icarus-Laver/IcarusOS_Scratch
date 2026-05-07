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
    cli
    cld

    ; Set up stack for 32-bit mode
    mov esp, stack_top

    ; Load 64-bit GDT
    lgdt [gdt_descriptor]

    ; Enable PAE
    mov eax, cr4
    or eax, 0x20
    mov cr4, eax

    ; Clear page-table area: 0x1000 - 0x4FFF
    mov edi, 0x1000
    xor eax, eax
    mov ecx, 4096
    rep stosd

    ; PML4[0] -> PDPT at 0x2000
    mov dword [0x1000], 0x2003
    mov dword [0x1004], 0x0000

    ; PDPT[0] -> PD at 0x3000
    mov dword [0x2000], 0x3003
    mov dword [0x2004], 0x0000

    ; PD[0] -> 2MB huge page at physical 0x00000000
    ; 0x83 = present | writable | huge page
    mov dword [0x3000], 0x0083
    mov dword [0x3004], 0x0000

    ; Load PML4 address into CR3
    mov eax, 0x1000
    mov cr3, eax

    ; Enable long mode via EFER MSR
    mov ecx, 0xc0000080
    rdmsr
    or eax, 0x100
    wrmsr

    ; Enable paging + protected mode
    mov eax, cr0
    or eax, 0x80000001
    mov cr0, eax

    ; Far jump into 64-bit code
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
