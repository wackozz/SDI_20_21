LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY testbench_voter IS
END testbench_voter;

ARCHITECTURE BEH OF testbench_voter IS
    SIGNAL vote : STD_LOGIC;
    SIGNAL d : STD_LOGIC_VECTOR(2 DOWNTO 0) := "001";

    COMPONENT voter_3bit IS
        PORT (
            d : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- input
    		vote : OUT STD_LOGIC 			--output
        );
    END COMPONENT;

BEGIN

    inst1 : voter_3bit PORT MAP(
        vote => vote,
        d => d
    );
END ARCHITECTURE;