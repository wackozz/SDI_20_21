LIBRARY ieee; 
USE ieee.std_logic_1164.all; 
  
ENTITY ControlUnit_bus IS 
PORT (RESET,CLOCK,CS_cu,R/Wn_cu,ATNack_cu: IN STD_LOGIC; 
                       
                              ADD_cu: IN STD_LOGIC_VECTOR (2 DOWNTO 0); 
                               SEL_mux,ATN_cu,EN_regSTATUS,EN_regCTRL,EN_regDATARX,EN_regDATATX: OUT STD_LOGIC                             
                               RX_DATA,TX_DATA : OUT STD_LOGIC_VECTOR (7 DOWNTO 0); 
                              RX_FULL,TX_EMPTY,CLRatn,ERROR,TX_EN,RX_EN: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)); 
END ControlUnit_bus; 


ARCHITECTURE behav OF ControlUnit_bus IS


TYPE state_type IS (IDLE,STATUS_state,ATNack_state,DATA_RX_state,CTRL_state,DATA_TX_state,DONE);

SIGNAL present_state: state_type;


state_update: process(CLOCK,RESET)
BEGIN  
 IF (RESET = '0') THEN 
   state<=IDLE; 
    
         ELSIF (Clk'EVENT AND Clk = '1') THEN
                               
							   CASE state IS 
                               WHEN IDLE => 
                                
							IF ( CS_cu = '1') THEN 
                                
								IF (R/Wn_cu='1') THEN -- LETTURA
                               
       							   IF(ADD_cu="001") THEN  --INDIRIZZO REGISTRO STATI

                                     state <= STATUS_state; 
                                               
                                   END IF 
                                
								     WHEN STATUS_state=>  
                                
								      IF (ADD_cu = "010") THEN 
                             
                                          state<= ATNack_state;										  										 
                                             
                                 
                                    END IF; 
									 
									 WHEN ATNack_state =>
									 state<= DATA_RX_state;
                                 
                                     WHEN DATA_RX_state => 
                
                                              State<=DONE;
        
                                         
							         END IF;
                                              

                                 ELSE IF (R/Wn_cu='0') THEN --SCRITTURA
                                             IF(ADD_cu="011") THEN
                                           
										   State<= CTRL_state;
                                     
									 END IF;

                                    WHEN CTRL_state => 
                                               
								     IF(ADD_cu="000") THEN
                                               State<= DATA_TX_state;
                                              

                                      END IF
                                              
                                    WHEN DATA_TX_state  => 
                                         State<=DONE;
                                              
                                                
                                                
                                    WHEN DONE => 
                                     state<= IDLE; 
                                                               
                                END IF; 
                                                
                                              
                                                
                      END CASE;           
                 END IF; 
END PROCESS; 

FSM_cu: process(present_state)
BEGIN


CASE present_state IS

                              WHEN IDLE =>
							  RESET<='1';
							  ATN<='0';
							  
							  
							  WHEN STATUS_state =>
							   TX_EMPTY<="00000001";
                               RX_FULL<= "00000000";
                               ERROR<= "00000010";
                               ATN<= '1';
							   EN_regSTATUS <= '1';
							   
							 WHEN ATNack_state =>
							 ATN<='1';
							 
							 WHEN DATA_RX_state =>
							  EN_regDATARX <= '1';
							 
							 WHEN CTRL_state =>
							 EN_regCTRL <= '1';
							 TX_EN<= "00000001"; 
                             RX_EN<="00000000";
                             CLR_atn <= "00000010";
                             ATN<= '0';
							 
							 WHEN DATA_TX_state =>
							 EN_regDATATX <= '1';
							 
							 WHEN DONE =>
							 RESET<= '1';
END CASE;
END PROCESS;							 

END behav; 

