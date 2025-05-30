library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity rom is
   port( clk      : in std_logic;
         endereco : in unsigned(6 downto 0);
         dado     : out unsigned(16 downto 0) 
   );
end entity;
architecture a_rom of rom is
   type mem is array (0 to 127) of unsigned(16 downto 0);
   constant conteudo_rom : mem := (
      -- caso endereco => conteudo
      0  => B"0011_0000110_1000_10", -- ld into accumulator
      1  => "10000000000000001",
      2  => B"0011_1000110_1000_10",
      3  => "10000000000000011",
      4  => "00000000000000000",
      5  => "10000000000000101",
      6  => B"0011_0000001_0001_10", -- ld into r1
      7  => B"0011_0100001_0011_10", -- ld into r3
      8  => B"0010_0000000_0011_00", -- add r3
      9  => B"0100_0000000_0001_00", -- sub r1
      10 => "10000000000001010", -- A
      11 => "11110000000001011", -- B. instruction says "jump to 0"
      -- abaixo: casos omissos => (zero em todos os bits)
      others => (others=>'0')
   );
begin
   process(clk)
   begin
      if(rising_edge(clk)) then
         dado <= conteudo_rom(to_integer(endereco));
      end if;
   end process;
end architecture;