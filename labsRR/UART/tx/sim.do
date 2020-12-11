project compileall
vsim work.tx_tb -t 10ns
add wave *
add wave -position insertpoint  \sim:/tx_tb/DUT/controlunit/present_state
add wave -position insertpoint  \sim:/tx_tb/DUT/controlunit/next_state
run 10000 ns;
