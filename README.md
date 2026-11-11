# Processeur RISC-V RV32I – pipeline 5 étages, lockstep « Automotive-safe »

## Installation (WSL Ubuntu, ~10 lignes)
1. Installer WSL : `wsl --install -d Ubuntu` (PowerShell admin), redémarrer.
2. `sudo apt update`
3. `sudo apt install -y iverilog gtkwave make git`
4. `sudo apt install -y gcc-riscv64-unknown-elf`  (ou la toolchain `riscv32-unknown-elf`)
5. Si le préfixe est riscv64 : `make hex PROG=fib CROSS=riscv64-unknown-elf-`
6. Vérifier : `iverilog -V`, `riscv64-unknown-elf-gcc --version`
7. GTKWave sous Windows 11 (WSLg) : `gtkwave build/tb_alu.vcd`
8. Cloner : `git clone <url> && cd riscv-lockstep`
9. Tester : `make sim MODULE=lsu`  → doit afficher « TOUS LES TESTS PASSENT »

## Commandes
| Commande | Effet |
|---|---|
| `make sim MODULE=alu` | compile `rtl/alu.v` + `tb/tb_alu.sv` et simule |
| `make sim MODULE=x DEPS="rtl/a.v"` | si le module instancie d'autres fichiers |
| `make wave MODULE=alu` | ouvre les chronogrammes |
| `make hex PROG=fib` | `sw/fib.S` ou `.c` → `build/fib.hex` |

**Dans ton testbench**, ajoute pour GTKWave :
`initial begin $dumpfile("build/tb_alu.vcd"); $dumpvars(0, tb_alu); end`

## Règles Git
- Une branche par module : `feat/alu`, `feat/regfile`, `feat/lsu`…
- Pas de push sur `main`. Pull request **relue par une autre personne** avant merge.
- Interfaces figées = tag `interfaces-v1`.
- Arborescence : `rtl/` `tb/` `sw/` `docs/` `scripts/`
