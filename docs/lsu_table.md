# Table du LSU (à faire relire par M2)

Convention : `off = addr[1:0]`, `dmem_addr = {addr[31:2], 2'b00}`, mémoire little-endian.

## Stores (dmem_wstrb, dmem_wdata)
| Instr | funct3 | off | dmem_wstrb | dmem_wdata |
|---|---|---|---|---|
| SB | 000 | 00 | 0001 | {4{rs2[7:0]}} |
| SB | 000 | 01 | 0010 | idem |
| SB | 000 | 10 | 0100 | idem |
| SB | 000 | 11 | 1000 | idem |
| SH | 001 | 0x | 0011 | {2{rs2[15:0]}} |
| SH | 001 | 1x | 1100 | idem |
| SW | 010 | 00 | 1111 | rs2 |

## Loads (on décale `dmem_rdata >> 8*off`, puis extension)
| Instr | funct3 | Octets utilisés | Extension |
|---|---|---|---|
| LB  | 000 | [7:0]  | signe |
| LH  | 001 | [15:0] | signe |
| LW  | 010 | [31:0] | – |
| LBU | 100 | [7:0]  | zéro |
| LHU | 101 | [15:0] | zéro |

## Accès non alignés
LH/SH avec off[0]=1, LW/SW avec off≠00 : signal `misaligned` (à décider avec l'équipe : ignorer, trap, ou faute lockstep).

## Latence
`dmem_rdata` arrive 1 cycle après `dmem_addr` (mémoire synchrone) : le LSU est combinatoire, donc le registre MEM/WB doit capturer `load_data` au cycle suivant l'adresse.
