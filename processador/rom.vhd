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
      0  => "10000000000000000",
      1  => "10000000000000001",
      2  => "10000000000000010",
      3  => "10000000000000011",
      4  => "10000000000000100",
      5  => "10000000000000101",
      6  => "10000000000000110",
      7  => "10000000000000111",
      8  => "10000000000001000",
      9  => "10000000000001001",
      10 => "10000000000001010", -- A
      11 => "11110001000001011", -- B. instruction says "jump to 8"
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