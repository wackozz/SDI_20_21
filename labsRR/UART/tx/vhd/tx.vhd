-------------------------------------------------------------------------------
-- Title      : transmitter
-- Project    : UART
-------------------------------------------------------------------------------
-- File       : tx.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2020-12-09
-- Last update: 2021-01-04
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-12-09  1.0      wackoz  Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity tx is

  port (
    clock        : in  std_logic;
    reset        : in  std_logic;
    p_in         : in  std_logic_vector(7 downto 0);  -- input
    TxD          : out std_logic;
    tx_empty_ack : in  std_logic;
    tx_empty     : out std_logic
    );

end entity tx;

-------------------------------------------------------------------------------

architecture str of tx is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

  signal clear            : std_logic;
  signal ld_en            : std_logic;
  signal sh_en            : std_logic;
  signal count_en_tc      : std_logic;
  signal count_en_txempty : std_logic;
  signal term_count       : std_logic;
  signal tx_empty_dp      : std_logic;
  signal  tc_flag_txempty : std_logic;
  signal force_one        : std_logic;
  signal force_zero       : std_logic;

  component tx_dp is
    port (
      clock            : in  std_logic;
      reset            : in  std_logic;
      clear            : in  std_logic;
      force_one        : in  std_logic;
      force_zero       : in  std_logic;
      count_en_tc      : in  std_logic;
      count_en_txempty : in  std_logic;
      tx_empty_dp      : out std_logic;
       tc_flag_txempty : out std_logic;
      term_count       : out std_logic;
      p_in             : in  std_logic_vector(7 downto 0);
      ld_en            : in  std_logic;
      sh_en            : in  std_logic;
      TxD              : out std_logic);
  end component tx_dp;

  component tx_cu is
    port (
      clock            : in  std_logic;
      reset            : in  std_logic;
      clear            : out std_logic;
      ld_en            : out std_logic;
      sh_en            : out std_logic;
      count_en_tc      : out std_logic;
      count_en_txempty : out std_logic;
      term_count       : in  std_logic;
      tx_empty_ack     : in  std_logic;
      tx_empty_dp      : in  std_logic;
      tx_empty         : out std_logic;
       tc_flag_txempty : in std_logic;
      force_one        : out std_logic;
      force_zero       : out std_logic);
  end component tx_cu;

begin

  datapath : tx_dp port map (
    clock            => clock,
    reset            => reset,
    clear            => clear,
    force_one        => force_one,
    force_zero       => force_zero,
    count_en_txempty => count_en_txempty,
    count_en_tc      => count_en_tc,
    tx_empty_dp      => tx_empty_dp,
     tc_flag_txempty =>  tc_flag_txempty,
    term_count => term_count,
    p_in       => p_in,
    ld_en      => ld_en,
    sh_en      => sh_en,
    TxD        => TxD);

  controlunit : tx_cu port map (
    clock            => clock,
    reset            => reset,
    clear            => clear,
    force_one        => force_one,
    force_zero       => force_zero,
    count_en_tc      => count_en_tc,
    count_en_txempty => count_en_txempty,
    tx_empty         => tx_empty,
     tc_flag_txempty =>  tc_flag_txempty,
    tx_empty_dp      => tx_empty_dp,
    term_count       => term_count,
    ld_en            => ld_en,
    tx_empty_ack     => tx_empty_ack,
    sh_en            => sh_en);


end architecture str;

-------------------------------------------------------------------------------
