; Interrupt Descriptor Table (IDT) setup for x86_64

extern idt_table

section .text

global idt_init
idt_init:
    ; Load IDT
    mov rax, idt_descriptor
    lidt [rax]
    ret

section .data
align 16
idt_descriptor:
    dw 0x0fff  ; Limit (256 entries * 16 bytes - 1)
    dq idt_table

; Stub IDT table (all uninitialized for now)
section .data
align 16
global idt_table
idt_table:
    resq 256 * 2  ; 256 entries, 16 bytes each (2 qwords)
