library ieee;
use ieee.std_logic_1164.all;

entity controlunit_butterfly is

  port (status            : in  std_logic_vector (1 downto 0);
        clock             : in  std_logic;
        reset             : in  std_logic;
        datapath_commands : out std_logic_vector (18 downto 0));
end controlunit_butterfly;

architecture behav of controlunit_butterfly is

<<<<<<< HEAD
  component microROM is
=======
component microROM is
 
 GENERIC (CONSTANT N : INTEGER := 27);
 PORT ( ADDRESS : IN STD_LOGIC_VECTOR ( 4 DOWNTO 0);
        OUT_MEM_even,OUT_MEM_odd : OUT STD_LOGIC_VECTOR (N-1 DOWNTO 0));
end component;
>>>>>>> afa76151a7b4c91836ff0b9edaec3261f7c84273

    generic (constant N : integer := 26);
    port (ADDRESS                   : in  std_logic_vector (4 downto 0);
          OUT_MEM_even, OUT_MEM_odd : out std_logic_vector (N-1 downto 0));
  end component;

  component PLA_status is
    port (full_speed, start, lsb_in : in  std_logic;
          cc_validation             : in  std_logic_vector(1 downto 0);
          s_mux_late, LSB_out       : out std_logic);
  end component;

<<<<<<< HEAD
  component mux_2_to_1_rom is
=======
PORT ( x1,y1: in std_logic_vector (26 downto 0);
       s: in std_logic;
		 m1:out std_logic_vector(26 downto 0));
end component;
>>>>>>> afa76151a7b4c91836ff0b9edaec3261f7c84273

    port (x1, y1 : in  std_logic_vector (25 downto 0);
          s      : in  std_logic;
          m1     : out std_logic_vector(25 downto 0));
  end component;

  component mux_2_to_1 is

<<<<<<< HEAD
    port (x1, y1 : in  std_logic;
          s      : in  std_logic;
          m1     : out std_logic);
  end component;

  component reg is
    generic (
      N : integer);
    port (
      D                    : in  std_logic_vector(N-1 downto 0);
      clock, reset, enable : in  std_logic;
      Q                    : out std_logic_vector(N-1 downto 0));
  end component reg;

  signal out_uIR : std_logic_vector(25 downto 0);
  signal mem_out1, mem_out2, mux_out          : std_logic_vector (25 downto 0);
  signal lsb2, sel_mux_late, in1_mux, in2_mux : std_logic;
  signal out_uADR : std_logic_vector(4 downto 0);

begin

  datapath_commands <= mux_out(23 downto 5);
--mux_out_s <= mux_out;

  rom :
    microROM port map (ADDRESS => out_uADR, OUT_MEM_even => mem_out1, OUT_MEM_odd => mem_out2);

  muxROM :
    mux_2_to_1_rom port map (x1 => mem_out1, y1 => mem_out2, s => lsb2, m1(25 downto 0) => mux_out(25 downto 0));

  late_status :
    PLA_status port map (full_speed    => status(1), start => status(0), lsb_in => mux_out(0),
                         cc_validation => mux_out(25 downto 24), LSB_out => in2_mux, s_mux_late => sel_mux_late);


  mux :
    mux_2_to_1 port map(x1 => mux_out(0), y1 => in2_mux, s => sel_mux_late, m1 => lsb2);

  -- instance "reg_1"
  uADR : reg
    generic map (
      N => 5)
    port map (
      D      => out_uIR(4 downto 0),
      clock  => clock,
      reset  => reset,
      enable => '1',
      Q      => out_uADR);

  -- instance "reg_2"
  uIR : reg
    generic map (
      N => 26)
    port map (
      D      => mux_out(25 downto 0),
      clock  => clock,
      reset  => reset,
      enable => '1',
      Q      => out_uIR);

end behav;
=======
component reg is

  generic (N : integer:= 5 );

  port (D : in std_logic_vector(N-1 downto 0);

        clock,reset, enable : in std_logic;

        Q : out std_logic_vector(N-1 downto 0));
end component;

component reg27 is

  generic (N : integer := 27);

  port (D : in std_logic_vector(N-1 downto 0);

        clock,reset, enable : in std_logic;

        Q : out std_logic_vector(N-1 downto 0));
end component;


signal mem_out1,mem_out2,mux_out : std_logic_vector (26 downto 0);
signal lsb2 ,sel_mux_late,in1_mux,in2_mux: std_logic ;
signal out_uAR :std_logic_vector(4 downto 0);
signal out_uIR :std_logic_vector(26 downto 0);

begin

datapath_commands <= mux_out(24 downto 6);
--mux_out_s <= mux_out;

rom:
microROM port map (ADDRESS => out_uAR,OUT_MEM_even => mem_out1, OUT_MEM_odd => mem_out2);

muxROM:
mux_2_to_1_rom port map (x1 => mem_out1, y1 => mem_out2, s=> lsb2, m1(26 downto 0) => mux_out(26 downto 0));

late_status:
PLA_status port map (full_speed =>status(1), start=> status(0), lsb_in => out_uIR(0),
                     cc_validation => out_uIR(26 downto 25),LSB_out =>in2_mux,s_mux_late => sel_mux_late);

							
mux:
mux_2_to_1 port map( x1=> out_uIR(0), y1 => in2_mux, s=> sel_mux_late, m1=> lsb2 );

reguADr:
reg port map ( D=> out_uIR(5 downto 1), clock => clock,enable => '1', reset =>'1',Q=> out_uAR);

reguIR:
reg27 port map (  D=> mux_out, clock => clock,enable => '1', reset =>'1',Q=> out_uIR);

end behav;  
                
>>>>>>> afa76151a7b4c91836ff0b9edaec3261f7c84273
