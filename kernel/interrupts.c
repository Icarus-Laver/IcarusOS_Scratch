#include "kernel.h"

/* Interrupt Descriptor Table entry structure */
typedef struct {
    uint16_t offset_low;
    uint16_t selector;
    uint8_t ist;
    uint8_t type_flags;
    uint16_t offset_mid;
    uint32_t offset_high;
    uint32_t reserved;
} idt_entry_t;

typedef struct {
    uint16_t limit;
    uint64_t base;
} idt_descriptor_t;

#define IDT_ENTRIES 256

static idt_entry_t idt_entries[IDT_ENTRIES];
static idt_descriptor_t idt_descriptor;

void idt_set_entry(int index, uint64_t offset, uint16_t selector, uint8_t type)
{
    idt_entries[index].offset_low = (offset & 0xffff);
    idt_entries[index].offset_mid = ((offset >> 16) & 0xffff);
    idt_entries[index].offset_high = ((offset >> 32) & 0xffffffff);
    
    idt_entries[index].selector = selector;
    idt_entries[index].type_flags = type;
    idt_entries[index].ist = 0;
    idt_entries[index].reserved = 0;
}

void idt_init(void)
{
    idt_descriptor.limit = (sizeof(idt_entry_t) * IDT_ENTRIES) - 1;
    idt_descriptor.base = (uint64_t)&idt_entries[0];
    
    /* Initialize all entries to zero (dummy handlers) */
    for (int i = 0; i < IDT_ENTRIES; i++) {
        idt_set_entry(i, 0, 0x08, 0x8e);  /* Gate type: Interrupt gate */
    }
    
    /* Load the IDT */
    asm volatile("lidt %0" : : "m"(idt_descriptor));
    
    /* Don't enable interrupts yet - no handlers installed */
    /* asm volatile("sti"); */
}
