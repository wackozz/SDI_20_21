
library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity bus_interface_tb is

end entity bus_interface_tb;

-------------------------------------------------------------------------------

architecture arch of bus_interface_tb is

  -- component ports
  signal Dout, TX_out                            : std_logic_vector (7 downto 0);
  signal RX_in, Din                          : std_logic_vector (7 downto 0);
  signal ADD , FF_IN_B                              : std_logic_vector (2 downto 0);
  signal R_Wn, CS, ATNack, RESET      : std_logic;
  signal ATN, TX_ACK                 :std_logic;
  signal tx_enable,rx_enable           : std_logic;
  -- clock
  signal clock : std_logic := '1';

begin  -- architecture arch

  -- component instantiation
  DUT : entity work.bus_interface
    port map (
      Dout       => Dout,
      TX_out     => TX_out,
      RX_in      => RX_in,
      Din        => Din,
      ADD        => ADD,
      R_Wn       => R_Wn,
      CS         => CS,
      ATNack     => ATNack,
      RESET      => RESET,
      CLOCK      => CLOCK,        
      FF_IN_B      => FF_IN_B,
      ATN       => ATN,
      TX_ACK     => TX_ACK,
      tx_enable   => tx_enable,
      rx_enable  =>  rx_enable
     );

  -- clock generation
  clock <= not clock after 10 ns;

  -- waveform generation
  WaveGen_Proc : process
  begin
    -- insert signal assignments here
reset <= '0';
wait for 50 ns;
reset <= '1';  --SCRIVO SUL REGISTRO DI CONTROLLO
ADD <= "011";
R_Wn <= '0';
CS <= '1';
DIN <= "00000010";
wait for 50 ns;
ADD <= "010";  -- VADO A LEGGERE NEL REGISTRO DI STATO E LEGGO TX EMPTY ALTO
R_Wn <= '1';
CS <= '1';
FF_IN_B <= "010";
RX_in <= "00000000";
wait for 50 ns;
FF_IN_B <= "010"; --POICHE TX EMPTY ALTO VADO A SCRIVERE NEL REGISTRO DI TRASMISSIONE
RX_in <= "00000000";
din <= "00000111";
ADD <= "000";
R_Wn <= '0';
CS <= '1';
RX_in <= "00000000";
ATNack <= '0';
wait for 50 ns;
FF_IN_B <= "001"; --PER FORZA DALLO STATO WRITE_TXDATA PASSO A NEXT STATE
                  --NOTO CHE CLRATN E ZERO E ALLORA PER ABBASSAE ATN ASPETTO ATN ACK NELLO STATO
                  --ATNack MA NEL FRATTEMPO CONTROLLO SE HO RX FULL O X EMPTY
                   --QUI MI ARRIVA UN RX FULL E ALLORA PASSO ALLO STATO READ_RXDATA
wait;
  end process WaveGen_Proc;



end architecture arch;
