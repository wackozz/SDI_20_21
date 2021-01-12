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
    0      => "0000000000000000000000000000010",  --00000 RESET
    1      => "0000000000000000000000110000100",  --00001 LOAD W
    2      => "1000000000000000000000000000110",  --00010 IDLE
	 3      => "0000000000000000000000000000100",  --00011 SALTO ALLO STATO DI ILDE(se non arriva start)
    4      => "0001110010000101001010010001010",  --00100 Mpy1_FS
    5      => "0000000001001101011001010001100",  --00101 Mpy3_fs
    6      => "0000101000000101010101100001110",  --00110 Mpy2Add1_fs
    7      => "0000010000000100000000001010000",  --00111 Mpy4Add3_fs
    8      => "0000101000000110100100000010010",  --01000 Mpy5Add2_fs
    9      => "0000110100001100110000000010100",  --01001 Mpy6Add4_fs
    10     => "0001110000010110000000000011000",  --01010 Add5Rounding_fs 
    11     => "0000110100100101000111111001000",  --01011 Add6Rounding_FS
	 12     => "0000110100100000000000000011010",  --01100 Add6Rounding_fs
    13     => "0001010010000000000000000011100",  --01101 loadAiRounding_fs
    14     => "0000000001000000000000000011110",  --01110 loadBrrounding_fs
    15     => "0000000000000000000000000100000",  --01111 loadBi_fs
    16     => "0010000000000000000000000000000",  --10000 done
   
    others => "0000000000000000000000000000000");
	 

  type memory_odd is array (0 to 16) of std_logic_vector (N-1 downto 0);
  signal rom_odd : memory_odd := (
    2      => "1000000000000000000000000000111",  --stato 1
    3      => "0000000000000001000111111001001",  --00011 wait
    4      => "0000000000000101001010010001011",  --00100 Mpy1
    5      => "0000000000001101011001011001101",  --00101 Mpy3
    6      => "0000101000000101010101100001111",  --00110 Mpy2Add1
    7      => "0000010000000100000000001010001",  --00111 Mpy4Add3 
    8      => "0000101000000110100100000010011",  --01000 Mpy5Add2
    9      => "0000010100001100110000000010101",  --01001 Mpy6Add4
    10     => "1101110000010110000000000010111",  --01010 Add5Rounding
    11     => "0000110100100000000000000011001",  --01011 Add6Rounding
    12     => "0001010010000000000000000011011",  --01100 loadA'iRounding
    13     => "0000000001000000000000000011101",  --01101 loadB'rRounding
    14     => "0000000000000000000000000011111",  --01110 loadB'i
	 15     => "0010000000000000000000000000000",  --01111 done
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
