library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity microROM is
 
 GENERIC (CONSTANT N : INTEGER := 26);
 PORT ( ADDRESS : IN STD_LOGIC_VECTOR ( 4 DOWNTO 0);
        OUT_MEM_even,OUT_MEM_odd : OUT STD_LOGIC_VECTOR (N-1 DOWNTO 0));
 END microROM;
 
 
 architecture behav of microROM is
 
 signal add1 : integer;
 type memory_even is array (0 to 28) of std_logic_vector (N-1 DOWNTO 0);
 constant rom_even : memory_even := (
                  0 => "00010000000000000000000010",
						2 => "00000000000000000011000100",
						4 => "10000000000000000000000100",
						6 => "00000000010100011111101000",
						8 => "00000010100100100101101010",
						10 => "00000100000001000000101100",
						12 => "00000000110110001001001110",
						14 => "00000000110101110110010000",
						16 => "00000001101000010000010010",
						17 => "11001000010011000000000110",
						18 => "00001000010010000000010100",
						20 => "00000000000000000000010110",
						22 => "00000010000000000000011000",
						24 => "00000100000000000000011010",
						26 => "00000000000000000000011100",
						28 => "00100000000000000000000000",
						others => "00000000000000000000000000");
						
 signal add2 : integer;
 type memory_odd is array (0 to 27) of std_logic_vector (N-1 DOWNTO 0);
 constant rom_odd : memory_odd := (	
                  4 => "10000000000000000000000101",
						5 => "00000000000100011111100111",
						7 => "00000000100100100101101001",
						9 => "00000000000001000000101011",
						11 => "00000000110110001001001101",
						13 => "00000000110101110110001111",
						15 => "00000001101000010000010001",
						17 => "11001000010011000000010011",
						19 => "00000000010000000000010101",
						21 => "00000010000000000000010111",
						23 => "00000100000000000000011001",
						25 => "00000000000000000000011011",
						27 => "00100000000000000000000000",
						others => "00000000000000000000000000");

	begin
	
	add1 <= to_integer(unsigned(ADDRESS));
OUT_MEM_even <= rom_even(add1);
	
	add2 <= to_integer(unsigned(ADDRESS));
	OUT_MEM_odd <= rom_odd(add2);
	
	end behav;