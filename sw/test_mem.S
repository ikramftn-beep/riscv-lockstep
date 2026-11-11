# test_mem.S - teste sw, lw, lb, lbu, lh, lhu, sb, sh
# x10 = adresse de base de la memoire donnees (A ADAPTER)
    .section .text.init
    .globl _start
_start:
    addi x10, x0, 0x400
    lui  x5, 0x80820
    addi x5, x5, -129
    sw   x5, 0(x10)
    lw   x6, 0(x10)
    lb   x7, 0(x10)
    lb   x8, 1(x10)
    lbu  x9, 1(x10)
    lh   x11, 0(x10)
    lhu  x12, 0(x10)
    lh   x13, 2(x10)
    lhu  x14, 2(x10)
    addi x15, x0, 0x55
    sb   x15, 3(x10)
    lw   x16, 0(x10)
    addi x17, x0, 0x123
    sh   x17, 0(x10)
    lw   x18, 0(x10)
end:
    j    end
