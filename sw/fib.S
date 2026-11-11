# fib.S - calcule fib(10). A la fin: x1 = 55 (0x37)
    .section .text.init
    .globl _start
_start:
    addi x1, x0, 0
    addi x2, x0, 1
    addi x3, x0, 10
loop:
    beq  x3, x0, done
    add  x4, x1, x2
    addi x1, x2, 0
    addi x2, x4, 0
    addi x3, x3, -1
    j    loop
done:
    j    done
