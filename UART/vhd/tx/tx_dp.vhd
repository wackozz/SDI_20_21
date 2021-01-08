-------------------------------------------------------------------------------
-- Title      : tx datapath
-- Project    : 
-------------------------------------------------------------------------------
-- File       : tx_dp.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2020-12-09
-- Last update: 2021-01-04
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: transmitter for UART project
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-12-09  1.0      wackoz  Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tx_dp is

  port (
    clock            : in  std_logic;
    reset            : in  std_logic;
    clear            : in  std_logic;
    force_one        : in  std_logic;
    force_zero       : in  std_logic;
    --counter
    count_en_tc      : in  std_logic;
    count_en_txempty : in  std_logic;
    term_count       : out std_logic;
    tx_empty_dp   : out std_logic;
    tc_flag_txempty : out std_logic;
    --shift r
    p_in             : in  std_logic_vector(7 downto 0);  --input (SR)
    ld_en            : in  std_logic;   -- paraellel load shift reg
    sh_en            : in  std_logic;   -- shift reg shift en
    TxD              : out std_logic    --output
    );

end entity tx_dp;

architecture arch of tx_dp is
  --signal declaration

  --counters
  signal clear_sh_tmp      : std_logic;
  signal clear_txempty_tmp : std_logic;
  constant N               : integer                        := 8;
  signal ld                : std_logic                      := '0';  --parallel load for counter                   
  signal tc_flag_sh        : std_logic                      := '0';

  signal d                 : std_logic_vector(N-1 downto 0) := (others => '0');  --unused
  signal d_txempty         : std_logic_vector(4 downto 0)   := (others => '0');  --unused
  signal q_txempty         : std_logic_vector(4 downto 0);
  signal q_c_shift         : std_logic_vector(N-1 downto 0);
  signal reset_tmp         : std_logic;
  --register
  signal s_in              : std_logic                      := '1';
  signal s_out             : std_logic;
  signal p_out             : std_logic_vector(7 downto 0);


  -- component inst

  component counter_nbit is
    generic (
      N : integer);
    port (
      clock   : in  std_logic;
      clear   : in  std_logic;
      tc      : in  std_logic_vector(N-1 downto 0);
      tc_flag : out std_logic;
      en      : in  std_logic;
      ld      : in  std_logic;
      d       : in  std_logic_vector(N-1 downto 0);
      q       : out std_logic_vector(N-1 downto 0));
  end component counter_nbit;

  component shift_register_8bit is
    port (
      clock : in  std_logic;
      ld_en : in  std_logic;
      sh_en : in  std_logic;
      s_in  : in  std_logic;
      s_out : out std_logic;
      p_in  : in  std_logic_vector(N-1 downto 0);
      p_out : out std_logic_vector(N-1 downto 0));
  end component shift_register_8bit;

begin  -- architecture arch

  --port map: shift register

  shift_reg : shift_register_8bit
    port map (
      clock => clock,
      ld_en => ld_en,
      sh_en => sh_en,
      s_in  => s_in,
      s_out => s_out,
      p_in  => p_in,
      p_out => p_out
      );
  -- port map: counter

  counter_shift : counter_nbit
    generic map (N => N)
    port map (
      clock   => clock,
      clear   => reset_tmp,
      tc      => std_logic_vector(to_unsigned(137, N)),
      tc_flag => tc_flag_sh,
      en      => count_en_tc,
      ld      => ld,
      d       => d,
      q       => q_c_shift
      );

  counter_txempty : counter_nbit
    generic map (N => 5)
    port map (
      clock   => clock,
      clear   => reset_tmp,
      tc      => std_logic_vector(to_unsigned(9, 5)),
      en      => count_en_txempty,
      ld      => ld,
      tc_flag => tc_flag_txempty,
      d       => d_txempty,
      q       => q_txempty
      );

  tx_empty_dp <= '1' when
                 unsigned(q_txempty) = (to_unsigned(8, 5))
                 else '0';
  
  term_count <= tc_flag_sh;

  TxD <= not(force_zero) and (s_out or force_one);

  reset_tmp <= not(reset) or clear;


end architecture arch;
