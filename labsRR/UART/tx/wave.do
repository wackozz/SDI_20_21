onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color {Cornflower Blue} -height 30 /tx_tb/clock
add wave -noupdate -height 30 /tx_tb/reset
add wave -noupdate -height 30 /tx_tb/p_in
add wave -noupdate -color Cyan -height 30 /tx_tb/TxD
add wave -noupdate -height 30 /tx_tb/tx_empty_ack
add wave -noupdate -height 30 /tx_tb/Clk
add wave -noupdate -height 30 /tx_tb/DUT/datapath/force_one
add wave -noupdate -height 30 /tx_tb/DUT/datapath/force_zero
add wave -noupdate -height 30 /tx_tb/DUT/datapath/tx_empty_ack
add wave -noupdate -height 30 /tx_tb/DUT/datapath/count_en
add wave -noupdate -color Gold -height 30 /tx_tb/DUT/datapath/tx_empty
add wave -noupdate -color Gold -height 30 /tx_tb/DUT/datapath/term_count
add wave -noupdate -height 30 /tx_tb/DUT/datapath/p_in
add wave -noupdate -height 30 /tx_tb/DUT/datapath/p_out
add wave -noupdate -height 30 /tx_tb/DUT/datapath/ld_en
add wave -noupdate -height 30 /tx_tb/DUT/datapath/sh_en
add wave -noupdate -height 30 /tx_tb/DUT/datapath/TxD
add wave -noupdate -height 30 -radix unsigned /tx_tb/DUT/datapath/q_txempty
add wave -noupdate -height 30 -radix unsigned /tx_tb/DUT/datapath/q_c_shift
add wave -noupdate -height 30 /tx_tb/DUT/datapath/s_in
add wave -noupdate -height 30 /tx_tb/DUT/datapath/s_out
add wave -noupdate -height 30 /tx_tb/DUT/controlunit/present_state
add wave -noupdate -height 30 /tx_tb/DUT/controlunit/next_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {20010 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 371
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {19540 ns} {20400 ns}
