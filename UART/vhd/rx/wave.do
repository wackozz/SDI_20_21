project compileall
vsim -t ns work.rx_tb
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color White -height 25 /rx_tb/DUT/control_unit/clock
add wave -noupdate -height 25 /rx_tb/DUT/control_unit/reset
add wave -noupdate -color White -height 25 /rx_tb/DUT/control_unit/clr_start
add wave -noupdate -height 25 /rx_tb/DUT/control_unit/flag_error
add wave -noupdate -color White -height 25 /rx_tb/DUT/control_unit/clear_c_shift
add wave -noupdate -height 25 /rx_tb/DUT/control_unit/clear_c_rxfull
add wave -noupdate -color White -height 25 /rx_tb/DUT/control_unit/flag_rxfull
add wave -noupdate -height 25 /rx_tb/DUT/control_unit/rx_full
add wave -noupdate -color White -height 25 /rx_tb/DUT/control_unit/ld_en
add wave -noupdate -height 25 /rx_tb/DUT/control_unit/flag_shift_data
add wave -noupdate -color White -height 25 /rx_tb/DUT/control_unit/flag_shift_sample
add wave -noupdate -height 25 /rx_tb/DUT/control_unit/flag_68
add wave -noupdate -color White -height 25 /rx_tb/DUT/control_unit/sh_en_samples
add wave -noupdate -height 25 /rx_tb/DUT/control_unit/sh_en_data
add wave -noupdate -color White -height 25 /rx_tb/DUT/control_unit/start_en
add wave -noupdate -height 25 /rx_tb/DUT/control_unit/start
add wave -noupdate -color White -height 25 /rx_tb/DUT/control_unit/stop_en
add wave -noupdate -height 25 /rx_tb/DUT/control_unit/stop
add wave -noupdate -color White -height 25 /rx_tb/DUT/control_unit/count_en_sh
add wave -noupdate -height 25 /rx_tb/DUT/control_unit/count_en_rxfull
add wave -noupdate -color White -height 25 /rx_tb/DUT/control_unit/next_state
add wave -noupdate -height 25 -radix unsigned /rx_tb/DUT/datapath/q_c_shift
add wave -noupdate -color White -height 25 -radix unsigned /rx_tb/DUT/datapath/q_c_rxfull
add wave -noupdate -height 25 /rx_tb/DUT/datapath/p_out_samples
add wave -noupdate -color White -height 25 /rx_tb/DUT/datapath/vote
add wave -noupdate -height 25 /rx_tb/rxd
add wave -noupdate -color White -height 25 /rx_tb/Pout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 294
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
WaveRestoreZoom {0 ns} {123968 ns}
bookmark add wave bookmark0 {{0 ns} {1104 ns}} 0
run 200 us
