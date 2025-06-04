ghdl -a reg1bit.vhd
ghdl -e reg1bit

ghdl -a processador.vhd
ghdl -e processador

ghdl -a processador_tb.vhd
ghdl -e processador_tb

ghdl -r processador_tb --wave=processador_tb.ghw