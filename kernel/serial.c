#include "kernel.h"

#define SERIAL_PORT 0x3f8

/* Write byte to I/O port */
static inline void outb(uint16_t port, uint8_t val)
{
    asm volatile("outb %0, %1" : : "a"(val), "Nd"(port));
}

/* Read byte from I/O port */
static inline uint8_t inb(uint16_t port)
{
    uint8_t ret;
    asm volatile("inb %1, %0" : "=a"(ret) : "Nd"(port));
    return ret;
}

void serial_init(void)
{
    /* Disable all interrupts */
    outb(SERIAL_PORT + 1, 0x00);
    
    /* Enable DLAB (set baud rate divisor) */
    outb(SERIAL_PORT + 3, 0x80);
    
    /* Set divisor to 3 (38400 baud) */
    outb(SERIAL_PORT + 0, 0x03);
    outb(SERIAL_PORT + 1, 0x00);
    
    /* Disable DLAB, set 8 bits, no parity, 1 stop bit */
    outb(SERIAL_PORT + 3, 0x03);
    
    /* Enable FIFO, clear queues */
    outb(SERIAL_PORT + 2, 0xc7);
    
    /* Mark the data terminal ready, signal request to send, enable auxiliary output 2 */
    outb(SERIAL_PORT + 4, 0x0b);
}

static int serial_is_transmit_empty(void)
{
    return (inb(SERIAL_PORT + 5) & 0x20) != 0;
}

void serial_putc(char c)
{
    while (!serial_is_transmit_empty());
    outb(SERIAL_PORT, c);
}

void serial_puts(const char *str)
{
    while (*str) {
        if (*str == '\n') {
            serial_putc('\r');
        }
        serial_putc(*str++);
    }
}
