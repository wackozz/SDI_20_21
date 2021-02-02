library ieee;
use ieee.std_logic_1164.all;

entity PLA_status is
  port (start, lsb_in : in  std_logic;
        cc_validation : in  std_logic_vector(1 downto 0);
        LSB_out       : out std_logic);
end PLA_status;


architecture behav of PLA_status is

  component mux_2_to_1 is
    port(x1, y1 : in  std_logic;
         s      : in  std_logic;
         m1     : out std_logic);

  end component;
  signal s_mux : std_logic;
  signal lsb_in_neg : std_logic;
begin

  s_mux <= (start and cc_validation(1) and not(cc_validation(0))) or (not(start) and not(cc_validation(1)) and cc_validation(0)); 
  lsb_in_neg <= not lsb_in;

  mux :
    mux_2_to_1 port map (x1 => lsb_in, y1 => lsb_in_neg, s => s_mux, m1 => LSB_out);

end behav;
