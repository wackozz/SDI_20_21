library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity microROM is

  generic (constant N : integer := 31);
  port (ADDRESS                   : in  std_logic_vector (4 downto 0);
        OUT_MEM_even, OUT_MEM_odd : out std_logic_vector (N-1 downto 0));
end microROM;


architecture behav of microROM is


  type memory_even is array (0 to 16) of std_logic_vector (N-1 downto 0);
  signal rom_even : memory_even := (
    0  => "0000000000000000000000000000010",  --0001|0 stato 1
    1  => "0000000000000000000000110000100",  --0010|0 stato 2
    2  => "1000000000000000000000000000110",  --0011|0  --0011|1 stato 3
    3  => "0000000000000000000000000000100",
    4  => "0000110100100001000111111001010",  --0100|0  stato 12
    5  => "0001100010000101001010010001100",  --0101|0  stato 13
    6  => "0000000001001101011001001001110",  --0110|0  stato 14
    7  => "0000010000000101010101100010000",  --0111|0  stato 15
    8  => "0000100000001100000000001010010",  --1000|0  stato 16
    9  => "0000011000000110100100000010100",  --1001|0  stato 17
    10 => "0000100100001100110000000011000",  --1010|0  stato 18         
    11 => "1100010000010010000000000010110",  --1011|0  stato 19
    12 => "0000110100100001000111111011010",
    13 => "0001100100100000000000000011100",  --1100|0  stato 20
    14 => "0000100010000000000000000011110",  --1101|0  stato 22
    15 => "0001000001000000000000000100000",  --1111|0  stato 24
    16 => "0010000000000000000000000000000",  --0000|0  stato 25

    others => "0000000000000000000000000000000");


  type memory_odd is array (0 to 16) of std_logic_vector (N-1 downto 0);
  signal rom_odd : memory_odd := (
    2      => "1000000000000000000000000000111",  --stato 1
    3      => "0000000000000001000111111001001",  --00100|1 stato4
    4      => "0000000000000101001010010001011",  --00101|1 stato 5
    5      => "0000000000001101011001011001101",  --00110|1 stato 6
    6      => "0000011000000111010101100001111",  --00111|1 stato 7
    7      => "0000100000000100000000001010001",  --01000|1 stato 8
    8      => "0000011000000110100100000010011",  --01001|1 stato 9
    9      => "0000100100001100110000000010101",  --01010|1 stato 10
    10     => "1100010000010110000000000010111",  --01011|1 stato 11
    11     => "0001100100100000000000000011001",  --01100|1 stato 26
    12     => "0000100010000000000000000011011",  --01101|1 stato 27
    13     => "0001000001000000000000000011101",  --01110|1 stato 28
    14     => "0000000000000000000000000011111",  --        stato 29
    15     => "0010000000000000000000000000000",  --0000|0  stato 30
    others => "0000000000000000000000000000000");


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
