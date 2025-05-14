library ieee;
use ieee.std_logic_1164.all;

entity mux8x1_tb is
end;

architecture a_mux8x1_tb of mux8x1_tb is
   component mux8x1
      port( sel0,sel1,sel2               : in std_logic;
         entr2,entr4,entr6 				 : in std_logic;
         saida                   		 : out std_logic
   );
   end component;
   signal sel0,sel1,sel2,entr2,entr4,entr6,saida: std_logic;
   begin
   -- uut significa Unit Under Test
   uut: mux8x1 port map( sel0 => sel0,
						 sel1 => sel1,
						 sel2 => sel2,
						 entr2 => entr2,
						 entr4 => entr4,
						 entr6 => entr6,
						 saida => saida);
						

process
   begin
      sel0 <= '0';
      sel1 <= '0';
	  sel2 <= '0';
	  entr2 <= '0';
	  entr4 <= '0';
	  entr6 <= '0';
      wait for 50 ns;
	  
	  sel0 <= '0';
      sel1 <= '0';
	  sel2 <= '1';
	  entr2 <= '0';
	  entr4 <= '0';
	  entr6 <= '0';
      wait for 50 ns;
	  
      sel0 <= '0';
      sel1 <= '1';
	  sel2 <= '0';
	  entr2 <= '0';
	  entr4 <= '0';
	  entr6 <= '0';
      wait for 50 ns;
	  
	  sel0 <= '0';
      sel1 <= '1';
	  sel2 <= '1';
	  entr2 <= '0';
	  entr4 <= '0';
	  entr6 <= '0';
      wait for 50 ns;
	  
      sel0 <= '1';
      sel1 <= '0';
	  sel2 <= '0';
	  entr2 <= '0';
	  entr4 <= '0';
	  entr6 <= '0';
      wait for 50 ns;
	  
	  sel0 <= '1';
      sel1 <= '0';
	  sel2 <= '1';
	  entr2 <= '0';
	  entr4 <= '0';
	  entr6 <= '0';
      wait for 50 ns;
	  
      sel0 <= '1';
      sel1 <= '1';
	  sel2 <= '0';
	  entr2 <= '0';
	  entr4 <= '0';
	  entr6 <= '0';
      wait for 50 ns;
	  
	  sel0 <= '1';
      sel1 <= '1';
	  sel2 <= '1';
	  entr2 <= '0';
	  entr4 <= '0';
	  entr6 <= '0';
      wait for 50 ns;
wait;
   end process;
end architecture;