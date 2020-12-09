LIBRARY ieee;  

USE ieee.std_logic_1164.all;  

USE ieee.numeric_std.all; 

  

ENTITY bus_reg IS   

GENERIC (N : integer:=8);   

PORT (R : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);    

Clock, Reset, Enable : IN  STD_LOGIC;    

Q : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));  

END bus_reg;  

  

ARCHITECTURE behav OF bus_reg IS  

BEGIN  PROCESS (Clock, Reset)   

BEGIN   IF (Reset = '0')   

THEN    Q <= (OTHERS => '0');  

ELSIF (Clock'EVENT AND Clock = '1') THEN     
IF (Enable = '1') THEN
Q <= R;    

END IF;
END IF;   

END PROCESS;  

END behav;     

