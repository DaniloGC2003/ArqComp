library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bank_regs is
   port(
      reg_r    : in unsigned(2 downto 0);
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
      port(
         clk      : in std_logic;
         rst      : in std_logic;
         wr_en    : in std_logic;
         data_in  : in unsigned(15 downto 0);
         data_out : out unsigned(15 downto 0)
      );
   end component;

   signal data_out_0: unsigned(15 downto 0);
   signal wr_en_0: std_logic;
   signal data_out_1: unsigned(15 downto 0);
   signal wr_en_1: std_logic;
   signal data_out_2: unsigned(15 downto 0);
   signal wr_en_2: std_logic;
   signal data_out_3: unsigned(15 downto 0);
   signal wr_en_3: std_logic;
   signal data_out_4: unsigned(15 downto 0);
   signal wr_en_4: std_logic;
   signal data_out_5: unsigned(15 downto 0);
   signal wr_en_5: std_logic;
   signal data_out_6: unsigned(15 downto 0);
   signal wr_en_6: std_logic;

begin

   -- Write enable logic
   wr_en_0 <= '1' when (wr_en = '1' and reg_wr = "000") else '0';
   wr_en_1 <= '1' when (wr_en = '1' and reg_wr = "001") else '0';
   wr_en_2 <= '1' when (wr_en = '1' and reg_wr = "010") else '0';
   wr_en_3 <= '1' when (wr_en = '1' and reg_wr = "011") else '0';
   wr_en_4 <= '1' when (wr_en = '1' and reg_wr = "100") else '0';
   wr_en_5 <= '1' when (wr_en = '1' and reg_wr = "101") else '0';
   wr_en_6 <= '1' when (wr_en = '1' and reg_wr = "110") else '0';

   -- Register instantiation
   reg0: reg16bits
      port map(
         clk      => clk,
         rst      => rst,
         wr_en    => wr_en_0,
         data_in  => data_in,
         data_out => data_out_0
      );
   reg1: reg16bits
      port map(
         clk      => clk,
         rst      => rst,
         wr_en    => wr_en_1,
         data_in  => data_in,
         data_out => data_out_1
      );
   reg2: reg16bits   
      port map(
         clk      => clk,
         rst      => rst,
         wr_en    => wr_en_2,
         data_in  => data_in,
         data_out => data_out_2
      );
   reg3: reg16bits   
      port map(
         clk      => clk,
         rst      => rst,
         wr_en    => wr_en_3,
         data_in  => data_in,
         data_out => data_out_3
      );
   reg4: reg16bits
      port map(
         clk      => clk,
         rst      => rst,
         wr_en    => wr_en_4,
         data_in  => data_in,
         data_out => data_out_4
      );
   reg5: reg16bits
      port map(
         clk      => clk,
         rst      => rst,
         wr_en    => wr_en_5,
         data_in  => data_in,
         data_out => data_out_5
      );
   reg6: reg16bits
      port map(
         clk      => clk,
         rst      => rst,
         wr_en    => wr_en_6,
         data_in  => data_in,
         data_out => data_out_6
      );

   process(rst, clk)
   begin
      if rising_edge(clk) then
         if reg_r = "000" then
            data_out <= data_out_0;
         elsif reg_r = "001" then
            data_out <= data_out_1;
         elsif reg_r = "010" then
            data_out <= data_out_2;
         elsif reg_r = "011" then
            data_out <= data_out_3;
         elsif reg_r = "100" then
            data_out <= data_out_4; 
         elsif reg_r = "101" then
            data_out <= data_out_5; 
         elsif reg_r = "110" then
            data_out <= data_out_6;  
         else
            data_out <= (others => '0');  -- reset output
         end if;
      end if;

      if rst = '1' then
         data_out <= (others => '0');  -- reset output
      end if;
   end process;

end architecture;
