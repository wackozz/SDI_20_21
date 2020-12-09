LIBRARY ieee;

USE ieee.std_logic_1164.all;



ENTITY mux_2_to_1 IS

PORT( x1, y1, s : IN std_logic;

m_out :OUT std_logic_vector(7 downto 0)); 

END mux_2_to_1 ; 



ARCHITECTURE behavior OF mux_2_to_1 IS

BEGIN

m_out <= (NOT (s) AND x1) OR(s AND y1); 

END behavior; 