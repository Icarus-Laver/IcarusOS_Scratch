/* Icarus OS Linker Script */

ENTRY(_start)

SECTIONS
{
    . = 0x100000;
    
    .boot :
    {
        KEEP(boot/boot.o(.multiboot_header))
        KEEP(boot/boot.o(.text))
        KEEP(boot/boot.o(.text.*))
        KEEP(boot/boot.o(.data))
    }
    
    .text :
    {
        *(.text)
        *(.text.*)
    }
    
    .rodata :
    {
        *(.rodata)
        *(.rodata.*)
    }
    
    .data :
    {
        *(.data)
        *(.data.*)
    }
    
    .bss :
    {
        *(.bss)
        *(.bss.*)
        *(COMMON)
    }
    
    /DISCARD/ :
    {
        *(.note.GNU-stack)
        *(.gnu_hash)
        *(.gnu.version*)
    }
}
