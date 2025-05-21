library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_uc is
   port( clk      : in std_logic;
         rst      : in std_logic;
         wr_en    : in std_logic
   );
end entity;

architecture a_pc_uc of pc_uc is
   component pc is
      port( clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(6 downto 0);
            data_out : out unsigned(6 downto 0)
      );
   end component;
   component uc is
      port( clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(6 downto 0);
            data_out : out unsigned(6 downto 0)
      );
   end component;
   component rom is
      port( clk      : in std_logic;
            endereco : in unsigned(6 downto 0);
            dado     : out unsigned(16 downto 0)
      );
   end component;

   signal out_pc: unsigned(6 downto 0);
   signal out_uc: unsigned(6 downto 0);
   signal out_rom: unsigned(16 downto 0);
begin

   pc_inst: pc
      port map(
         clk      => clk,
         rst      => rst,
         wr_en    => '1',
         data_in  => out_uc,
         data_out => out_pc
      );

   uc_inst: uc
      port map(
         clk      => clk,
         rst      => rst,
         wr_en    => '1',
         data_in  => out_pc,
         data_out => out_uc
      );

   rom_inst: rom
      port map(
         clk      => clk,
         endereco => out_pc,
         dado     => out_rom
      );

end architecture;