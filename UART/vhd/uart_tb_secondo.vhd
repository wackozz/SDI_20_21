-------------------------------------------------------------------------------
-- Title      : Testbench for design "uart"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : uart_tb.vhd
-- Author     : wackoz  <wackoz@wT14s>
-- Company    : 
-- Created    : 2021-01-07
-- Last update: 2021-02-11
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

entity uart_tb_secondo is

end entity uart_tb_secondo;

-------------------------------------------------------------------------------

architecture arch of uart_tb_secondo is

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
      RxD    => TxD,
      TxD    => TxD,
      Dout   => Dout,
      Din    => Din,
      ATN    => ATN,
      ATNACK => ATNACK,
      ADD    => ADD,
      R_Wn   => R_Wn,
      CS     => CS);

  -- clock generation
  clock <= not clock after 31.25 ns;

  -- waveform generation
  WaveGen_Proc : process
  begin
    reset <= '0';
    ADD <="000";
    R_Wn <= '0';
    CS <= '0';
    Din <= "00000000";
    ATNack<='0';
    RxD <='1';
    wait for 62.5 ns;
    reset <= '1';
    ADD   <= "011";  -- VADO A SCRIVERE NEL REG DI CONTROLLO
    R_Wn  <= '0';
    CS    <= '1';
    wait for 62.5 ns;
    Din <= "00000011";
    ADD   <= "000";
    R_Wn  <= '0';
    wait for 62.5 ns;
    Din   <= "10011000";   -- trasmetto la parola a TXDATA
    wait for 62.5 ns;
    ADD   <= "010";   --leggo lo stato
    R_Wn  <= '1';
    Din <= "00000000";
    wait for 62.5 ns;
    CS <= '0';
    R_Wn <='0';
    ADD <="000";
    wait for 86.9375 us;
    ATNack <= '1';
    wait for 125 ns;
    ATNACK <='0';
    ADD  <= "010";
    CS   <= '1';
    R_Wn <= '1';  --leggo lo stato e controllo se rxfull è alto e se il
    --trasmettitore ha concluso la trasmissione;
    wait for 62.5 ns;
    ADD <= "001";
    wait for 62.5 ns;
    ADD <= "011";    --DISABILITO RX E TX.
    CS <= '1';
    R_Wn <= '0';
    wait for 62.5 ns;
    Din <= "00000000";
    CS <= '0';
    ADD <="000";
    wait;



  end process WaveGen_Proc;

end architecture arch;

-------------------------------------------------------------------------------

configuration uart_tb_secondo_arch_cfg of uart_tb_secondo is
  for arch
  end for;
end uart_tb_secondo_arch_cfg;

-------------------------------------------------------------------------------
