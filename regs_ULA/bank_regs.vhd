library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- bank contains 7 registers

entity bank_regs is
   port(    reg_r    : in unsigned(2 downto 0);
            reg_wr   : in unsigned(2 downto 0);
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
   );
end entity;

architecture a_bank_regs of bank_regs is
   component reg16bits is
      port( clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
      );
   end component;
   --signal data_to_write: unsigned(15 downto 0);
   --signal data_in_0: unsigned(15 downto 0);
   signal data_out_0: unsigned(15 downto 0);
   signal wr_en_0: std_logic;
begin
   -- register's port => bank's port
   reg0: reg16bits port map(clk => clk, rst => rst, wr_en => wr_en_0, data_in => data_in, data_out => data_out_0);
   data_out_0 <= "0000000000000000";

   process(clk,rst,wr_en)  -- acionado se houver mudan�a em clk, rst ou wr_en
   begin                
      if rst='1' then
         data_out <= "1111111111111111";
      elsif rising_edge(clk) then
         if wr_en='1' then
            if reg_wr = "000" then
               wr_en_0 <= '1';
               --reset all other registers' wr_en to 0 too
            else
               wr_en_0 <= '0';
            end if;
         end if;
      end if;
   end process;
   data_out <= data_out_0;
end architecture;