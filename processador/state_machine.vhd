library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity state_machine is
   port( clk      : in std_logic;
         rst      : in std_logic;
         data_out : out std_logic
   );
end entity;

architecture a_state_machine of state_machine is
   signal registro: std_logic;
begin
   process(clk,rst)  -- acionado se houver mudan�a em clk ou rst
   begin                
    if rst='1' then
        registro <= '0';
    elsif rising_edge(clk) then
        registro <= not registro;
    end if;

   end process;
   
   data_out <= registro;  -- conexao direta, fora do processo
end architecture;