-------------------------------------------------------------------------------
-- Title      : Testbench for design "rx"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : rx_tb.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2020-12-17
-- Last update: 2021-01-31
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-12-17  1.0      wackoz  Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity rx_tb is

end entity rx_tb;

-------------------------------------------------------------------------------

architecture arch of rx_tb is

  -- component ports
  signal clock      : std_logic := '1';
  signal reset      : std_logic;
  signal rxd        : std_logic;
  signal rx_enable  : std_logic;
  signal rx_ack   : std_logic;
  signal rx_full    : std_logic;
  signal flag_error : std_logic;
  signal Pout       : std_logic_vector(7 downto 0);

begin  -- architecture arch

  -- component instantiation
  RX : entity work.rx
    port map (
      clock      => clock,
      reset      => reset,
      rx_enable  => rx_enable,
      rx_ack     => rx_ack,
      rxd        => rxd,
      Pout       => Pout,
      flag_error => flag_error,
      rx_full    => rx_full);


  -- clock generation
  clock <= not clock after 31.25 ns;

  -- waveform generation
  WaveGen_Proc : process
  begin
    reset <= '0';
    rx_enable <='0';
    rxd       <= '1';
    wait for 40 ns;
    reset     <= '1';
    wait for 62.5 ns;
    rx_enable <= '1';
    wait for 62.5 ns;
    rx_enable <= '0';
    rxd       <= '0';                   --
    wait for 8.6956 us;

    rxd <= '1';                         -- D0
    wait for 8.6956 us;
    rxd <= '0';                         -- D1
    wait for 8.6956 us;
    rxd <= '0';                         --D2
    wait for 8.6956 us;
    rxd <= '1';                         --D3
    wait for 8.6956 us;
    rxd <= '0';                         --D4
    wait for 8.6956 us;
    rxd <= '1';                         --D5
    wait for 8.6956 us;
    rxd <= '0';                         --D6
    wait for 8.6956 us;
    rxd <= '0';                         --D7
    wait for 8.6956 us;
    rxd <= '1';                         --end
    wait for 8.6956 us;
    wait;
  end process WaveGen_Proc;



end architecture arch;

-------------------------------------------------------------------------------

configuration rx_tb_arch_cfg of rx_tb is
  for arch
  end for;
end rx_tb_arch_cfg;

-------------------------------------------------------------------------------
