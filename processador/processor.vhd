library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processor is
   port( clk      : in std_logic;
         rst      : in std_logic;
         state    : out unsigned(1 downto 0);
         PC      : out unsigned(6 downto 0);
         instruction : out unsigned(16 downto 0);
         bank_reg_out : out unsigned(15 downto 0);
         accumulator_out : out unsigned(15 downto 0)
   );
end entity;

architecture a_processor of processor is
   component pc_uc is
      port( clk      : in std_logic;
            rst      : in std_logic;
            current_instr  : out unsigned(16 downto 0);
            add_op      : out std_logic;
            ld_op       : out std_logic; -- load immediate operation
            reg_r1      : out unsigned(2 downto 0)
      );
   end component;

   component bank_ULA is
      port(
         reg_r    : in unsigned(2 downto 0);
         reg_wr   : in unsigned(2 downto 0);
         clk      : in std_logic;
         rst      : in std_logic;
         wr_en    : in std_logic; 
         data_in  : in unsigned(15 downto 0);
         data_out : out unsigned(15 downto 0);
         select_operation: in unsigned(1 downto 0)
      );
   end component;

   signal current_instr: unsigned(16 downto 0);
   signal bank_reg_r: unsigned(2 downto 0);
   signal bank_reg_wr: unsigned(2 downto 0);
   signal reg_r1_signal: unsigned(2 downto 0);
   signal add_op_signal: std_logic;
   signal ld_op_signal: std_logic;
   signal bank_wr_en: std_logic;
   signal const_register: unsigned(15 downto 0) := "0000000000000010"; -- Example constant register

begin
    pc_uc_inst: pc_uc
        port map(
            clk      => clk,
            rst      => rst,
            current_instr => current_instr,
            add_op   => open,
            ld_op    => open,
            reg_r1   => reg_r1_signal
        );
    
    bank_ULA_inst: bank_ULA
        port map(
            reg_r    => bank_reg_r,
            reg_wr   => bank_reg_wr,
            clk      => clk,
            rst      => rst,
            wr_en    => bank_wr_en,
            data_in  => const_register,  -- Example data input
            data_out => bank_reg_out,
            select_operation => "00"  -- Example operation selection
        );
   

      instruction <= current_instr;  -- Output the instruction from ROM
      bank_reg_wr <= reg_r1_signal when ld_op_signal = '1' else (others => '0');
      bank_wr_en <= '1' when ld_op_signal = '1' else '0';

    end architecture;