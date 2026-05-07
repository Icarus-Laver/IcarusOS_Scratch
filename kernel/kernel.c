#include "kernel.h"

void kernel_main(void)
{
    /* Initialize VGA output */
    vga_init();
    vga_clear();
    
    /* Display startup messages */
    vga_puts("=== Icarus OS ===\n");
    vga_puts("Kernel loaded and running\n");
    vga_puts("x86_64 architecture\n");
    
    vga_puts("Kernel halting...\n");
    
    /* Halt forever */
    while(1) {
        asm("hlt");
    }
}
