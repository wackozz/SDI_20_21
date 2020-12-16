-------------------------------------------------------------------------------
-- Title      : Testbench for design "bus_interfaceDP"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : bus_interfaceDP_tb.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2020-12-16
-- Last update: 2020-12-16
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-12-16  1.0      wackoz  Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity bus_interfaceDP_tb is

end entity bus_interfaceDP_tb;

-------------------------------------------------------------------------------

architecture arch of bus_interfaceDP_tb is

  -- component ports
  signal Dout, TX_out, CTRL_out                            : std_logic_vector (7 downto 0);
  signal RX_in, Din, STATUS_out                            : std_logic_vector (7 downto 0);
  signal ADD                                               : std_logic_vector (2 downto 0);
  signal R_Wn, CS, ATNack, RESET, DONE_TX, DONE_RX         : std_logic;
  signal ATN, RX_ENABLE, TX_ENABLE, CLRatn, RX_ACK, TX_ACK : std_logic;
  signal error, TX_EMPTY, RX_FULL                          : std_logic;

  -- clock
  signal clock : std_logic := '1';

begin  -- architecture arch

  -- component instantiation
  DUT : entity work.bus_interfaceDP
    port map (
      Dout       => Dout,
      TX_out     => TX_out,
      CTRL_out   => CTRL_out,
      RX_in      => RX_in,
      Din        => Din,
      STATUS_out => STATUS_out,
      ADD        => ADD,
      R_Wn       => R_Wn,
      CS         => CS,
      ATNack     => ATNack,
      RESET      => RESET,
      CLOCK      => CLOCK,
      DONE_TX    => DONE_TX,
      DONE_RX    => DONE_RX,
      ATN        => ATN,
      RX_ENABLE  => RX_ENABLE,
      TX_ENABLE  => TX_ENABLE,
      CLRatn     => CLRatn,
      RX_ACK     => RX_ACK,
      TX_ACK     => TX_ACK,
      error      => error,
      TX_EMPTY   => TX_EMPTY,
      RX_FULL    => RX_FULL);

  -- clock generation
  clock <= not clock after 10 ns;

  -- waveform generation
  WaveGen_Proc : process
  begin
    -- insert signal assignments here

    wait until Clk = '1';
  end process WaveGen_Proc;



end architecture arch;

-------------------------------------------------------------------------------

configuration bus_interfaceDP_tb_arch_cfg of bus_interfaceDP_tb is
  for arch
  end for;
end bus_interfaceDP_tb_arch_cfg;

-------------------------------------------------------------------------------
