library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity microROM is

  generic (constant N : integer := 24);
  port (ADDRESS                   : in  std_logic_vector (3 downto 0);
        OUT_MEM_even, OUT_MEM_odd : out std_logic_vector (N-1 downto 0));
end microROM;


architecture behav of microROM is

  type memory_even is array (0 to 15) of std_logic_vector (N-1 downto 0);
  signal rom_even : memory_even := (



    --   cc_val                              next add
    --          done,DC 3-16       en W,AB
    0  => "00" &"000000000000000" &"00" &"0001"&"0",  --00000 RESET
    1  => "00" &"000000000000000" &"10" &"0010"&"0",  --00001 LOADW
    2  => "10" &"000000000000000" &"00" &"0010"&"0",  --0010 IDLE
    8  => "00" &"010100000000110" &"01" &"1001"&"0",  --1001 #7 Mpy6Add4//mem_DATA_in[FS]
    9  => "00" &"000000001111001" &"00" &"1010"&"0",  --1010 #8 Add5Round1//Mpy1
    10 => "00" &"011100010001011" &"00" &"1011"&"0",  --1011 #1 Add6Round2//Mpy3
    11 => "00" &"000000100001010" &"00" &"1100"&"0",  --1101 #10 Round3//Mpy2Add1
    12 => "00" &"010010000001000" &"00" &"1101"&"0",  --1110 #11 Round4//Mp4Add3
    13 => "00" &"000001000110100" &"00" &"1110"&"0",  --1111 #12 //Mpy5Add2
    14 => "01" &"110100000000110" &"01" &"1001"&"0",  --1111 #13 done//Mpy6Add4

    others => "000000000000000000000000");


  type memory_odd is array (0 to 15) of std_logic_vector (N-1 downto 0);
  signal rom_odd : memory_odd := (
    --    cc_val                             next add
    --          done,DC 3-16       en W,AB
    2  => "00" &"000000000000000" &"01" &"0011"&"1",  --0011 wait
    3  => "00" &"000000000001001" &"00" &"0100"&"1",  --0100 Mpy1
    4  => "00" &"000000000001011" &"00" &"0101"&"1",  --0101 Mpy3
    5  => "00" &"000000000001010" &"00" &"0110"&"1",  --0110 Mpy2Add1
    6  => "00" &"010000000001000" &"00" &"0111"&"1",  --0111 Mpy4Add3 
    7  => "11" &"000000000110100" &"00" &"1000"&"1",  --1000 Mpy5Add2
    8  => "00" &"010100000000110" &"00" &"1001"&"1",  --1001 Mpy6Add4
    9  => "00" &"000000001110000" &"00" &"1010"&"1",  --1010 Add5Rounding
    10 => "00" &"011100010000000" &"00" &"1011"&"1",  --1011 Add6Rounding
    11 => "00" &"000000100000000" &"00" &"1100"&"1",  --1100 loadA'iRounding
    12 => "00" &"010010000000000" &"00" &"1101"&"1",  --1101 loadB'rRounding
    13 => "00" &"000001000000000" &"00" &"1110"&"1",  --1110 loadB'i
    14 => "00" &"110000000000000" &"00" &"0010"&"0",  --1110 done

    others => "000000000000000000000000");

begin

  process (ADDRESS)
  begin

    OUT_MEM_even <= rom_even(to_integer(unsigned(ADDRESS)));


    OUT_MEM_odd <= rom_odd(to_integer(unsigned(ADDRESS)));

  end process;

end behav;
