library ieee;

use ieee.std_logic_1164.all;

use ieee.numeric_std.all;



entity bus_reg is

  generic (N : integer := 8);

  port (R : in std_logic_vector(N-1 downto 0);

        Clock, Reset, Enable : in std_logic;

        Q : out std_logic_vector(N-1 downto 0));

end bus_reg;



architecture behav of bus_reg is

begin process (Clock, Reset)

      begin
        if (Reset = '0')

        then Q <= (others => '0');

        elsif (Clock'event and Clock = '1') then
          if (Enable = '1') then
            Q <= R;

          end if;
        end if;

      end process;

      end behav;

