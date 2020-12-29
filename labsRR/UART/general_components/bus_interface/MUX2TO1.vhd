library ieee;

use ieee.std_logic_1164.all;



entity mux_2_to_1 is

  port(x1, y1 : in std_logic_vector (7 downto 0);
       s      : in std_logic;

       m_out : out std_logic_vector(7 downto 0));

end mux_2_to_1;



architecture behavior of mux_2_to_1 is

begin

  m_out(0) <= (not (s) and x1(0)) or(s and y1(0));
  m_out(1) <= (not (s) and x1(1)) or(s and y1(1));
  m_out(2) <= (not (s) and x1(2)) or(s and y1(2));
  m_out(3) <= (not (s) and x1(3)) or(s and y1(3));
  m_out(4) <= (not (s) and x1(4)) or(s and y1(4));
  m_out(5) <= (not (s) and x1(5)) or(s and y1(5));
  m_out(6) <= (not (s) and x1(6)) or(s and y1(6));
  m_out(7) <= (not (s) and x1(7)) or(s and y1(7));




end behavior;
