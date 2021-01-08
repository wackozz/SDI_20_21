library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controlunit_butterfly is

port ( status: in std_logic_vector ( 1 downto 0);
       clock,reset: in std_logic;
		 datapath_commands : out std_logic_vector ( 16 downto 0);
		 done: out std_logic);
end controlunit_butterfly;

architecture behav of controlunit_butterfly is

component microROM is
 
 GENERIC (CONSTANT N : INTEGER := 26);
 PORT ( ADDRESS : IN std_logic_vector ( 4 DOWNTO 0);
        OUT_MEM_even,OUT_MEM_odd : OUT STD_LOGIC_VECTOR (N-1 DOWNTO 0));
end component;

component PLA_status is
port (full_speed,start,lsb_in: in std_logic;
      cc_validation : in std_logic_vector(1 downto 0);
		LSB_out : out std_logic);
end component;

component mux_2_to_1_rom IS

PORT ( x1,y1: in std_logic_vector (25 downto 0);
       s: in std_logic;
		 m1:out std_logic_vector(25 downto 0));
end component;



component reg is

  generic (N : integer:= 6 );

  port (D : in std_logic_vector(N-1 downto 0);

        clock,reset, enable : in std_logic;

        Q : out std_logic_vector(N-1 downto 0));
end component;		  

signal mem_out1,mem_out2,mux_out : std_logic_vector (25 downto 0);
signal in2_mux,in_uAR: std_logic ;
signal  out_uAR,D_uAR :std_logic_vector(5 downto 0);
signal in_uAR2 : std_logic_vector(4 downto 0);


begin

datapath_commands <= mux_out(22 downto 6);
done <= mux_out(23);
in_uAR2 <= mux_out(5 downto 1);
D_uAR <= in_uAR & in_uAR2;




rom:
microROM port map (ADDRESS => out_uAR(5 downto 1),OUT_MEM_even => mem_out1, OUT_MEM_odd => mem_out2);

muxROM:
mux_2_to_1_rom port map (x1 => mem_out1, y1 => mem_out2, s=> out_uAR(0), m1(25 downto 0) => mux_out(25 downto 0));

late_status:
PLA_status port map (full_speed =>status(0), start=> status(1), lsb_in => mux_out(0),
                     cc_validation =>mux_out(25 downto 24),LSB_out => in_uAR);


reguADr:
reg port map ( D=> D_uAR, clock => clock,enable => '1', reset =>reset,Q=> out_uAR);





end behav;  
                