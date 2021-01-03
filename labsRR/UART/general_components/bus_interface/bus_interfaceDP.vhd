LIBRARY ieee; 
USE ieee.std_logic_1164.all;

ENTITY bus_interfaceDP IS
PORT(
Dout, TX_out: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
Din, RX_in : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
RESET,CLOCK: IN STD_LOGIC;
RX_ENABLE,TX_ENABLE,CLRatn: OUT STD_LOGIC;
EN_CTRL,EN_DATARx,EN_DATATx : IN STD_LOGIC;
SEL_MUX: IN STD_LOGIC;
FF_IN: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
ENABLE_FF: IN STD_LOGIC_VECTOR (2 DOWNTO 0)
);
END bus_interfaceDP;


ARCHITECTURE behav OF bus_interfaceDP IS

component bus_reg IS   

GENERIC (N : integer:=8);   

PORT (R : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);    

Clock, Reset, Enable : IN  STD_LOGIC;    

Q : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
END component;


component  mux_2_to_1 IS

PORT ( x1, y1 : IN std_logic_vector(7 downto 0);
        s:IN std_logic;
m_out :OUT std_logic_vector(7 downto 0)); 
END component;



SIGNAL  Q_out_s3,Q_out_s4, CTRL_REGout:STD_LOGIC_vector (7 downto 0);
SIGNAL FF_OUT : STD_LOGIC_VECTOR (2 DOWNTO 0);


BEGIN 



-- FLIP FLOP PER I 3 SEGNALI DI STATO:RX_FULL,TX_EMPTY,ERROR
PROCESS (CLOCK,RESET)
BEGIN

IF (RESET ='0') THEN

FF_OUT(0) <= '0';
FF_OUT(1) <= '0';
FF_OUT(2) <= '0';

ELSE IF(CLOCK'EVENT AND CLOCK = '1') THEN

IF (ENABLE_FF(0)='1') THEN

FF_OUT(0) <= FF_IN(0);--RX FULL

END IF;

IF( ENABLE_FF(1) = '1') THEN

FF_OUT(1) <= FF_IN(1);-- TX EMPTY
END IF;

IF(ENABLE_FF(2)='1') THEN

FF_OUT(2) <= FF_IN(2);-- ERROR

END IF;
END IF;
END IF;
END PROCESS;




--STATUS REGISTER
		--bit 0 RX FULL
		--bit 1 TX EMPTY
		--bit 2 ERROR
		
Q_out_s4 <= "00000" & FF_OUT(2) & FF_OUT(1) & FF_OUT(0);-- ingresso multiplexer



-- REGISTRO CTRL
		--bit 0 ENABLE_RX
		--bit 1 ENABLE_TX
		--bit 2 CLRatn

		
RX_ENABLE <= CTRL_REGout(0);
TX_ENABLE <= CTRL_REGout(1);
CLRatn <= CTRL_REGout(2);






--PORT MAP MUX
mux:mux_2_to_1 port map (x1 => Q_out_s3, y1=> Q_out_s4, s=> SEL_MUX, m_out => Dout);

-- PORT MAP REGISTRI
reg_TX_Data: bus_reg port map (R=> Din, Q=> TX_out, RESET=> RESET,CLOCK=>CLOCK, Enable=> EN_DATATx);
reg_CTRL :bus_reg port map (R=> Din, Q=>CTRL_REGout,RESET=> RESET,CLOCK=>CLOCK, Enable=>EN_CTRL);
reg_Rx_Data: bus_reg port map (R=>  RX_in , Q=>Q_out_s3, RESET=> RESET,CLOCK=>CLOCK, Enable=>EN_DATARx);

end behav;

