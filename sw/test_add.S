# Premier programme : quelques addi / add. Résultats attendus en fin de programme :
# x1=5  x2=7  x3=12  x4=17  x5=0xFFFFFFFB (-5)
    .section .text.init
    .globl _start
_start:
    addi x1, x0, 5
    addi x2, x0, 7
    add  x3, x1, x2
    addi x4, x3, 5
    sub  x5, x0, x1
end:
    j end
