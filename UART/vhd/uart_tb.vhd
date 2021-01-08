-------------------------------------------------------------------------------
-- Title      : Testbench for design "uart"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : uart_tb.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2021-01-07
-- Last update: 2021-01-07
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2021-01-07  1.0      wackoz  Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity uart_tb is

end entity uart_tb;

-------------------------------------------------------------------------------

architecture arch of uart_tb is

  -- component ports
  signal clock  : std_logic := '1';
  signal reset  : std_logic;
  signal RxD    : std_logic;
  signal TxD    : std_logic;
  signal Dout   : std_logic_vector(7 downto 0);
  signal Din    : std_logic_vector(7 downto 0);
  signal ATN    : std_logic;
  signal ATNACK : std_logic;
  signal ADD    : std_logic_vector(2 downto 0);
  signal R_Wn   : std_logic;
  signal CS     : std_logic;


begin  -- architecture arch

  -- component instantiation
  DUT : entity work.uart
    port map (
      clock  => clock,
      reset  => reset,
      RxD    => RxD,
      TxD    => TxD,
      Dout   => Dout,
      Din    => Din,
      ATN    => ATN,
      ATNACK => ATNACK,
      ADD    => ADD,
      R_Wn   => R_Wn,
      CS     => CS);

  -- clock generation
  clock <= not Clk after 10 ns;

  -- waveform generation
  WaveGen_Proc : process
  begin
    reset   <= '0';
    wait for 50 ns;
    reset   <= '1';                     --SCRIVO SUL REGISTRO DI CONTROLLO
    ADD     <= "011";
    R_Wn    <= '0';
    CS      <= '1';
    DIN     <= "00000010";
    wait for 50 ns;
    ADD     <= "010";  -- VADO A LEGGERE NEL REGISTRO DI STATO E LEGGO TX EMPTY ALTO
    R_Wn    <= '1';
    CS      <= '1';
    FF_IN_B <= "010";
    RX_in   <= "00000000";
    wait for 50 ns;
    FF_IN_B <= "010";  --POICHE TX EMPTY ALTO VADO A SCRIVERE NEL REGISTRO DI TRASMISSIONE
    RX_in   <= "00000000";
    din     <= "00000111";
    ADD     <= "000";
    R_Wn    <= '0';
    CS      <= '1';
    RX_in   <= "00000000";
    ATNack  <= '0';
    wait for 50 ns;
    FF_IN_B <= "001";  --PER FORZA DALLO STATO WRITE_TXDATA PASSO A NEXT STATE
    --NOTO CHE CLRATN E ZERO E ALLORA PER ABBASSAE ATN ASPETTO ATN ACK NELLO STATO
    --ATNack MA NEL FRATTEMPO CONTROLLO SE HO RX FULL O X EMPTY
    --QUI MI ARRIVA UN RX FULL E ALLORA PASSO ALLO STATO READ_RXDATA    -- insert signal assignments here

    wait;
  end process WaveGen_Proc;

end architecture arch;

-------------------------------------------------------------------------------

configuration uart_tb_arch_cfg of uart_tb is
  for arch
  end for;
end uart_tb_arch_cfg;

-------------------------------------------------------------------------------
