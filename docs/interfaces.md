# Interfaces - RISC-V RV32I lockstep (BROUILLON, a valider en reunion)

## 1. Decisions generales
| Sujet | Decision |
|---|---|
| Langage | SystemVerilog simple (logic, always_ff, always_comb) |
| Simulateur | Icarus Verilog (iverilog -g2012) + GTKWave |
| Nommage | snake_case, un module par fichier rtl/<module>.v, testbench tb/tb_<module>.sv |
| Prefixes pipeline | id_, ex_, mem_, wb_ |
| Regfile | x0 = 0 ; lecture/ecriture simultanee = write-through |
| Memoires | lecture synchrone, 1 cycle ; $readmemh |

## 2. alu_op[3:0] (a figer: M1 + M3)
| Code | Operation |
|---|---|
| 0000 | ADD |
| 0001 | SUB |
| 0010 | AND |
| 0011 | OR |
| 0100 | XOR |
| 0101 | SLL |
| 0110 | SRL |
| 0111 | SRA |
| 1000 | SLT |
| 1001 | SLTU |
| 1010 | PASS_B |

## 3. wb_sel[1:0]
| Code | Source |
|---|---|
| 00 | ALU |
| 01 | Memoire (LSU) |
| 10 | PC + 4 |

## 4. Ports memoire
| Signal | Dir (cote core) | Largeur | Role |
|---|---|---|---|
| imem_addr | out | 32 | adresse instruction |
| imem_rdata | in | 32 | instruction (1 cycle) |
| dmem_addr | out | 32 | adresse donnee |
| dmem_wdata | out | 32 | donnee a ecrire |
| dmem_wstrb | out | 4 | byte enables |
| dmem_ren | out | 1 | lecture |
| dmem_rdata | in | 32 | donnee lue (1 cycle) |

## 5. LSU (M4)
| Signal | Dir | Largeur | Role |
|---|---|---|---|
| funct3 | in | 3 | 000 b, 001 h, 010 w, 100 bu, 101 hu |
| addr | in | 32 | adresse (a = addr[1:0]) |
| store_data | in | 32 | rs2 |
| mem_read / mem_write | in | 1 | type d'acces |
| dmem_rdata | in | 32 | mot lu |
| dmem_addr / dmem_wdata | out | 32 | vers dmem |
| dmem_wstrb | out | 4 | sb: 0001<<a ; sh: a[1]?1100:0011 ; sw: 1111 |
| load_data | out | 32 | octet/demi-mot extrait + extension signe ou zero |

## 6. A COMPLETER
- Signaux de controle (M1)
- Registres de pipeline IF/ID, ID/EX, EX/MEM, MEM/WB (M1/M3)
- Aleas: forwarding_unit, hazard_unit (M2)
- Ports de core_top (M3)

Tag une fois valide: git tag interfaces-v1 && git push origin interfaces-v1
