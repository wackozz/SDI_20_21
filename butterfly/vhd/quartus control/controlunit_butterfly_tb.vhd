library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity controlunit_butterfly_tb is

end entity controlunit_butterfly_tb;

-------------------------------------------------------------------------------

architecture arch of controlunit_butterfly_tb is

  -- component ports
 signal status:  std_logic_vector ( 1 downto 0);
 signal	datapath_commands :  std_logic_vector ( 18 downto 0);
  -- clock
  signal clock : std_logic := '1';

begin  -- architecture arch

  -- component instantiation
  DUT : entity work.controlunit_butterfly
    port map (
	 clock => clock,
     status => status,
		datapath_commands => datapath_commands
     );

  -- clock generation
  clock <= not clock after 10 ns;

  -- waveform generation
  WaveGen_Proc : process
  begin
    -- insert signal assignments here



status <= "10";
wait for 50 ns;
status <= "10";
wait for 50 ns;

status <= "00";

wait;
  end process WaveGen_Proc;



end architecture arch;