library ieee;
use ieee.std_logic_1164.all;

ENTITY mux_2_to_1 IS

PORT ( x1,y1: in std_logic;
       s: in std_logic;
		 m1:out std_logic);
end mux_2_to_1;

architecture behav of mux_2_to_1 is

begin 

m1 <= (not(s) and x1) or (s and y1);

end behav;