LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY testbench_sr IS
END testbench_sr;

ARCHITECTURE BEH OF testbench_sr IS
    SIGNAL clock = NOT(clock) AFTER 10ns;
    SIGNAL data_in = "0100010";
    COMPONENT shift_register_8bit IS
        PORT (
            clock : IN STD_LOGIC; --clock
            --controls
            sh_en : IN STD_LOGIC; --shift enable
            ld_en : IN STD_LOGIC; --load enable
            --input
            s_in : IN STD_LOGIC; -- serial in
            s_out : OUT STD_LOGIC; -- serial out
            --output
            p_in : STD_LOGIC_VECTOR(7 DOWNTO 0); -- parallel in
            p_out : STD_LOGIC_VECTOR(7 DOWNTO 0) -- parallel out
        );
    END COMPONENT;
BEGIN
END ARCHITECTURE;