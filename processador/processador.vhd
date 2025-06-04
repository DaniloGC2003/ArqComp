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
         accumulator_out : out unsigned(15 downto 0);
         ULA_out : out unsigned(15 downto 0)
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
            move_op    : out std_logic; -- move operation
            addi_op   : out std_logic; -- add immediate operation
            subi_op   : out std_logic; -- subtract immediate operation
            clr_op   : out std_logic; -- clear operation
            cmpi_op   : out std_logic; -- compare immediate operation
            beq_op   : out std_logic; -- branch if equal operation
            instruction  : in unsigned(16 downto 0);
            immediate    : out unsigned(6 downto 0);
            reg1         : out unsigned(3 downto 0);
            zero_flag    : in std_logic
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
            data_out : out unsigned(15 downto 0);
            reg0_out : out unsigned(15 downto 0);
            reg1_out : out unsigned(15 downto 0);
            reg2_out : out unsigned(15 downto 0);
            reg3_out : out unsigned(15 downto 0);
            reg4_out : out unsigned(15 downto 0);
            reg5_out : out unsigned(15 downto 0);
            reg6_out : out unsigned(15 downto 0)
        );
    end component;
    component ULA is
        port (
            in1 : in unsigned(15 downto 0); 
            in2 : in unsigned(15 downto 0); 
            select_operation : in unsigned(1 downto 0);
            result : out unsigned(15 downto 0);
            carry : out std_logic;
            overflow : out std_logic;
            zero : out std_logic
        );
    end component;
    component reg1bit is
        port( clk      : in std_logic;
              rst      : in std_logic;
              wr_en    : in std_logic;
              data_in  : in std_logic;
              data_out : out std_logic
        );
    end component;
    
    signal out_pc: unsigned(6 downto 0);
    signal out_uc: unsigned(6 downto 0);
    signal in_uc: unsigned(6 downto 0);
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
    signal move_op_s: std_logic; -- move operation
    signal addi_op_s: std_logic; -- add immediate operation
    signal subi_op_s: std_logic; -- subtract immediate operation
    signal clr_op_s: std_logic; -- clear operation
    signal cmpi_op_s: std_logic; -- compare immediate operation
    signal beq_op_s: std_logic; -- branch if equal operation
    signal reg_r1: unsigned(3 downto 0);

    signal reg0_out_s: unsigned(15 downto 0);
    signal reg1_out_s: unsigned(15 downto 0);
    signal reg2_out_s: unsigned(15 downto 0);
    signal reg3_out_s: unsigned(15 downto 0);
    signal reg4_out_s: unsigned(15 downto 0);
    signal reg5_out_s: unsigned(15 downto 0);
    signal reg6_out_s: unsigned(15 downto 0);

    signal out_ULA: unsigned(15 downto 0);
    signal in_ULA_A: unsigned(15 downto 0) := (others => '0'); -- default value
    signal in_ULA_B: unsigned(15 downto 0) := (others => '0'); -- default value

    signal current_instr: unsigned(16 downto 0);
    signal bank_reg_r: unsigned(2 downto 0);
    signal bank_reg_wr: unsigned(2 downto 0);
    signal bank_wr_en: std_logic;
    signal data_in_bank: unsigned(15 downto 0);
    signal data_out_bank: unsigned(15 downto 0);
    signal ULA_op: unsigned(1 downto 0);
    signal accumulator_wr_en: std_logic;
    signal in_accumulator: unsigned(15 downto 0);
    signal out_accumulator: unsigned(15 downto 0);

    signal zero_s: std_logic; -- zero flag for ULA
    signal reg1bit_zero_wr_en: std_logic;
    signal reg1bit_zero_out: std_logic;

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
         data_in  => in_uc,
         data_out => out_uc,
         jump_en  => uc_jump_en,
         add_op   => add_op_s,
         subtract_op => subtract_op_s,
         move_op  => move_op_s,
         ld_op    => ld_op_s,
         addi_op  => addi_op_s,
         subi_op  => subi_op_s,
         clr_op   => clr_op_s,
         cmpi_op  => cmpi_op_s,
         beq_op   => beq_op_s,
         instruction => instr_reg_out,
         immediate => immediate_s,
         reg1     => reg_r1,
         zero_flag => reg1bit_zero_out
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
            data_out => out_accumulator
        );
    bank: bank_regs
        port map(
            reg_r    => bank_reg_r,
            reg_wr   => bank_reg_wr,
            clk      => clk,
            rst      => rst,
            wr_en    => bank_wr_en,
            data_in  => data_in_bank,
            data_out => data_out_bank,
            reg0_out => reg0_out_s,
            reg1_out => reg1_out_s,
            reg2_out => reg2_out_s,
            reg3_out => reg3_out_s,
            reg4_out => reg4_out_s,
            reg5_out => reg5_out_s,
            reg6_out => reg6_out_s
        );
    ULA_instance: ULA
        port map(
            in1 => in_ULA_A,
            in2 => in_ULA_B,
            select_operation => ULA_op,
            result => out_ULA,
            carry => open,
            overflow => open,
            zero => zero_s
        );
    reg1bit_zero: reg1bit
        port map(
            clk      => clk,
            rst      => rst,
            wr_en    => reg1bit_zero_wr_en,
            data_in  => zero_s,
            data_out => reg1bit_zero_out
        );


    immediate_extended <= (B"0_0000_0000" & immediate_s) when immediate_s(6) = '0' else
                          (B"1_1111_1111" & immediate_s); -- sign extension for 6-bit immediate

    in_accumulator <= 
        (others => '0') when clr_op_s = '1' and reg_r1(3) = '1' else
        reg0_out_s when move_op_s = '1' and reg_r1(3) = '1' and reg_r1(2 downto 0) = "000" else
        reg1_out_s when move_op_s = '1' and reg_r1(3) = '1' and reg_r1(2 downto 0) = "001" else
        reg2_out_s when move_op_s = '1' and reg_r1(3) = '1' and reg_r1(2 downto 0) = "010" else
        reg3_out_s when move_op_s = '1' and reg_r1(3) = '1' and reg_r1(2 downto 0) = "011" else
        reg4_out_s when move_op_s = '1' and reg_r1(3) = '1' and reg_r1(2 downto 0) = "100" else
        reg5_out_s when move_op_s = '1' and reg_r1(3) = '1' and reg_r1(2 downto 0) = "101" else
        reg6_out_s when move_op_s = '1' and reg_r1(3) = '1' and reg_r1(2 downto 0) = "110" else
        out_ULA when ld_op_s = '0' else
        immediate_extended when ld_op_s = '1' else
        (others => '0');

    in_ULA_A <= immediate_extended when subi_op_s = '1' else -- SUBI
                out_accumulator when cmpi_op_s = '1' and reg_r1(3) = '1' else -- CMPI with accumulator
                data_out_bank when add_op_s = '1' or subtract_op_s = '1' or addi_op_s = '1' or (cmpi_op_s = '1' and reg_r1(3) = '0') else -- ADD, SUBTRACT, ADDI, CMPI
                "000000000" & out_pc when beq_op_s = '1' else -- BEQ
                in_ULA_A;

    in_ULA_B <= immediate_extended when addi_op_s = '1' or cmpi_op_s = '1' or beq_op_s = '1' else -- ADDI, CMPI, BEQ
                data_out_bank when subi_op_s = '1' else -- SUBI
                out_accumulator when (add_op_s = '1' or subtract_op_s = '1') else -- and out_sm = "00" else -- ADD, SUBTRACT
                in_ULA_B;

    -- for LD, MOV, ADDI, SUBI
    bank_reg_wr <= reg_r1(2 downto 0) when (ld_op_s = '1' and reg_r1(3) = '0') or
                (move_op_s = '1' and reg_r1(3) = '0') or (addi_op_s = '1' and reg_r1(3) = '0') or
                (subi_op_s = '1' and reg_r1(3) = '0') or
                (clr_op_s = '1' and reg_r1(3) = '0') else
                (others => '0');
    data_in_bank <= immediate_extended when ld_op_s = '1' else
                    out_accumulator when move_op_s = '1' and reg_r1(3) = '0' else
                    out_ULA when addi_op_s = '1' or subi_op_s = '1' else
                    (others => '0');
    bank_wr_en <= '1' when ld_op_s = '1' or (move_op_s = '1' and reg_r1(3) = '0') or (addi_op_s = '1' and reg_r1(3) = '0' and out_sm = "01") or
                (subi_op_s = '1' and reg_r1(3) = '0' and out_sm = "01")  or (clr_op_s = '1' and reg_r1(3) = '0' and out_sm = "01") else
                '0';

    -- for ADD, SUBTRACT, ADDI, SUBI
    -- maybe change here? if this doesn't work, maybe "freeza" the ALU inputs during each instruction cycle
    bank_reg_r <= reg_r1(2 downto 0) when (add_op_s = '1' or subtract_op_s = '1' or addi_op_s = '1' or subi_op_s = '1' or cmpi_op_s = '1') --and out_sm = "01" 
    and reg_r1(3) = '0' else
        "111"; -- default value, means no register selected
    ULA_op <= "00" when add_op_s = '1' or addi_op_s = '1' else
            "01" when subtract_op_s = '1' or subi_op_s = '1' or cmpi_op_s = '1' else
            (others => '0');
    accumulator_wr_en <= '1' when (add_op_s = '1' or subtract_op_s = '1') and out_sm = "01" else
                        '1' when ld_op_s = '1' and reg_r1(3) = '1' else
                        '1' when move_op_s = '1' and reg_r1(3) = '1' else
                        '1' when clr_op_s = '1' and reg_r1(3) = '1' else
                        '0';

    -- updating PC
    pc_wr_en <= '1' when out_sm = "00" else '0';--HERE IT WAS 00

    -- updating instruction register
    instr_reg_wr_en <= '1' when out_sm = "10" else '0';

    -- sending address to UC
    in_uc <= out_ULA(6 downto 0) when beq_op_s = '1' and reg1bit_zero_out = '1' else
              out_pc;

    reg1bit_zero_wr_en <= '1' when (add_op_s = '1' or subtract_op_s = '1' or addi_op_s = '1' or subi_op_s = '1' or cmpi_op_s = '1') and out_sm = "01" else
                            '0';

    -- sending signals to top level
    instruction <= instr_reg_out;
    pc_out <= out_pc;
    state <= out_sm;
    bank_reg_out <= data_out_bank;
    accumulator_out <= out_accumulator;
    ULA_out <= out_ULA;

    end architecture;