library ieee;
use ieee.std_logic_1164.all;

entity PLA_status is
port (full_speed,start,lsb_in: in std_logic;
      cc_validation : in std_logic_vector(1 downto 0);
		s_mux_late,LSB_out : out std_logic);
end PLA_status;


architecture behav of PLA_status is

component mux_2_to_1 IS
port( x1,y1 : in std_logic;
      s: in std_logic;
		m1: out std_logic);

end component;

signal full_speed_s,start_s,s_mux_int : std_logic;
signal cc_validation_s1,cc_validation_s2 : std_logic;
signal lsb_in_s :std_logic;

begin
cc_validation_s1 <= (cc_validation(1) AND (NOT(cc_validation(0))));
cc_validation_s2 <= (cc_validation(1) AND (cc_validation(0)));

full_speed_s <= (cc_validation_s2 AND full_speed);
start_s <= (cc_validation_s1 AND start);

--mux interno al PLA
s_mux_int <= full_speed_s OR start_s;

--selettore del mux esterno
s_mux_late <= (NOT cc_validation(0)) AND (NOT(cc_validation(1)));

lsb_in_s <= not lsb_in;

mux:
mux_2_to_1 port map (x1 => lsb_in, y1 => lsb_in_s, s => s_mux_int, m1 => LSB_out); 

end behav;