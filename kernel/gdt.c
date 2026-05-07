#include "kernel.h"

/* Global Descriptor Table entry structure */
typedef struct {
    uint16_t limit_low;
    uint16_t base_low;
    uint8_t base_mid;
    uint8_t access;
    uint8_t granularity;
    uint8_t base_high;
} gdt_entry_t;

typedef struct {
    uint16_t limit;
    uint64_t base;
} gdt_descriptor_t;

#define GDT_ENTRIES 6

static gdt_entry_t gdt_entries[GDT_ENTRIES];
static gdt_descriptor_t gdt_descriptor;

void gdt_set_entry(int index, uint32_t base, uint32_t limit, uint8_t access, uint8_t granularity)
{
    gdt_entries[index].base_low = (base & 0xffff);
    gdt_entries[index].base_mid = ((base >> 16) & 0xff);
    gdt_entries[index].base_high = ((base >> 24) & 0xff);
    
    gdt_entries[index].limit_low = (limit & 0xffff);
    gdt_entries[index].granularity = ((limit >> 16) & 0x0f);
    
    gdt_entries[index].granularity |= (granularity & 0xf0);
    gdt_entries[index].access = access;
}

void gdt_init(void)
{
    /* GDT is already initialized by the bootloader in long mode.
     * We don't reload it here to avoid issues with the bootloader's
     * carefully configured segment descriptors. */
}
