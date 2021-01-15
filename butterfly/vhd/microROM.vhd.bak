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
    ---1 => "00" & done & s_mux_round_in & add_reg_2_en & add_reg_1_en & sub_add_1 & s_mux_b_add_1 & en_br_out & en_bj_out & en_aj_out & en_ar_out & sub_add_2 & mpy_reg_en & s_mux_b_add_2 & sh_mpy & s_mux_a_mpy & s_mux_b_mpy & en_aj & en_br & en_bj & en_wr & en_wj & en_ar

    --   cc_val                                next add
    --          oth.instr. 6-22     en_in 0-5
    0  => "00" &"00000000000000000" &"000000" &"000010",  --00000 RESET
    1  => "00" &"00000000000000000" &"000110" &"000100",  --00001 LOAD W
    2  => "10" &"00000000000000000" &"000000" &"000110",  --00010 IDLE
    3  => "00" &"00000000000000000" &"000000" &"000100",  --00011 SALTO ALLO STATO DI ILDE(se non arriva start)
    4  => "00" &"01000010000101001" &"010010" &"001010",  --00100 Mpy1_FS
    5  => "00" &"00000001000101011" &"001010" &"001100",  --00101 Mpy3_fs
    6  => "00" &"00000000000101010" &"101100" &"001110",  --00110 Mpy2Add1_fs
    7  => "00" &"00100000000100000" &"000001" &"010000",  --00111 Mpy4Add3_fs
    8  => "00" &"00010000001110100" &"100000" &"010010",  --01000 Mpy5Add2_fs
    9  => "00" &"00100100000100010" &"000000" &"010100",  --01001 Mpy6Add4_fs
    10 => "00" &"01010000001110000" &"000000" &"011000",  --01010 Add5Rounding_fs 
    11 => "00" &"00100100010101000" &"111111" &"001000",  --01011 Add6Rounding_FS (primo stato full speed)
    12 => "00" &"00011100100000000" &"000000" &"011010",  --01100 Add6Rounding_fs
    13 => "00" &"01100010000000000" &"000000" &"011100",  --01101 loadAiRounding_fs
    14 => "00" &"00000001000000000" &"000000" &"011110",  --01110 loadBrrounding_fs
    15 => "00" &"00000000000000000" &"000000" &"100000",  --01111 loadBi_fs
    16 => "00" &"10000000000000000" &"000000" &"000000",  --10000 done

    others => "0000000000000000000000000000000");


  type memory_odd is array (0 to 16) of std_logic_vector (N-1 downto 0);
  signal rom_odd : memory_odd := (
    --    cc_val                               next add
    --          oth.instr            en_in_reg
    2  => "10" &"00000000000000000" &"000000" &"000111",  --stato 1
    3  => "00" &"00000000000001000" &"111111" &"001001",  --00011 wait
    4  => "00" &"00000000000101001" &"010010" &"001011",  --00100 Mpy1
    5  => "00" &"00000000000101011" &"001011" &"001101",  --00101 Mpy3
    6  => "00" &"00000000000101010" &"101100" &"001111",  --00110 Mpy2Add1
    7  => "00" &"00100000000101000" &"000001" &"010001",  --00111 Mpy4Add3 
    8  => "00" &"00010000001110100" &"100000" &"010011",  --01000 Mpy5Add2
    9  => "00" &"00100100000100110" &"000000" &"010101",  --01001 Mpy6Add4
    10 => "11" &"01010000001110000" &"000000" &"010111",  --01010 Add5Rounding
    11 => "00" &"00101100010000000" &"000000" &"011001",  --01011 Add6Rounding
    12 => "00" &"01010000100000000" &"000000" &"011011",  --01100 loadA'iRounding
    13 => "00" &"00000010000000000" &"000000" &"011101",  --01101 loadB'rRounding
    14 => "00" &"00000001000000000" &"000000" &"011111",  --01110 loadB'i
    15 => "00" &"10000000000000000" &"000000" &"000000",  --01111 done

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
