-------------------------------------------------------------------------------
-- Title      : rx datapath
-- Project    : 
-------------------------------------------------------------------------------
-- File       : rx_dp.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2020-12-11
-- Last update: 2020-12-16
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: receiver for UART project
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


entity rx_dp is

  port (
    Rxd                : in  std_logic;  -- input
    voter_en           : in  std_logic;
    sh_en_samples      : in  std_logic;
    ld_en_samples      : in  std_logic;
    sh_en_data         : in  std_logic;
    ld_en_data         : in  std_logic;
    count_en_sh        : in  std_logic;
    count_clear_sh     : in  std_logic;
    q_count_sh         : out std_logic;  -- delete
    count_en_rxfull    : in  std_logic;
    count_clear_rxfull : in  std_logic;
    start              : out std_logic;
    stop               : out std_logic;
    Pout               : out std_logic_vector(7 downto 0));

end entity rx_dp;


architecture arch of rx_dp is
  -----------------------------------------------------------------------------
  -- Component declaration
  -----------------------------------------------------------------------------

  component shift_register_8bit is
    port (

      clock : in  std_logic;
      sh_en : in  std_logic;
      ld_en : in  std_logic;
      s_in  : in  std_logic;
      s_out : out std_logic;
      p_in  : in  std_logic_vector(7 downto 0);
      p_out : out std_logic_vector(7 downto 0));
  end component shift_register_8bit;

  component counter_nbit is
    generic (
      N : integer);
    port (
      clock   : in  std_logic;
      clear   : in  std_logic;
      en      : in  std_logic;
      ld      : in  std_logic;
      tc      : in  std_logic_vector(N-1 downto 0);
      d       : in  std_logic_vector(N-1 downto 0);
      q       : out std_logic_vector(N-1 downto 0);
      tc_flag : out std_logic);
  end component counter_nbit;

  component start_detector is
    port (
      clock        : in  std_logic;
      reset        : in  std_logic;
      start_det_en : in  std_logic;
      d            : in  std_logic_vector(7 downto 0);
      start        : out std_logic);
  end component start_detector;

  component stop_detector is
    port (
      clock       : in  std_logic;
      reset       : in  std_logic;
      stop_det_en : in  std_logic;
      d           : in  std_logic_vector(7 downto 0);
      stop        : out std_logic);
  end component stop_detector;


begin  -- architecture arch

  -----------------------------------------------------------------------------
  -- COMPONENT INSTANTIATION
  -----------------------------------------------------------------------------
  -- instance "start_detector_1"
  start_detector_1 : entity work.start_detector
    port map (
      clock        => clock,
      reset        => reset,
      start_det_en => start_det_en,
      d            => d,
      start        => start);

  -- instance "shift_register_8bit_1"
  shift_register_8bit_1 : entity work.shift_register_8bit
    port map (
      clock => clock,
      sh_en => sh_en,
      ld_en => ld_en,
      s_in  => s_in,
      s_out => s_out,
      p_in  => p_in,
      p_out => p_out);

  -- instance "shift_register_8bit_2"
  shift_register_8bit_2 : entity work.shift_register_8bit
    port map (
      clock => clock,
      sh_en => sh_en,
      ld_en => ld_en,
      s_in  => s_in,
      s_out => s_out,
      p_in  => p_in,
      p_out => p_out);

  -- instance "stop_detector_1"
  stop_detector_1 : entity work.stop_detector
    port map (
      clock       => clock,
      reset       => reset,
      stop_det_en => stop_det_en,
      d           => d,
      stop        => stop);

  -- instance "voter_3bit_1"
  voter_3bit_1 : entity work.voter_3bit
    port map (
      clock    => clock,
      reset    => reset,
      voter_en => voter_en,
      d        => d,
      vote     => vote);

  -- instance "counter_nbit_1"
  counter_nbit_1 : entity work.counter_nbit
    generic map (
      N => N)
    port map (
      clock   => clock,
      clear   => clear,
      en      => en,
      ld      => ld,
      tc      => tc,
      d       => d,
      q       => q,
      tc_flag => tc_flag);

  -- instance "counter_nbit_2"
  counter_nbit_2 : entity work.counter_nbit
    generic map (
      N => N)
    port map (
      clock   => clock,
      clear   => clear,
      en      => en,
      ld      => ld,
      tc      => tc,
      d       => d,
      q       => q,
      tc_flag => tc_flag);





end architecture arch;


