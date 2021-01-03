-------------------------------------------------------------------------------
-- Title      : Testbench for design "tx"
-- Project    : UART
-------------------------------------------------------------------------------
-- File       : tx_tb.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2020-12-09
-- Last update: 2020-12-31
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

entity tx_tb is

end entity tx_tb;

-------------------------------------------------------------------------------

architecture arch of tx_tb is

  -- component ports
  signal clock        : std_logic := '1';
  signal reset        : std_logic := '1';
  signal p_in         : std_logic_vector(7 downto 0);
  signal TxD          : std_logic;
  signal tx_empty     : std_logic;
  signal tx_empty_ack : std_logic;
  -- clock
  signal Clk          : std_logic := '1';

begin  -- architecture arch

  -- component instantiation
  DUT : entity work.tx
    port map (
      clock        => clock,
      reset        => reset,
      tx_empty_ack => tx_empty_ack,
      tx_empty     => tx_empty,
      p_in         => p_in,
      TxD          => TxD);

  -- clock generation
  clock <= not clock after 10 ns;
  rst : process is
  begin
    reset        <= '1';
    tx_empty_ack <= '1';
    wait for 10 ns;
    reset        <= '0';
    wait for 30 ns;
    reset        <= '1';
    wait for 50 ns;
    tx_empty_ack <= '0';
    wait;
  end process;

  p_in <= "10010001";

end architecture arch;

-------------------------------------------------------------------------------

configuration tx_tb_arch_cfg of tx_tb is
  for arch
  end for;
end tx_tb_arch_cfg;

-------------------------------------------------------------------------------
