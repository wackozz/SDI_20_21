library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity microROM is

  generic (constant N : integer := 32);
  port (ADDRESS                   : in  std_logic_vector (3 downto 0);
        OUT_MEM_even, OUT_MEM_odd : out std_logic_vector (N-1 downto 0));
end microROM;


architecture behav of microROM is

  type memory_even is array (0 to 16) of std_logic_vector (N-1 downto 0);
  signal rom_even : memory_even := (



    --   cc_val                                next add
    --          oth.instr. 6-22     en_in 0-5
    0  => "00" &"0000000000000000000" &"000000" &"0001"&"0",  --00000 RESET
    1  => "00" &"0000000000000000000" &"000110" &"0010"&"0",  --00001 LOADW
    2  => "10" &"0000000000000000000" &"000000" &"0010"&"0",  --0010 IDLE
    8  => "00" &"0010001000000100110" &"111001" &"1001"&"0",  --1001 #7 Mpy6Add4//mem_DATA_in[FS]
    9  => "00" &"0101000000011111001" &"000000" &"1010"&"0",  --1010 #8 Add5Round1//Mpy1
    10 => "00" &"0010111000100101011" &"000000" &"1011"&"0",  --1011 #1 Add6Round2//Mpy3
    11 => "00" &"0101000001000101010" &"000000" &"1100"&"0",  --1101 #10 Round3//Mpy2Add1
    12 => "00" &"0010000100000101000" &"000000" &"1101"&"0",  --1110 #11 Round4//Mp4Add3
    13 => "00" &"0101000010001110100" &"000000" &"1110"&"0",  --1111 #12 //Mpy5Add2
    14 => "01" &"1010001000000100110" &"111001" &"1001"&"0",  --1111 #13 done//Mpy6Add4

    others => "00000000000000000000000000000000");


  type memory_odd is array (0 to 16) of std_logic_vector (N-1 downto 0);
  signal rom_odd : memory_odd := (
    --    cc_val                               next add
    --          oth.instr            en_in_reg
    2  => "00" &"0000000000000001000" &"111001" &"0011"&"1",  --0011 wait
    3  => "00" &"0000000000000101001" &"000000" &"0100"&"1",  --0100 Mpy1
    4  => "00" &"0000000000000101011" &"000000" &"0101"&"1",  --0101 Mpy3
    5  => "00" &"0000000000000101010" &"000000" &"0110"&"1",  --0110 Mpy2Add1
    6  => "00" &"0010000000000101000" &"000000" &"0111"&"1",  --0111 Mpy4Add3 
    7  => "11" &"0101000000001110100" &"000000" &"1000"&"1",  --1000 Mpy5Add2
    8  => "00" &"0010001000000100110" &"000000" &"1001"&"1",  --1001 Mpy6Add4
    9  => "00" &"0101000000011110000" &"000000" &"1010"&"1",  --1010 Add5Rounding
    10 => "00" &"0010111000100000000" &"000000" &"1011"&"1",  --1011 Add6Rounding
    11 => "00" &"0101000001000000000" &"000000" &"1100"&"1",  --1100 loadA'iRounding
    12 => "00" &"0000000100000000000" &"000000" &"1101"&"1",  --1101 loadB'rRounding
    13 => "00" &"0000000010000000000" &"000000" &"1110"&"1",  --1110 loadB'i
    14 => "00" &"1000000000000000000" &"000000" &"0010"&"0",  --1110 done

    others => "00000000000000000000000000000000");


--out_mem(30 downto 29) =>cc_validation
--out_mem(28 downto 6) => controlli da mandare al datapath
--out_mem(5 downto 1) => indirizzo a 5 bit senza lsb da mandare al uADr equindi alla uROM
--out_mem(0) => lsb da mandare al pla status  che diventerà selettore della uROM
begin

  process (ADDRESS)
  begin

    OUT_MEM_even <= rom_even(to_integer(unsigned(ADDRESS)));


    OUT_MEM_odd <= rom_odd(to_integer(unsigned(ADDRESS)));

  end process;

end behav;
