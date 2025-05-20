ghdl -a reg16bits.vhd
ghdl -e reg16bits

ghdl -a reg16bits_tb.vhd
ghdl -e reg16bits_tb

ghdl -r reg16bits_tb --wave=reg16bits_tb.ghw


ghdl -a bank_regs.vhd 
ghdl -e bank_regs

ghdl -a bank_regs_tb.vhd
ghdl -e bank_regs_tb

ghdl -r bank_regs_tb --wave=bank_regs_tb.ghw