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
            data_out : out unsigned(6 downto 0);
            jump_en     : out std_logic;
            instruction  : in unsigned(16 downto 0)
      );
   end component;
   component rom is
      port( clk      : in std_logic;
            endereco : in unsigned(6 downto 0);
            dado     : out unsigned(16 downto 0)
      );
   end component;
   component state_machine is
      port( clk      : in std_logic;
            rst      : in std_logic;
            estado : out unsigned(1 downto 0)
      );
   end component;

   signal out_pc: unsigned(6 downto 0);
   signal out_uc: unsigned(6 downto 0);
   signal out_rom: unsigned(16 downto 0);
   signal out_sm: unsigned(1 downto 0);
   signal pc_clk: std_logic;
   signal rom_clk: std_logic;

   signal uc_jump_en: std_logic;
begin

   pc_inst: pc
      port map(
         clk      => pc_clk,
         rst      => rst,
         wr_en    => wr_en,
         data_in  => out_uc,
         data_out => out_pc
      );

   uc_inst: uc
      port map(
         clk      => clk,
         rst      => rst,
         wr_en    => '1',
         data_in  => out_pc,
         data_out => out_uc,
         jump_en  => uc_jump_en,
         instruction => out_rom
      );

   rom_inst: rom
      port map(
         clk      => rom_clk,
         endereco => out_pc,
         dado     => out_rom
      );

   sm_inst: state_machine
      port map(
         clk      => clk,
         rst      => rst,
         estado   => out_sm
      );

   pc_clk <= '1' when out_sm = "01" else '0';
   rom_clk <= '1' when out_sm = "00" else '0';

end architecture;