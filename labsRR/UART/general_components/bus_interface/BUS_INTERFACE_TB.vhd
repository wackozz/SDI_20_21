
library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity bus_interfaceDP_tb is

end entity bus_interfaceDP_tb;

-------------------------------------------------------------------------------

architecture arch of bus_interfaceDP_tb is

  -- component ports
  signal Dout, TX_out                            : std_logic_vector (7 downto 0);
  signal RX_in, Din                          : std_logic_vector (7 downto 0);
  signal ADD , FF_IN,FF_OUT ,ENABLE_FF                              : std_logic_vector (2 downto 0);
  signal R_Wn, CS, ATNack, RESET      : std_logic;
  signal ATN, RX_ENABLE, TX_ENABLE, CLRatn, TX_ACK : std_logic;
  
  -- clock
  signal clock : std_logic := '1';

begin  -- architecture arch

  -- component instantiation
  DUT : entity work.bus_interfaceDP
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
      ATN        => ATN,
      RX_ENABLE  => RX_ENABLE,
      TX_ENABLE  => TX_ENABLE,
      CLRatn     => CLRatn,
      TX_ACK     => TX_ACK,
      FF_IN      => FF_IN,
      FF_OUT     => FF_OUT,
		ENABLE_FF  => ENABLE_FF);

  -- clock generation
  clock <= not clock after 10 ns;

  -- waveform generation
  WaveGen_Proc : process
  begin
    -- insert signal assignments here
reset <= '0';
wait for 50 ns;
reset <= '1';
ADD <= "011";
R_Wn <= '0';
CS <= '1';
DIN <= "00000010";
wait for 50 ns;
ADD <= "010";
R_Wn <= '1';
CS <= '1';
FF_IN <= "010";
RX_in <= "00000000";
wait for 50 ns;
FF_IN <= "010";
RX_in <= "00000000";
din <= "00000111";
ADD <= "000";
R_Wn <= '0';
CS <= '1';
RX_in <= "00000000";
ATNack <= '0';
wait for 50 ns;
FF_IN <= "100";
ATNack<='1';
wait;
  end process WaveGen_Proc;



end architecture arch;

