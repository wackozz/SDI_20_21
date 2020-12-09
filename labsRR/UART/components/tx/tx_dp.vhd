-------------------------------------------------------------------------------
-- Title      : tx datapath
-- Project    : 
-------------------------------------------------------------------------------
-- File       : tx_dp.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2020-12-09
-- Last update: 2020-12-09
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
    clock : in std_logic;
    reset : in std_logic;
    force_one  : in  std_logic;
    force_zero : in  std_logic;
    --counter
    count_en   : in  std_logic;
    term_count : out std_logic;
    p_in       : in  std_logic_vector(7 downto 0);  --input (SR)
    TxD        : out std_logic                     --output
    );

end entity tx_dp;

architecture arch of tx_dp is
  --signal declaration

  --counter
  constant N : integer := 3;
  signal ld : std_logic;
  signal d  : std_logic_vector(N-1 downto 0);
  signal q  : std_logic_vector(N-1 downto 0);
  --register
  signal ld_en : std_logic;
  signal s_in  : std_logic;
  signal s_out : std_logic;
  signal p_out : std_logic_vector(7 downto 0);


  -- component inst

  component counter_nbit is
    generic (
      N : integer);
    port (
      clock : in  std_logic;
      clear : in  std_logic;
      en    : in  std_logic;
      ld    : in  std_logic;
      d     : in  std_logic_vector(N-1 downto 0);
      q     : out std_logic_vector(N-1 downto 0));
  end component counter_nbit;

  component shift_register_8bit is
    port (
      clock : in  std_logic;
      ld_en : in  std_logic;
      s_in  : in  std_logic;
      s_out : out std_logic;
      p_in  : in  std_logic_vector(7 downto 0);
      p_out : out std_logic_vector(7 downto 0));
  end component shift_register_8bit;

begin  -- architecture arch

  --port map: shift register

  shift_reg : shift_register_8bit
    port map (
      clock => clock,
      ld_en => ld_en,
      s_in  => s_in,
      s_out => s_out,
      p_in  => p_in,
      p_out => p_out
      );
  -- port map: counter

  counter : counter_nbit
    generic map (N => N)
    port map (
      clock => clock,
      clear => reset,
      en    => count_en,
      ld    => ld,
      d     => d,
      q     => q
      );

  terminal_counter: process (clock) is
  begin  -- process terminal_counter
    
    if clock'event and clock = '1' then  -- rising clock edge
      if unsigned(q) = 7 then
        term_count <= '1';
      else
        term_count <= '0';
        end if;
    end if;
  end process terminal_counter;

  TxD <= ((s_out and not(force_zero)) and force_one);

end architecture arch;

