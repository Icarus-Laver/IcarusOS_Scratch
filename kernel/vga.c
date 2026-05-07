#include "kernel.h"

#define VGA_ADDRESS 0xb8000
#define VGA_WIDTH 80
#define VGA_HEIGHT 25

typedef struct {
    uint8_t character;
    uint8_t color;
} vga_char_t;

static vga_char_t *vga_buffer = (vga_char_t *)VGA_ADDRESS;
static int vga_row = 0;
static int vga_col = 0;

void vga_init(void)
{
    vga_buffer = (vga_char_t *)VGA_ADDRESS;
    vga_row = 0;
    vga_col = 0;
}

void vga_clear(void)
{
    for (int i = 0; i < VGA_WIDTH * VGA_HEIGHT; i++) {
        vga_buffer[i].character = ' ';
        vga_buffer[i].color = 0x07;  /* Light gray on black */
    }
    vga_row = 0;
    vga_col = 0;
}

void vga_putc(char c)
{
    if (c == '\n') {
        vga_col = 0;
        vga_row++;
    } else {
        int index = vga_row * VGA_WIDTH + vga_col;
        vga_buffer[index].character = c;
        vga_buffer[index].color = 0x07;
        vga_col++;
    }
    
    if (vga_col >= VGA_WIDTH) {
        vga_col = 0;
        vga_row++;
    }
    
    if (vga_row >= VGA_HEIGHT) {
        /* Scroll up */
        for (int i = 0; i < (VGA_HEIGHT - 1) * VGA_WIDTH; i++) {
            vga_buffer[i] = vga_buffer[i + VGA_WIDTH];
        }
        vga_row = VGA_HEIGHT - 1;
        for (int i = vga_row * VGA_WIDTH; i < VGA_HEIGHT * VGA_WIDTH; i++) {
            vga_buffer[i].character = ' ';
            vga_buffer[i].color = 0x07;
        }
    }
}

void vga_puts(const char *str)
{
    while (*str) {
        vga_putc(*str++);
    }
}
