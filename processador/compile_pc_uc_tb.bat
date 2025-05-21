ghdl -a pc.vhd
ghdl -e pc

ghdl -a uc.vhd
ghdl -e uc

ghdl -a pc_uc.vhd
ghdl -e pc_uc

ghdl -a pc_uc_tb.vhd
ghdl -e pc_uc_tb

ghdl -r pc_uc_tb --wave=pc_uc_tb.ghw