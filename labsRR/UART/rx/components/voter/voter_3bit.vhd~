LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY voter_3bit IS
  PORT (
    d : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- input
    vote : OUT STD_LOGIC 		--output
  );
END voter_3bit;

ARCHITECTURE arch OF voter_3bit IS
begin
vote <= ((d(0) and (d(1) or d(2))) or ((d(1) and d(2)))); 

END ARCHITECTURE;