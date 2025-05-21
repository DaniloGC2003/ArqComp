ghdl -a state_machine.vhd
ghdl -e state_machine

ghdl -a state_machine_tb.vhd
ghdl -e state_machine_tb

ghdl -r state_machine_tb --wave=state_machine_tb.ghw