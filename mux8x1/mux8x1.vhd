library ieee;
use ieee.std_logic_1164.all;

entity mux8x1 is
   port( sel0,sel1,sel2               : in std_logic;
         entr2,entr4,entr6 : in std_logic;
         saida                   : out std_logic
   );
end entity;

architecture a_mux8x1 of mux8x1 is
begin
   saida <= '0' when sel0='0' and sel1='0' and sel2='0' else --entrada 0
			'0' when sel0='0' and sel1='0' and sel2='1' else --entrada 1
			entr2 when sel0='0' and sel1='1' and sel2='0' else --entrada 2
			'1' when sel0='0' and sel1='1' and sel2='1' else --entrada 3
			entr4 when sel0='1' and sel1='0' and sel2='0' else --entrada 4
			'0' when sel0='1' and sel1='0' and sel2='1' else --entrada 5
			entr6 when sel0='1' and sel1='1' and sel2='0' else --entrada 6
			'1' when sel0='1' and sel1='1' and sel2='1' else --entrada 7
            '0';     -- esse '0' é pra quando "der pau" em sel1 ou sel0
end architecture;