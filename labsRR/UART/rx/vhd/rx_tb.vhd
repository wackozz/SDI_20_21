-------------------------------------------------------------------------------
-- Title      : Testbench for design "rx"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : rx_tb.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2020-12-17
-- Last update: 2020-12-17
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-12-17  1.0      wackoz	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity rx_tb is

end entity rx_tb;

-------------------------------------------------------------------------------

architecture arch of rx_tb is

  -- component ports
  signal clock : std_logic:= '1';
  signal reset : std_logic;
  signal rxd   : std_logic;
  signal Pout  : std_logic_vector(7 downto 0);

begin  -- architecture arch

  -- component instantiation
  DUT: entity work.rx
    port map (
      clock => clock,
      reset => reset,
      rxd   => rxd,
      Pout  => Pout);

  -- clock generation
  clock <= not clock after 5 ns;

  -- waveform generation
  WaveGen_Proc: process
  begin
    reset <=  '1';
    rxd <= '1';
    wait for 20 ns;
    reset <= '0';
    wait for 50 ns;
    rxd <= '0';
    wait for 1390 ns;
    rxd <= '1';                         -- D0
    wait for 1390 ns;
    rxd <= '0';                         -- D1
    wait for 1390 ns;
    rxd <= '0';                         --D2
    wait for 1390 ns;
    rxd <= '1';                         --D3
    wait for 1390 ns;
    rxd <= '0';                         --D4
    wait for 1390 ns;
    rxd <= '1';                         --D5
    wait for 1390 ns;
    rxd <= '0';                         --D6
    wait for 1390 ns;
    rxd <= '0';                         --D7
    wait for 1390 ns;
    rxd <= '1';                         --end
    wait for 1390 ns;
    wait;
  end process WaveGen_Proc;


end architecture arch;

-------------------------------------------------------------------------------

configuration rx_tb_arch_cfg of rx_tb is
  for arch
  end for;
end rx_tb_arch_cfg;

-------------------------------------------------------------------------------
