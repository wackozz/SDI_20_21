library ieee;
use ieee.std_logic_1164.all;

entity ControlUnit_bus is
  port (RESET, CLOCK, CS_cu, R_Wn_cu, ATNack_cu : in std_logic;

        ADD_cu                                                                : in  std_logic_vector (2 downto 0);
        SEL_mux, ATN_cu, EN_regSTATUS, EN_regCTRL, EN_regDATARX, EN_regDATATX : out std_logic;
        TX_DATA                                                               : out std_logic_vector (7 downto 0);
        RX_DATA                                                               : in  std_logic_vector (7 downto 0);
        CLRatn, TX_EN, RX_EN                                                  : out std_logic_vector(7 downto 0);
        RX_FULL, TX_EMPTY, error : in std_logic_vector(7 downto 0)
        );
end ControlUnit_bus;


architecture behav of ControlUnit_bus is


  type state_type is (IDLE, STATUS_state, ATNack_state, DATA_RX_state, CTRL_state, DATA_TX_state, DONE);

  signal present_state : state_type;

begin
  state_update : process(CLOCK, RESET)
  begin
    if (RESET = '0') then
      present_state <= IDLE;

    elsif (CLOCK'event and CLOCK = '1') then

      case present_state is
        when IDLE =>

          if (CS_cu = '1') then

            if (R_Wn_cu = '1') then     -- LETTURA

              if(ADD_cu = "001") then   --INDIRIZZO REGISTRO STATI

                present_state <= STATUS_state;

              end if;

              when STATUS_state =>

              if (ADD_cu = "010") then

                present_state <= ATNack_state;


              end if;

              when ATNack_state =>
              present_state <= DATA_RX_state;

              when DATA_RX_state =>

              present_state <= DONE;


            end if;


          else
            if (R_Wn_cu = '0') then     --SCRITTURA
              if(ADD_cu = "011") then

                present_state <= CTRL_state;

              end if;

              when CTRL_state =>

              if(ADD_cu = "000") then
                present_state <= DATA_TX_state;


              end if;

              when DATA_TX_state =>
              present_state <= DONE;



              when DONE =>
              present_state <= IDLE;

            end if;



          end case;
      end if;
    end process;

      FSM_cu : process(present_state)
      begin


        case present_state is

          when IDLE =>
            RESET <= '1';
            ATN   <= '0';


          when STATUS_state =>
            TX_EMPTY     <= "00000001";
            RX_FULL      <= "00000000";
            error        <= "00000010";
            ATN          <= '1';
            EN_regSTATUS <= '1';

          when ATNack_state =>
            ATN <= '1';

          when DATA_RX_state =>
            EN_regDATARX <= '1';

          when CTRL_state =>
            EN_regCTRL <= '1';
            TX_EN      <= "00000001";
            RX_EN      <= "00000000";
            CLR_atn    <= "00000010";
            ATN        <= '0';

          when DATA_TX_state =>
            EN_regDATATX <= '1';

          when DONE =>
            RESET <= '1';
        end case;
      end process;

    end behav;
