library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity microROM is

  generic (constant N : integer := 27);
  port (ADDRESS                   : in  std_logic_vector (4 downto 0);
        OUT_MEM_even, OUT_MEM_odd : out std_logic_vector (N-1 downto 0));
end microROM;


architecture behav of microROM is

  signal add1 : integer;
  type memory_even is array (0 to 16) of std_logic_vector (N-1 downto 0);
  signal rom_even : memory_even := (
    0      => "000100000000000000000000010",  --00001|0
    1      => "000000000000000000110000100",  --00010|0
    2      => "100000000000000000000000110",  --00011|0
    3      => "000000000101000111111001000",  --00100|0
    4      => "000000101001001001011001010",  --00101|0
    5      => "000001000000010000001001100",  --00110|0
    6      => "000000001101100010010001110",  --00111|0
    7      => "000000001101011101100010000",  --01000|0
    8      => "000000011010000100000010010",  --01001|0
    9      => "110010000100110000000010100",  --01010|0
    10     => "000010000100100000000010110",  --01011|0
    11     => "000000000000000000000011000",  --01100|0
    13     => "000000100000000000000011010",  --01101|0
    14     => "000001000000000000000011110",  --01111|0
    15     => "000000000000000000000100000",  --10000|0
    16     => "001000000000000000000000000",  --00000|0
    others => "000000000000000000000000000");

  signal add2 : integer;
  type memory_odd is array (0 to 16) of std_logic_vector (N-1 downto 0);
  signal rom_odd : memory_odd := (
    2      => "100000000000000000000000111",  --00011|1
    3      => "000000000001000111111001001",  --00100|1
    4      => "000000001001001001011001011",  --00101|1
    5      => "000000000000010000001001101",  --00110|1
    6      => "000000001101100010010001111",  --00111|1
    7      => "000000001101011101100011111",  --01000|1
    8      => "000000011010000100000010011",  --01001|1
    9      => "110010000100110000000010101",  --01010|1
    10     => "000000000100000000000010111",  --01011|1
    11     => "000000100000000000000011001",  --01100|1
    12     => "000001000000000000000011011",  --01101|1
    13     => "000000000000000000000011101",  --01110|1
    14     => "001000000000000000000000001",
    others => "000000000000000000000000001");


--out_mem(26 downto 25) =>cc_validation
--out_mem(24 downto 6) => controlli da mandare al datapath
--out_mem(5 downto 1) => indirizzo a 5 bit senza lsb da mandare al uADr equindi alla uROM
--out_mem(0) => lsb da mandare al pla status  che diventerà selettore della uROM
begin

  add1         <= to_integer(unsigned(ADDRESS));
  OUT_MEM_even <= rom_even(add1);

  add2        <= to_integer(unsigned(ADDRESS));
  OUT_MEM_odd <= rom_odd(add2);

end behav;
