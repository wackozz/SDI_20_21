library ieee;
use ieee.std_logic_1164.all;

entity ControlUnit_bus is
  port (RESET, CLOCK, CS_cu, R/Wn_cu                   : in  std_logic;
        ADD_cu                                         : in  std_logic_vector (2 downto 0);
        SEL_mux, ATN_cu                                : out std_logic
        RX_DATA, TX_DATA                               : out std_logic_vector (7 downto 0);
        RX_FULL, TX_EMPTY, CLRatn, error, TX_EN, RX_EN : out std_logic_vector(7 downto 0));
end ControlUnit_bus;


architecture behav of ControlUnit_bus is


  type stato is (IDLE, STATUS_state, DATA_RX_state, CTRL_state, DATA_TX_state, DONE);

  signal state : stato;


  process (CLOCK, state, RESET)
  begin
    if (RESET = '1') then
      state <= IDLE;

    elsif (Clk'event and Clk = '1') then
      case state is
        when IDLE =>
          if (CS = '1') then
            if (R/Wn = ’1’) then – LETTURA
                                 if(ADD = ’001) then

                                   state <= STATUS_state;

                                   ATN <= ’0’;
                                 end if

                                   when STATUS_state =>
                                 if (ADD = '010') then

                                   state <= DATA_RX_state;

                                   TX_EMPTY <= ”00000001”;
                                   RX_FULL  <= “00000000”;
                                   error    <= ”00000010”;
                                   ATN      <= ’1’;

                                 end if;

              when DATA_RX_state =>

                                 State <= DONE;

                                        --Dout_cu<=RX_DATA;

            end if;


          else
            if (R/Wn = ’0’) then –SCRITTURA
                                 if(ADD = ”011”) then

                                   State <= CTRL_state;

                                 end if;

              when CTRL_state =>

                                 if(ADD = ”000”) then
                                   State   <= DATA_TX_state;
                                   TX_EN   <= “00000001”;
                                   RX_EN   <= ”00000000”;
                                   CLR_atn <= “00000010”;
                                   ATN     <= ’0’;

                                 end if

                                   when DATA_TX_state =>
                                 State <= DONE;



              when DONE =>
                                 state <= IDLE;

            end if;



          end case;
      end if;
    end process;
    end behav;

