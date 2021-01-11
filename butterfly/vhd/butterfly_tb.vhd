-------------------------------------------------------------------------------
-- Title      : Testbench for design "butterfly"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : butterfly_tb.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2021-01-11
-- Last update: 2021-01-11
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2021-01-11  1.0      wackoz  Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity butterfly_tb is

end entity butterfly_tb;

-------------------------------------------------------------------------------

architecture str of butterfly_tb is

  -- component generics
  constant N : integer := 20;

  -- component ports
  signal clock     : std_logic := '1';
  signal reset     : std_logic;
  signal start     : std_logic;
  signal done      : std_logic;
  signal fullspeed : std_logic;
  signal Ar_out    : std_logic_vector(N-1 downto 0);
  signal Aj_out    : std_logic_vector(N-1 downto 0);
  signal Br_out    : std_logic_vector(N-1 downto 0);
  signal Bj_out    : std_logic_vector(N-1 downto 0);

begin  -- architecture str

  -- component instantiation
  DUT : entity work.butterfly
    generic map (
      N => N)
    port map (
      clock     => clock,
      reset     => reset,
      Ar_in     => "01101101010110101011",
      Aj_in     => "01101100110101001001",
      Br_in     => "00110101001101101000",
      Bj_in     => "11011010011010100111",
      Wr        => "01101101010010111010",
      Wj        => "10011011010101001010",
      start     => start,
      done      => done,
      fullspeed => fullspeed,
      Ar_out    => Ar_out,
      Aj_out    => Aj_out,
      Br_out    => Br_out,
      Bj_out    => Bj_out);

  -- clock generation
  clock <= not clock after 10 ns;

  -- waveform generation
  WaveGen_Proc : process
  begin
    start <=  '0';
    fullspeed <= '0';
    reset <= '1';
             wait for 50 ns;
    reset <= '0';
             wait for 50 ns;
    reset <= '1';
    wait for 100 ns;
    start <= '1';
    -- insert signal assignments here

    wait;
  end process WaveGen_Proc;



end architecture str;
