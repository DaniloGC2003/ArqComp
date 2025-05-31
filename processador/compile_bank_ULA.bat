ghdl -a ULA.vhd
ghdl -e ULA

::ghdl -a ULA_tb.vhd
::ghdl -e ULA_tb

::ghdl -r ULA_tb --wave=ULA_tb.ghw

ghdl -a reg16bits.vhd
ghdl -e reg16bits

::ghdl -a reg16bits_tb.vhd
::ghdl -e reg16bits_tb

::ghdl -r reg16bits_tb --wave=reg16bits_tb.ghw

ghdl -a bank_regs.vhd 
ghdl -e bank_regs

::ghdl -a bank_regs_tb.vhd
::ghdl -e bank_regs_tb

::ghdl -r bank_regs_tb --wave=bank_regs_tb.ghw

::ghdl -a bank_ULA.vhd
::ghdl -e bank_ULA

::ghdl -a bank_ULA_tb.vhd
::ghdl -e bank_ULA_tb

::ghdl -r bank_ULA_tb --wave=bank_ULA_tb.ghw
