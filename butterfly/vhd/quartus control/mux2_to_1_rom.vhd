library ieee;
use ieee.std_logic_1164.all;

ENTITY mux_2_to_1_rom IS

PORT ( x1,y1: in std_logic_vector (30 downto 0);
       s: in std_logic;
		 m1:out std_logic_vector(30 downto 0));
end mux_2_to_1_rom;

architecture behav of mux_2_to_1_rom is

begin 

m1(0) <= (not(s) and x1(0)) or (s and y1(0));
m1(1) <= (not(s) and x1(1)) or (s and y1(1));
m1(2) <= (not(s) and x1(2)) or (s and y1(2));
m1(3) <= (not(s) and x1(3)) or (s and y1(3));
m1(4) <= (not(s) and x1(4)) or (s and y1(4));
m1(5) <= (not(s) and x1(5)) or (s and y1(5));
m1(6) <= (not(s) and x1(6)) or (s and y1(6));
m1(7) <= (not(s) and x1(7)) or (s and y1(7));
m1(8) <= (not(s) and x1(8)) or (s and y1(8));
m1(9) <= (not(s) and x1(9)) or (s and y1(9));
m1(10) <= (not(s) and x1(10)) or (s and y1(10));
m1(11) <= (not(s) and x1(11)) or (s and y1(11));
m1(12) <= (not(s) and x1(12)) or (s and y1(12));
m1(13) <= (not(s) and x1(13)) or (s and y1(13));
m1(14) <= (not(s) and x1(14)) or (s and y1(14));
m1(15) <= (not(s) and x1(15)) or (s and y1(15));
m1(16) <= (not(s) and x1(16)) or (s and y1(16));
m1(17) <= (not(s) and x1(17)) or (s and y1(17));
m1(18) <= (not(s) and x1(18)) or (s and y1(18));
m1(19) <= (not(s) and x1(19)) or (s and y1(19));
m1(20) <= (not(s) and x1(20)) or (s and y1(20));
m1(21) <= (not(s) and x1(21)) or (s and y1(21));
m1(22) <= (not(s) and x1(22)) or (s and y1(22));
m1(23) <= (not(s) and x1(23)) or (s and y1(23));
m1(24) <= (not(s) and x1(24)) or (s and y1(24));
m1(25) <= (not(s) and x1(25)) or (s and y1(25));
m1(26) <= (not(s) and x1(26)) or (s and y1(26));
m1(27) <= (not(s) and x1(27)) or (s and y1(27));
m1(28) <= (not(s) and x1(28)) or (s and y1(28));
m1(29) <= (not(s) and x1(29)) or (s and y1(29));
m1(30) <= (not(s) and x1(30)) or (s and y1(30));


end behav;