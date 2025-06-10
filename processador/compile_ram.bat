ghdl -a ram.vhd
ghdl -e ram

ghdl -a ram_tb.vhd
ghdl -e ram_tb

ghdl -r ram_tb --wave=ram_tb.ghw