OUTPUT_ARCH( "riscv" )
ENTRY(_start)
MEMORY
{
    STACK(xrw) : ORIGIN = 0xA00000, LENGTH = (0x1c00 + 0x400 + 0x400)
    SRAM(xrw) : ORIGIN = 0xA00000 + (0x1c00 + 0x400 + 0x400), LENGTH = 0x20000 - (0x1c00 + 0x400 + 0x400)
    LOADERBOOT_ROM_ADDR(xrw): ORIGIN = ((0xA00000 + 0x20000) + 0x380), LENGTH = 0xA000
}
SECTIONS
{
    .text.entry :
    {
        . = ALIGN(4);
        KEEP(*(.text.entry))
        KEEP (*(.isr_vector))
        . = ALIGN(4);
    } > LOADERBOOT_ROM_ADDR
    .stacks (NOLOAD) :
    {
        . = ALIGN(16);
        g_system_stack_begin = ORIGIN(STACK);
        . += 0x1c00;
        __stack_top__ = .;
        . += 0x400;
        __irq_stack_top__ = .;
        . += 0x400;
        __excp_stack_top__ = .;
        . = ALIGN(16);
        g_system_stack_end = ORIGIN(STACK) + LENGTH(STACK);
    } > STACK
    .text :
    {
        . = ALIGN(4);
        *(.text)
        *(.text*)
        *(.rodata)
        *(.rodata*)
        *(.srodata)
        *(.srodata*)
        KEEP (*(.flashtext))
        KEEP (*(.flashtext*))
        . = ALIGN(4);
    } > LOADERBOOT_ROM_ADDR
    .data :
    {
        FILL(0xFF)
        . = ALIGN(4);
        __data_load__ = LOADADDR(.data);
        . = ALIGN(4);
        __data_begin__ = .;
        *(.data)
        *(.data*)
        *(.got)
        *(.got*)
        *(.igot)
        *(.igot*)
        _gp_ = . + 0x800;
        *(.sdata)
        *(.sdata*)
        . = ALIGN(4);
        __data_end__ = .;
    } > SRAM AT > LOADERBOOT_ROM_ADDR
    __data_size__ = __data_end__ - __data_begin__;
    .bss (NOLOAD) :
    {
        . = ALIGN(4);
        __bss_begin__ = .;
        *(.bss)
        *(.bss*)
        *(.sbss)
        *(.sbss*)
        *(COMMON)
        . = ALIGN(4);
        __bss_end__ = .;
    } > SRAM
    .preserve (NOLOAD) :
    {
        . = ALIGN(4);
        __boot_uart_begin__ = .;
        *(BOOT_UART)
        . = ALIGN(4);
        __boot_uart_end__ = .;
    } > SRAM
    .heap (NOLOAD):
    {
        . = ALIGN(8);
        g_intheap_begin = ABSOLUTE(.);
        g_intheap_size = (ORIGIN(SRAM) + LENGTH(SRAM)) - g_intheap_begin;
    } > SRAM
}
