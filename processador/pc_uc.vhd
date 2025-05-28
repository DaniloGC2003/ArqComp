library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_uc is
   port( clk      : in std_logic;
         rst      : in std_logic;
         current_instr  : out unsigned(16 downto 0);

         add_op      : out std_logic;
         ld_op       : out std_logic; -- load immediate operation
         reg_r1      : out unsigned(2 downto 0)
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
      port( 
            rst      : in std_logic;
            data_in  : in unsigned(6 downto 0);
            data_out : out unsigned(6 downto 0);
            jump_en     : out std_logic;
            add_op      : out std_logic;
            ld_op       : out std_logic; -- load immediate operation
            instruction  : in unsigned(16 downto 0);
            reg1         : out unsigned(2 downto 0)
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

   component reg_instruction is
      port( clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(16 downto 0);
            data_out : out unsigned(16 downto 0)
      );
   end component;

   signal out_pc: unsigned(6 downto 0);
   signal out_uc: unsigned(6 downto 0);
   signal out_rom: unsigned(16 downto 0);
   signal out_sm: unsigned(1 downto 0);
   signal instr_reg_wr_en: std_logic;
   signal pc_wr_en: std_logic;
   signal instr_reg_out: unsigned(16 downto 0);
   signal uc_jump_en: std_logic;
begin

   pc_inst: pc
      port map(
         clk      => clk,
         rst      => rst,
         wr_en    => pc_wr_en,
         data_in  => out_uc,
         data_out => out_pc
      );

   uc_inst: uc
      port map(
         rst      => rst,
         data_in  => out_pc,
         data_out => out_uc,
         jump_en  => uc_jump_en,
         add_op   => add_op,
         ld_op    => ld_op,
         instruction => instr_reg_out,
         reg1     => reg_r1
      );

   rom_inst: rom
      port map(
         clk      => clk,
         endereco => out_pc,
         dado     => out_rom
      );

   sm_inst: state_machine
      port map(
         clk      => clk,
         rst      => rst,
         estado   => out_sm
      );
   
   reg_instr_inst: reg_instruction
      port map(
         clk      => clk,
         rst      => rst,
         wr_en    => instr_reg_wr_en,
         data_in  => out_rom,
         data_out => instr_reg_out
      );

   -- problema: logo depois do reset, o pc recebe o valor 1, de forma que a primeira instrucao da rom eh ignorada
   pc_wr_en <= '1' when out_sm = "00" else '0';
   instr_reg_wr_en <= '1' when out_sm = "10" else '0';
   current_instr <= instr_reg_out;

end architecture;