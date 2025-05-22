library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bank_ULA is
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
end entity;

architecture a_bank_ULA of bank_ULA is
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
    signal out_ULA: unsigned(15 downto 0);
    signal in_ULA_A: unsigned(15 downto 0);
    signal in_ULA_B: unsigned(15 downto 0);
begin
    acumulador: reg16bits
        port map(
            clk      => clk,
            rst      => rst,
            wr_en    => '1',
            data_in  => out_ULA,
            data_out => in_ULA_B
        );
    bank: bank_regs
        port map(
            reg_r    => reg_r,
            reg_wr   => reg_wr,
            clk      => clk,
            rst      => rst,
            wr_en    => wr_en,
            data_in  => data_in,
            data_out => in_ULA_A
        );
    ULA_instance: ULA
        port map(
            in1 => in_ULA_A,
            in2 => in_ULA_B,
            select_operation => select_operation,
            result => out_ULA,
            carry => open,
            overflow => open
        );
    
end architecture;