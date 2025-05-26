ghdl -a reg_instruction.vhd
ghdl -e reg_instruction

ghdl -a processor.vhd
ghdl -e processor

ghdl -a processor_tb.vhd
ghdl -e processor_tb

ghdl -r processor_tb --wave=processor_tb.ghw