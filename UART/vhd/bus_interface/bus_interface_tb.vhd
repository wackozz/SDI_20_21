
library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity bus_interface_tb is

end entity bus_interface_tb;

-------------------------------------------------------------------------------

architecture arch of bus_interface_tb is

  -- component ports
  signal Dout, TX_out            : std_logic_vector (7 downto 0);
  signal RX_in, Din              : std_logic_vector (7 downto 0);
  signal ADD, FF_IN_B            : std_logic_vector (2 downto 0);
  signal R_Wn, CS, ATNack, RESET : std_logic;
  signal ATN, TX_ACK, rx_ack     : std_logic;
  signal tx_enable, rx_enable    : std_logic;
  -- clock
  signal clock                   : std_logic := '1';

begin  -- architecture arch

  -- component instantiation
  DUT : entity work.bus_interface
    port map (
      Dout      => Dout,
      TX_out    => TX_out,
      RX_in     => RX_in,
      Din       => Din,
      ADD       => ADD,
      R_Wn      => R_Wn,
      CS        => CS,
      ATNack    => ATNack,
      RESET     => RESET,
      CLOCK     => CLOCK,
      FF_IN_B   => FF_IN_B,
      ATN       => ATN,
      TX_ACK    => TX_ACK,
      RX_ACK    => RX_ACK,
      tx_enable => tx_enable,
      rx_enable => rx_enable
      );

  -- clock generation
  clock <= not clock after 31.25 ns;

  -- waveform generation
  WaveGen_Proc : process
  begin
    -- insert signal assignments here
    reset <= '0';
    ATNack <='0';
    FF_IN_B <= "000";
    ADD <= "000";
    R_Wn <='0';
    CS <='0';
    Din <= "00000000";
    Rx_in <= "00000000";
    wait for 62.5 ns;
    reset <= '1';                       --SCRIVO SUL REGISTRO DI CONTROLLO
    ADD   <= "011";
    R_Wn  <= '0';
    CS    <= '1';
    wait for 62.5 ns;
    DIN   <= "00000010";
    ADD   <= "000";                     -- SCRIVO LA PAROLA DA TRASMETTERE
    R_Wn  <= '0';
    CS    <= '1';
    wait for 62.5 ns;
    Din   <= "01010110";
    ADD   <= "011";
    CS    <= '1';
    R_Wn  <= '0';
    wait for 62.5 ns;
    ADD <="000";
    Din   <= "00000011";                --abilito anche il ricevitore
    wait for 62.5 ns;  --dovrei aspettare il tempo di ricevere una parola o che
    --il trasmettitore abbia terminato la trasmissione.

    --test in caso di segnale txempty.
    FF_IN_B <= "010";

    
    wait for 250 ns;
    ATNack  <= '1';
    wait for 62.5 ns;
    ADD     <= "010";                   --leggo lo stato.
    R_Wn    <= '1';
    CS      <= '1';
    ATNack  <= '0';
    wait for 62.5 ns;
    ADD     <= "000";                   --scrivo la parola da trasmettere
    R_Wn    <= '0';
    CS      <= '1';
    wait for 62.5 ns;
    Din     <= "00110010";
    wait for 62.5 ns;

    --test in caso di segnale rxfull.
    FF_IN_B <= "001";
    Rx_in <= "10010010";
    wait for 62.5 ns;
    FF_IN_B <= "011";  --caso di trasmissione e ricezione simultanea
    wait for 62.5 ns;
    ADD     <= "011";  --caso in cui non si utilizza il pin dedicato ATNack
    --ma il comando CLRatn per uscita da stato di ATN.
    R_Wn    <= '0';
    wait for 62.5 ns;
    Din     <= "00000111";
    wait for 62.5 ns;
    ADD     <= "010";                   --lettura dello stato
    R_Wn    <= '1';
    wait for 62.5 ns;
    ADD     <= "001";                   --lettura del dato ricevuto
    R_Wn    <= '1';
    CS      <= '1';
    wait for 62.5 ns;
    ADD     <= "011";
    R_Wn    <= '0';
    FF_IN_B <= "000";
    wait for 62.5 ns;
    Din     <= "00000000";              --spengo ricevitore e trasmettitore.
    CS <= '0';
           wait;
  end process WaveGen_Proc;



end architecture arch;

