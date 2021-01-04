library ieee;
use ieee.std_logic_1164.all;


entity butterfly is
port ( start,full_speed : in std_logic;
       clock : in std_logic;
       done: buffer std_logic;
		 AR,AI,BR,BI,WR,WI: in std_logic_vector(19 downto 0);
		 AR_out,AI_out,BR_out,BI_out: out std_logic_vector(19 downto 0));
		 
end butterfly;

architecture behav of butterfly is

component controlunit_butterfly is

port ( status: in std_logic_vector ( 1 downto 0);
       clock: in std_logic;
		 datapath_commands : out std_logic_vector ( 18 downto 0));
end component;


component butterfly_dp is

  generic(
    N : integer := 20);
  port (
    clock       : in  std_logic;
    reset       : in  std_logic;
-- INPUT
    Wr          : in  std_logic_vector(19 downto 0);
    Wj          : in  std_logic_vector(19 downto 0);
    Aj_in       : in  std_logic_vector(19 downto 0);
    Ar_in       : in  std_logic_vector(19 downto 0);
    Bj_in       : in  std_logic_vector(19 downto 0);
    Br_in       : in  std_logic_vector(19 downto 0);
--OUTPUT
    Aj_out      : out std_logic_vector(19 downto 0);
    Ar_out      : out std_logic_vector(19 downto 0);
    Bj_out      : out std_logic_vector(19 downto 0);
    Br_out      : out std_logic_vector(19 downto 0);
-- MUX SEL SIGNALS
    s_mux_B_mpy : in  std_logic;
    s_mux_A_mpy : in  std_logic_vector(1 downto 0);
    s_mux_B_add : in  std_logic_vector(1 downto 0);
-- ADD/MPY CTRL
    add_sub     : in  std_logic;
    sh_mpy      : in  std_logic;
	 
	 -- EN
   Wr_enable     :in std_logic;
   Wj_enable     :in std_logic;
   Br_enable     :in std_logic;
   Bj_enable     :in std_logic;
   Ar_enable     :in std_logic;
   Aj_enable     :in std_logic;
   Br_out_enable :in std_logic;
   Bj_out_enable :in std_logic;
   Ar_out_enable :in std_logic;
   Aj_out_enable :in std_logic;
	
	done : out std_logic);
end component;

signal status_s,s_mux_a_mpy_s,s_mux_b_add_s: std_logic_vector (1 downto 0);
signal datapath_commands_s : std_logic_vector( 18 downto 0);
signal s_mux_b_mpy_s,enable_Ar_out_s,enable_Ai_out_s,enable_Br_out_s,enable_Bi_out_s: std_logic;
signal enable_AR_s,enable_Wi_s,enable_Wr_s,enable_Bi_s,enable_Br_s,enable_Ai_s : std_logic;
signal sh_mpy_s,sub_add_s ,reset_s, done_s: std_logic;


begin
--control unit
status_s(0) <= start ;
status_s(1) <= full_speed;

enable_AR_s <= datapath_commands_s(0);
enable_Wi_s <= datapath_commands_s(1);
enable_Wr_s <= datapath_commands_s(2);
enable_Bi_s <= datapath_commands_s(3);
enable_Br_s <= datapath_commands_s(4);
enable_Ai_s <= datapath_commands_s(5);
s_mux_b_mpy_s <= datapath_commands_s(6);
s_mux_a_mpy_s <= datapath_commands_s (8 downto 7);
sh_mpy_s <= datapath_commands_s (9);
s_mux_b_add_s <= datapath_commands_s(11 downto 10);
sub_add_s <= datapath_commands_s(12);
enable_Ar_out_s <= datapath_commands_s(13);
enable_Ai_out_s <= datapath_commands_s(14);
enable_Bi_out_s <= datapath_commands_s(15);
enable_Br_out_s <= datapath_commands_s (16);
reset_s <= datapath_commands_s(17);
done_s <= datapath_commands_s(18);


done_s <= done;

controlunit:
controlunit_butterfly port map ( status => status_s, clock => clock, datapath_commands => datapath_commands_s);

datapath:
butterfly_dp port map (clock => clock,
                       reset => reset_s,
							  Wr => WR,
							  Wj => WI,
							  Aj_in => AI,
							  Ar_in => AR,
							  Bj_in => BI,
							  Br_in => BR,
							  
							  Aj_out => AI_out,
							  Ar_out => AR_out,
							  Bj_out => BI_out,
							  Br_out => BR_out,
							  
							  s_mux_B_mpy => s_mux_b_mpy_s,
							  s_mux_A_mpy => s_mux_a_mpy_s,
							  s_mux_B_add => s_mux_b_add_s,
							  
							  add_sub => sub_add_s,
							  sh_mpy => sh_mpy_s,
							  
							  Wr_enable => enable_Wr_s,
							  Wj_enable => enable_Wi_s,
							  Br_enable => enable_Br_s,
							  Bj_enable => enable_Bi_s,
							  Ar_enable => enable_Ar_s,
							  Aj_enable => enable_Ai_s,
							  
							  Br_out_enable => enable_Br_out_s,
							  Bj_out_enable => enable_Bi_out_s,
							  Ar_out_enable => enable_Ar_out_s,
							  Aj_out_enable => enable_Ai_out_s,
							  
							  done=> done);

end behav;
							  

