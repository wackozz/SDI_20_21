LIBRARY ieee; 
USE ieee.std_logic_1164.all; 
  
ENTITY ControlUnit_bus IS 
PORT        (  
                  RESET,CLOCK: IN STD_LOGIC;                      
                            CS_cu,R_Wn_cu: IN STD_LOGIC; 
                            EN_STATE: OUT STD_LOGIC_VECTOR (2 DOWNTO 0);									 
                              ADD_cu: IN STD_LOGIC_VECTOR (2 DOWNTO 0); 
                           SEL_mux_cu,ATN_cu,EN_regCTRL,EN_regDATARX,EN_regDATATX: OUT STD_LOGIC;                                                       
                             TX_ack_cu,EN_RX_cu,EN_TX_cu: OUT STD_LOGIC;
									  CLRatn_cu : BUFFER STD_LOGIC;
                               RX_FULL_cu,TX_EMPTY_cu,ERROR_cu,ATNack_cu: IN STD_LOGIC);
END ControlUnit_bus; 


ARCHITECTURE behav OF ControlUnit_bus IS


TYPE state_type IS (  IDLE,
                      WRITE_CTRL,
					  READ_STATUS,					  
					  WRITE_TXdata,                					  
					  READ_RXdata,
					  NEXT_STATE,
					  ATNack_STATE
					  );

SIGNAL present_state: state_type;

BEGIN
state_update: process(CLOCK,RESET)
BEGIN  
 IF (RESET = '0') THEN 
   present_state<=IDLE; 
    
         ELSIF (CLOCK'EVENT AND CLOCK = '1') THEN
                               
           CASE present_state IS 
                                                       
							WHEN IDLE => 
   						  IF ( CS_cu = '1') THEN 
  		                    IF (R_Wn_cu='0') THEN 
                               IF (ADD_cu(0) = '1') THEN
                                                            
													present_state <= WRITE_CTRL; 
                                ELSE
                                       present_state <= IDLE;										  
				                    END IF;
                            END IF;
                          END IF;         
                                                        
														
														
                      WHEN WRITE_CTRL =>
												  
                     IF ( CS_cu = '1') THEN
						     IF (R_Wn_cu = '1') THEN
						        IF(ADD_cu(0)= '0') THEN
													  
							         present_state <= READ_STATUS;
									
									ELSE
									   present_state <= IDLE;
						         END IF;
						     END IF;
                     END IF;

                       WHEN READ_STATUS =>                                                
                                            
								  IF (TX_EMPTY_cu = '1'AND CS_cu= '1' AND R_Wn_cu = '0' 
								           AND ADD_cu (0) = '0') THEN
                                 present_state <= WRITE_TXdata;

                          END IF;
								  
                          IF (RX_FULL_cu = '1'AND CS_cu = '1' 
								          AND R_Wn_cu = '1' AND ADD_cu(0)= '1') THEN
                                 present_state<= READ_RXdata;
								  END IF;


                      
													
						      WHEN WRITE_TXdata =>
						      present_state <= NEXT_STATE;
																										
													
						      WHEN READ_RXdata =>
						      present_state <= NEXT_STATE;
								
								WHEN NEXT_STATE =>
								IF (CLRatn_cu = '1') THEN -- ATN DISATTIVATO INUTILE MANDARE ATNack
                           present_state <= IDLE;
								ELSE
								   present_state <= ATNack_STATE; -- VADO NELLO STATO DI ATTESA DELL'ATNack
								END IF;
								
								WHEN ATNack_STATE =>
								IF(ATNack_cu = '1') THEN
								  present_state <= IDLE;
								 END IF;
								 IF ( TX_EMPTY_cu = '1') THEN --controllo che nel frattempo non siano arrivati
								                                  -- nuovi segnali senza che ci sia risposta dall'esterno
								  present_state <= WRITE_TXdata;
								 ELSE 
								  present_state <= IDLE;
								END IF;
								 
								 IF ( RX_FULL_cu = '1') THEN
								  present_state <= READ_RXdata;
								ELSE 
								  present_state <= IDLE;
								END IF;
									
						      WHEN OTHERS =>
						      present_state <= IDLE;
               END CASE;   
	   END IF;
END PROCESS; 


FSM_cu: process(present_state)
BEGIN



  --default values
 
   SEL_mux_cu <= '0';
	EN_regCTRL <= '0';
	EN_regDATARX <= '0';
	EN_regDATATX <= '0';
	TX_ack_cu  <= '0';
	EN_STATE(0) <= '0';
	EN_STATE(1) <= '0';
	EN_STATE(2) <= '1';
	ATN_cu <= '0';
    
CASE present_state IS
                       WHEN IDLE =>
							  IF(ERROR_cu ='1') THEN
							  EN_STATE(2) <= '0';
							  END IF;
							  
							  WHEN WRITE_CTRL =>
							  EN_regCTRL <= '1';
							  EN_STATE(2) <= '1';
							  
							  WHEN READ_STATUS => 
							  EN_STATE(0) <= '1';
							  EN_STATE(1) <= '1';
							  EN_STATE(2) <= '1';
							  Tx_ack_cu <= '0';
							  SEL_MUX_CU <='1';
							
							  							 
							  WHEN READ_RXdata => -- LEGGO RX_DATA
                       SEL_mux_cu <= '1'; 
							  EN_regDATARX <= '1';
							  ATN_cu <= '1';       --MANDO ATN
							  EN_STATE(2)<='1';
							  TX_ack_cu  <= '0';
							  
							  WHEN WRITE_TXdata => -- SCRIVO SU TX_DATA
							  EN_regDATATX <= '1';
							  ATN_cu <= '1';       --MANDO ATN
							  EN_STATE(2) <= '1';
							  TX_ack_cu  <= '1';
							  
							  WHEN NEXT_STATE =>
							  IF(CLRatn_cu = '1') THEN
							  ATN_cu <= '0';
							  EN_STATE(2) <= '1';
							  END IF;
							  
							  WHEN ATNack_STATE =>
							  IF(ATNack_cu = '1') THEN
							  ATN_cu <= '0';
							  ELSE
							  EN_STATE(0) <= '1';
							  EN_STATE(1) <= '1';
							  EN_STATE (2) <= '1';
							  END IF;
							  
							  
							 
							 
END CASE;							
END PROCESS;							 

END behav; 
