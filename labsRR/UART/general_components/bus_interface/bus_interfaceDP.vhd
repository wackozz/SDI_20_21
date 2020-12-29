LIBRARY ieee; 
USE ieee.std_logic_1164.all;

ENTITY bus_interfaceDP IS
PORT(Dout: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
TX_out: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
RX_in,Din:IN STD_LOGIC_VECTOR (7 DOWNTO 0);
ADD: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
R_Wn,CS,ATNack,RESET,CLOCK: IN STD_LOGIC;
ATN,TX_ACK: OUT STD_LOGIC;
RX_ENABLE,TX_ENABLE,CLRatn, SEL_MUX: BUFFER STD_LOGIC;
FF_IN: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
ENABLE_FF: BUFFER STD_LOGIC_VECTOR (2 DOWNTO 0);
FF_OUT : OUT STD_LOGIC_VECTOR ( 2 DOWNTO 0));
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


component ControlUnit_bus IS 
PORT        (                 RESET,CLOCK: IN STD_LOGIC;                      
                            CS_cu,R_Wn_cu: IN STD_LOGIC; 
                            EN_STATE: OUT STD_LOGIC_VECTOR (2 DOWNTO 0);									 
                              ADD_cu: IN STD_LOGIC_VECTOR (2 DOWNTO 0); 
                           SEL_mux_cu,ATN_cu,EN_regCTRL,EN_regDATARX,EN_regDATATX: OUT STD_LOGIC;                                                       
                             TX_ack_cu,EN_RX_cu,EN_TX_cu: OUT STD_LOGIC;
									  CLRatn_cu : BUFFER STD_LOGIC;
                               RX_FULL_cu,TX_EMPTY_cu,ERROR_cu,ATNack_cu: IN STD_LOGIC);
END component;


SIGNAL 	SEL_mux_s ,EN_DATARx,EN_DATATx,EN_CTRL,ERROR,TX_EMPTY,RX_FULL:STD_LOGIC;
SIGNAL  Q_out_s3,Q_out_s4, CTRL_REGout:STD_LOGIC_vector (7 downto 0);
SIGNAL  RX_ENABLE_S,TX_ENABLE_S,CLRatn_S:STD_LOGIC;



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
		
Q_out_s4 <= "00000" & FF_IN(2) & FF_IN(1) & FF_IN(0);-- ingresso multiplexer

ERROR <= FF_IN(2);
TX_EMPTY <= FF_IN(1);
RX_FULL <= FF_IN (0);

-- REGISTRO CTRL
		--bit 0 ENABLE_RX
		--bit 1 ENABLE_TX
		--bit 2 CLRatn

RX_ENABLE_S <= RX_ENABLE;
TX_ENABLE_S <= TX_ENABLE;
CLRatn_S <= CLRatn;		
		
RX_ENABLE <= CTRL_REGout(0);
TX_ENABLE <= CTRL_REGout(1);
CLRatn <= CTRL_REGout (2);







--PORT MAP MUX
mux:mux_2_to_1 port map (x1 => Q_out_s3, y1=> Q_out_s4, s=> SEL_mux_s, m_out => Dout);

-- PORT MAP REGISTRI
reg_TX_Data: bus_reg port map (R=> Din, Q=> TX_out, RESET=> RESET,CLOCK=>CLOCK, Enable=> EN_DATATx);
reg_CTRL :bus_reg port map (R=> Din, Q=>CTRL_REGout,RESET=> RESET,CLOCK=>CLOCK, Enable=>EN_CTRL);
reg_Rx_Data: bus_reg port map (R=>  RX_in , Q=>Q_out_s3, RESET=> RESET,CLOCK=>CLOCK, Enable=>EN_DATARx);



--PORT MAP CONTROL UNIT
control: CONTROLUnit_bus port map (ADD_cu => ADD,CS_cu => CS, R_Wn_cu=> R_Wn,SEL_mux_cu => SEL_mux_s, RESET=> RESET,CLOCK=>CLOCK,
				   ATN_cu=> ATN, RX_FULL_cu=> RX_FULL, TX_EMPTY_cu =>TX_EMPTY, ERROR_cu=> ERROR,									                                     
					EN_regCTRL=>EN_CTRL, EN_regDATARX=> EN_DATARx, EN_RX_cu => RX_ENABLE_S,EN_TX_cu => TX_ENABLE_S,
					CLRatn_cu => CLRatn_S,EN_STATE => ENABLE_FF, ATNack_cu => ATNack,
	                             EN_regDATATX=> EN_DATATx,TX_ack_cu=> TX_ACK );

END behav;	
