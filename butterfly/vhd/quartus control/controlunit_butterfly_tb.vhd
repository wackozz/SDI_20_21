library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity controlunit_butterfly_tb is

end entity controlunit_butterfly_tb;

-------------------------------------------------------------------------------

architecture arch of controlunit_butterfly_tb is

component controlunit_butterfly is

port ( status: in std_logic_vector ( 1 downto 0);
       clock: in std_logic;
		 datapath_commands : out std_logic_vector ( 33 downto 0));
		 end component;

  -- component ports
  signal datapath_commands                           : std_logic_vector (33 downto 0);
  signal status                         : std_logic_vector (1 downto 0);

  -- clock
  signal clock : std_logic := '1';

begin  -- architecture arch

  -- component instantiation
  DUT : controlunit_butterfly
    port map (
       datapath_commands => datapath_commands,
		 status => status,
		 clock => clock
     );

  -- clock generation
  clock <= not clock after 10 ns;

  -- waveform generation
  WaveGen_Proc : process
  begin
    -- insert signal assignments here
status <= "00";
wait for 50 ns;
status <= "00";
wait for 50 ns;
status <= "10";
wait;
  end process WaveGen_Proc;



end architecture arch;