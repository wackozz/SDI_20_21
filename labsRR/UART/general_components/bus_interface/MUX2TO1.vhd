LIBRARY ieee;

USE ieee.std_logic_1164.all;



ENTITY mux_2_to_1 IS

PORT( x1, y1 : IN std_logic_vector ( 7 downto 0);
s: IN std_logic;

m_out :OUT std_logic_vector( 7 downto 0)); 

END mux_2_to_1 ; 



ARCHITECTURE behavior OF mux_2_to_1 IS

BEGIN

m_out(0) <= (NOT (s) AND x1(0)) OR(s AND y1(0));
m_out(1) <= (NOT (s) AND x1(0)) OR(s AND y1(0));
m_out(2) <= (NOT (s) AND x1(0)) OR(s AND y1(0));
m_out(3) <= (NOT (s) AND x1(0)) OR(s AND y1(0));
m_out(4) <= (NOT (s) AND x1(0)) OR(s AND y1(0));
m_out(5) <= (NOT (s) AND x1(0)) OR(s AND y1(0));
m_out(6) <= (NOT (s) AND x1(0)) OR(s AND y1(0));
m_out(7) <= (NOT (s) AND x1(0)) OR(s AND y1(0));


 

END behavior; 