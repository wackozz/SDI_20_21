library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity microROM is
 
 GENERIC (CONSTANT N : INTEGER := 26);
 PORT ( ADDRESS : IN std_logic_vector ( 4 DOWNTO 0);
        OUT_MEM_even,OUT_MEM_odd : OUT STD_LOGIC_VECTOR (N-1 DOWNTO 0));
 END microROM;
 
 
 architecture behav of microROM is
 

 type memory_even is array (0 to 16) of std_logic_vector (N-1 DOWNTO 0);
constant rom_even : memory_even := (
                  0 => "00000000000000000000000010", --00001|0
						1 => "00000000000000000110000100", --00010|0
						2 => "10000000000000000000000110", --00011|0
						3 => "00000000101000111111001000", --00100|0
						4 => "00000101001001001011001010", --00101|0
						5 => "00001000000010000001001100", --00110|0
						6 => "00000001101100010010001110", --00111|0
						7 => "00000001101011101100010000", --01000|0
						8 => "00000011010000100000010010", --01001|0
						9 => "11010000100110000000010100", --01010|0
						10 => "00010000100100000000010110",--01011|0
						11 => "00000000000000000000011000",--01100|0
						12 => "00000100000000000000011010",--01101|0
						13 => "00001000000000000000011110",--01111|0
						14 => "00000000000000000000100000",--10000|0
						15=> "00100000000000000000000000",--00000|0
						others => "00000000000000000000000100");
						

 type memory_odd is array (0 to 16) of std_logic_vector (N-1 DOWNTO 0);
constant rom_odd : memory_odd := (	
                  2 => "10000000000000000000000111",--00011|1
						3=> "00000000001000111111001001",--00100|1
						4=> "00000001001001001011001011",--00101|1
						5 => "00000000000010000001001101",--00110|1
						6 => "00000001101100010010001111",--00111|1
						7 => "00000001101011101100011111",--01000|1
						8 => "00000011010000100000010011",--01001|1
						9 => "11010000100110000000010101",--01010|1
						10 => "00000000100000000000010111",--01011|1
						11 => "00000100000000000000011001",--01100|1
						12 => "00001000000000000000011011",--01101|1
						13 => "00000000000000000000011101",--01110|1
						14 => "00100000000000000000000001",
						others => "00000000000000000000000101");

						
	--out_mem(25 downto 24) =>cc_validation
	--out_mem(23	downto 6) => controlli da mandare al datapath
	--out_mem(5 downto 1) => indirizzo a 5 bit senza lsb da mandare al uADr equindi alla uROM
	--out_mem(0) => lsb da mandare al pla status  che diventerà selettore della uROM
	begin
	process (ADDRESS)
	begin
         
        OUT_MEM_even <= rom_even(to_integer(unsigned(ADDRESS)));
	
        
	OUT_MEM_odd <= rom_odd(to_integer(unsigned(ADDRESS)));
	end process;
	
	end behav;