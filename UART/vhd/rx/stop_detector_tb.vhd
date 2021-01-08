-------------------------------------------------------------------------------
-- Title      : Testbench for design "stop_detector"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : stop_detector_tb.vhd
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

entity stop_detector_tb is

end entity stop_detector_tb;

-------------------------------------------------------------------------------

architecture arch of stop_detector_tb is

  -- component ports
  signal reset       : std_logic;
  signal stop_det_en : std_logic;
  signal d           : std_logic_vector(7 downto 0);
  signal stop        : std_logic;

  -- clock
  signal clock : std_logic := '1';

begin  -- architecture arch

  -- component instantiation
  DUT : entity work.stop_detector
    port map (
      clock       => clock,
      reset       => reset,
      stop_det_en => stop_det_en,
      d           => d,
      stop        => stop);

  -- clock generation
  clock <= not clock after 10 ns;

  -- waveform generation
  WaveGen_Proc : process
  begin
    reset <= '0';
    stop_det_en <= '1';
    d <= "01010101";
    wait for 5 ns;
    reset <= '1';
    wait for 10 ns;
    reset <= '0';
    wait for 50 ns;
    d <= "11111111";
    wait;
  end process WaveGen_Proc;



end architecture arch;

-------------------------------------------------------------------------------

configuration stop_detector_tb_arch_cfg of stop_detector_tb is
  for arch
  end for;
end stop_detector_tb_arch_cfg;

-------------------------------------------------------------------------------
