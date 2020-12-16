-------------------------------------------------------------------------------
-- Title      : rx_dp
-- Project    : 
-------------------------------------------------------------------------------
-- File       : rx_dp.vhd
-- Author     :   <Sabina@DESKTOP-IN9UA4D>
-- Company    : 
-- Created    : 2020-12-15
-- Last update: 2020-12-16
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: datapath for rx
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-12-15  1.0      Sabina  Created
-------------------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity rx_dp is
  port (
    clock           : in  std_logic;
    reset           : in  std_logic;
    clear_c_samples : in  std_logic;
    clear_c_rxfull  : in  std_logic;
    flag_rxfull     : out std_logic;
    flag_sh         : out std_logic;
    rxd             : in  std_logic;    -- input
    voter_en        : in  std_logic;    -- enable for voter
    sh_en_samples   : in  std_logic;    -- shift enable for samples
    sh_en_data      : in  std_logic;    -- shift enable for sr data
    ld_en_samples   : in  std_logic;
    ld_en_data      : in  std_logic;
    start_en        : in  std_logic;
    start           : out std_logic;
    stop_en         : in  std_logic;
    stop            : out std_logic;
    count_en_sh     : in  std_logic;
    count_en_rxfull : in  std_logic;
    Pout            : out std_logic_vector(7 downto 0));  -- output

end entity rx_dp;

-------------------------------------------------------------------------------

architecture str of rx_dp is

  signal voter_en     : std_logic;
  signal start_det_en : std_logic;
  signal stop_det_en  : std_logic;
  signal ld_en        : std_logic;
  signal sh_en        : std_logic;
  signal p_out        : std_logic_vector(7 downto 0);
  signal en           : std_logic;
  signal q            : std_logic_vector(135 downto 0);;
  signal q_c_shift    : std_logic;
  signal ld           : std_logic;
  signal s_in         : std_logic;
  signal s_out        : std_logic;
  signal tc_flag      : std_logic;
  signal vote         : std_logic;

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

  component voter_3bit is
    port (
      clock    : in  std_logic;
      reset    : in  std_logic;
      voter_en : in  std_logic;
      d        : in  std_logic_vector(2 downto 0);
      vote     : out std_logic);
  end component voter_3bit;

  component stop_detector is
    port (
      clock       : in  std_logic;
      reset       : in  std_logic;
      stop_det_en : in  std_logic;
      d           : in  std_logic_vector(7 downto 0);
      stop        : out std_logic);
  end component stop_detector;

  component start_detector is
    port (
      clock        : in  std_logic;
      reset        : in  std_logic;
      start_det_en : in  std_logic;
      d            : in  std_logic_vector(7 downto 0);
      start        : out std_logic);
  end component start_detector;

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

begin  -- architecture str

  voter_3bit : voter_3bit
    port map (
      clock    => clock,
      reset    => reset,
      voter_en => voter_en,
      d        => p_out_samples(3)&p_out_samples(4)&p_out_samples(5),
      vote     => vote
      );

  start_detector : start_detector
    port map(
      clock        => clock,
      reset        => reset,
      start_det_en => start_en,
      d            => p_out_samples,
      start        => start
      );

  stop_detector : stop_detector
    port map(
      clock       => clock,
      reset       => reset,
      stop_det_en => stop_en,
      d           => p_out_samples,
      stop        => stop
      );

  shift_reg_samples : shift_register_8bit
    port map (
      clock => clock,
      ld_en => ld_en_samples,
      sh_en => sh_en_samples,
      s_in  => rxd,
      s_out => s_out,
      p_in  => p_in,
      p_out => p_out_samples
      );
  -- port map: counter

  counter_shift : counter_nbit
    generic map (N => 8)
    port map (
      clock   => clock,
      clear   => reset,
      tc      => std_logic_vector(to_unsigned(136, 8)),
      tc_flag => tc_flag_sh,
      en      => count_en_sh,
      ld      => ld,
      d       => d,
      q       => q_c_shift
      );

  shift_reg_data : shift_register_8bit
    port map (
      clock => clock,
      ld_en => ld_en_data,
      sh_en => sh_en_data,
      s_in  => vote,
      s_out => s_out,
      p_in  => p_in,
      p_out => p_out_data
      );
  -- port map: counter

  counter_rxfull : counter_nbit
    generic map (N => 3)
    port map (
      clock   => clock,
      clear   => reset,
      tc      => std_logic_vector(to_unsigned(7, 3)),
      tc_flag => tc_flag_rxfull,
      en      => count_en_rxfull,
      ld      => ld,
      d       => d,
      q       => q_c_rxfull
      );



  flag_sh        <= tc_flag_sh;
  flag_rxfull    <= tc_flag_rxfull;
  tc_flag_sh     <= '1' when unsigned(q_c_shift) = (unsigned(17)) or unsigned(q_c_shift) = (unsigned(34)) or unsigned(q_c_shift) = (unsigned(51)) or unsigned(q_c_shift) = (unsigned(85)) or unsigned(q_c_shift) = (unsigned(102)) or unsigned(q_c_shift) = (unsigned(119)) else '0';
  tc_flag_68     <= '1' when unsigned(q_c_shift) = (unsigned(68))                                                                                                                                                                                                           else '0';
  tc_flag_rxfull <= '1' when unsigned(q_c_rxfull) = (unsigned(7))                                                                                                                                                                                                           else '0';  --useless



end architecture str;

-------------------------------------------------------------------------------
