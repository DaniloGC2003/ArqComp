library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is
    port( clk      : in std_logic;
         rst      : in std_logic;
         state    : out unsigned(1 downto 0);
         pc_out      : out unsigned(6 downto 0);
         instruction : out unsigned(16 downto 0);
         bank_reg_out : out unsigned(15 downto 0);
         accumulator_out : out unsigned(15 downto 0)
   );
end entity;

architecture a_processador of processador is
    -- components from PC_UC
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
            jump_en      : out std_logic;
            add_op       : out std_logic;
            ld_op        : out std_logic; -- load immediate operation
            subtract_op : out std_logic; -- subtract operation
            instruction  : in unsigned(16 downto 0);
            immediate    : out unsigned(6 downto 0);
            reg1         : out unsigned(3 downto 0)
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
   -- components from BANK_ULA
   component reg16bits is
      port(
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;
    component bank_regs is 
        port(
            reg_r    : in unsigned(2 downto 0);
            reg_wr   : in unsigned(2 downto 0);
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;
    component ULA is
        port (
            in1 : in unsigned(15 downto 0); 
            in2 : in unsigned(15 downto 0); 
            select_operation : in unsigned(1 downto 0);
            result : out unsigned(15 downto 0);
            carry : out std_logic;
            overflow : out std_logic
        );
    end component;
    
    signal out_pc: unsigned(6 downto 0);
    signal out_uc: unsigned(6 downto 0);
    signal out_rom: unsigned(16 downto 0);
    signal out_sm: unsigned(1 downto 0);
    signal instr_reg_wr_en: std_logic;
    signal instr_reg_out: unsigned(16 downto 0);
    signal pc_wr_en: std_logic;
    signal uc_jump_en: std_logic;
    signal immediate_s: unsigned(6 downto 0);
    signal immediate_extended: unsigned(15 downto 0);
    signal add_op_s: std_logic;
    signal ld_op_s: std_logic; -- load immediate operation
    signal subtract_op_s: std_logic; -- subtract operation
    signal reg_r1: unsigned(3 downto 0);

    signal out_ULA: unsigned(15 downto 0);
    signal in_ULA_A: unsigned(15 downto 0);
    signal in_ULA_B: unsigned(15 downto 0);

    signal current_instr: unsigned(16 downto 0);
    signal bank_reg_r: unsigned(2 downto 0);
    signal bank_reg_wr: unsigned(2 downto 0);
    signal bank_wr_en: std_logic;
    signal data_in_bank: unsigned(15 downto 0);
    signal ULA_op: unsigned(1 downto 0);
    signal accumulator_wr_en: std_logic;
    signal in_accumulator: unsigned(15 downto 0);
    signal const_register: unsigned(15 downto 0) := "0000000000000010"; -- Example constant register
begin
    -- PC UC instantiation
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
         add_op   => add_op_s,
        subtract_op => subtract_op_s,
         ld_op    => ld_op_s,
         instruction => instr_reg_out,
         immediate => immediate_s,
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

    -- BANK ULA instantiation
    acumulador: reg16bits
        port map(
            clk      => clk,
            rst      => rst,
            wr_en    => accumulator_wr_en,
            data_in  => in_accumulator,
            data_out => in_ULA_B
        );
    bank: bank_regs
        port map(
            reg_r    => bank_reg_r,
            reg_wr   => bank_reg_wr,
            clk      => clk,
            rst      => rst,
            wr_en    => bank_wr_en,
            data_in  => data_in_bank,
            data_out => in_ULA_A
        );
    ULA_instance: ULA
        port map(
            in1 => in_ULA_A,
            in2 => in_ULA_B,
            select_operation => ULA_op,
            result => out_ULA,
            carry => open,
            overflow => open
        );


    immediate_extended <= (B"0_0000_0000" & immediate_s) when immediate_s(6) = '0' else
                          (B"1_1111_1111" & immediate_s); -- sign extension for 6-bit immediate

    in_accumulator <= out_ULA when ld_op_s = '0' else
        immediate_extended when ld_op_s = '1' else
        (others => '0');

    -- for LD
    bank_reg_wr <= reg_r1(2 downto 0) when ld_op_s = '1' and reg_r1(3) = '0' else (others => '0');
    data_in_bank <= immediate_extended when ld_op_s = '1' else
                      (others => '0');
    bank_wr_en <= '1' when ld_op_s = '1' else '0';

    -- for ADD, SUBTARCT
    bank_reg_r <= reg_r1(2 downto 0) when (add_op_s = '1' or subtract_op_s = '1') and out_sm = "01" and reg_r1(3) = '0' else
        "111"; -- default value, means no register selected
    ULA_op <= "00" when add_op_s = '1' else
              "01" when subtract_op_s = '1' else
        (others => '0');
    accumulator_wr_en <= '1' when (add_op_s = '1' or subtract_op_s = '1') and out_sm = "01" else
                        '1' when ld_op_s = '1' and reg_r1(3) = '1' else
                        '0';

    -- updating PC
    pc_wr_en <= '1' when out_sm = "00" else '0';

    -- updating instruction register
    instr_reg_wr_en <= '1' when out_sm = "10" else '0';


    -- sending signals to top level
    instruction <= instr_reg_out;
    pc_out <= out_pc;
    state <= out_sm;
    
    end architecture;