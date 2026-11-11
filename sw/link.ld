ENTRY(_start)
SECTIONS {
  . = 0x00000000;
  .text : { *(.text.init) *(.text*) }
  .rodata : { *(.rodata*) }
  .data : { *(.data*) }
  .bss : { *(.bss*) }
  _stack_top = 0x00001000;
}
