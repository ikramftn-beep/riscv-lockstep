# Usage :
#   make sim MODULE=alu            -> compile et lance tb/tb_alu.sv (rtl/alu.v)
#   make sim MODULE=lsu            -> idem pour le LSU
#   make sim MODULE=x DEPS="rtl/a.v rtl/b.v"   -> si le module a des dépendances
#   make wave MODULE=alu           -> ouvre GTKWave sur build/tb_alu.vcd
#   make hex PROG=fib              -> sw/fib.S (ou fib.c) -> build/fib.hex
MODULE ?= alu
PROG   ?= test_add
DEPS   ?=
BUILD  := build
TB     := $(firstword $(wildcard tb/tb_$(MODULE).sv tb/tb_$(MODULE).v))

CROSS  ?= riscv32-unknown-elf-
CFLAGS := -march=rv32i -mabi=ilp32 -nostdlib -nostartfiles -ffreestanding -O1 -Wl,-T,sw/link.ld
SRC    := $(firstword $(wildcard sw/$(PROG).S sw/$(PROG).c))

.PHONY: sim wave hex clean
sim:
	@test -n "$(TB)" || (echo "ERREUR: tb/tb_$(MODULE).sv introuvable" && exit 1)
	@mkdir -p $(BUILD)
	iverilog -g2012 -Wall -s tb_$(MODULE) -o $(BUILD)/tb_$(MODULE).vvp rtl/$(MODULE).v $(DEPS) $(TB)
	vvp $(BUILD)/tb_$(MODULE).vvp

wave: sim
	gtkwave $(BUILD)/tb_$(MODULE).vcd &

hex:
	@test -n "$(SRC)" || (echo "ERREUR: sw/$(PROG).S ou .c introuvable" && exit 1)
	@mkdir -p $(BUILD)
	$(CROSS)gcc $(CFLAGS) $(if $(filter %.c,$(SRC)),sw/start.S) $(SRC) -o $(BUILD)/$(PROG).elf
	$(CROSS)objcopy -O binary $(BUILD)/$(PROG).elf $(BUILD)/$(PROG).bin
	od -An -v -t x4 -w4 $(BUILD)/$(PROG).bin | tr -d ' ' > $(BUILD)/$(PROG).hex
	$(CROSS)objdump -d $(BUILD)/$(PROG).elf > $(BUILD)/$(PROG).dump
	@echo "OK -> $(BUILD)/$(PROG).hex ($$(wc -l < $(BUILD)/$(PROG).hex) mots)"

clean:
	rm -rf $(BUILD)
