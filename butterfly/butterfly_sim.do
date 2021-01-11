project compileall
vsim work.butterfly_tb(str) -t ns
onerror {resume}
radix define fixed#19#decimal -fixed -fraction 19 -base signed -precision 1
radix define fixed#19#binary#signed -fixed -fraction 19 -signed -base binary -precision 6
radix define fixed#19#decimal#signed -fixed -fraction 19 -signed -base signed -precision 6
radix define fixed#38#decimal#signed -fixed -fraction 38 -signed -base signed -precision 6
radix define fixed#39#decimal -fixed -fraction 39 -base signed -precision 6
radix define fixed#60#decimal -fixed -fraction 60 -base signed -precision 6
radix define fixed#42#decimal -fixed -fraction 42 -base signed -precision 6
radix define fixed#40#decimal -fixed -fraction 40 -base signed -precision 6
radix define fixed#41#decimal -fixed -fraction 41 -base signed -precision 6
radix define fixed#41#decimal#signed -fixed -fraction 41 -signed -base signed -precision 6
radix define fixed#40#decimal#signed -fixed -fraction 40 -signed -base signed -precision 6
radix define fixed#39#decimal#signed -fixed -fraction 39 -signed -base signed -precision 6
radix define fixed#38#decimal -fixed -fraction 38 -base signed -precision 6
radix define float#39#decimal -float -fraction 39 -base signed -precision 6
quietly WaveActivateNextPane {} 0
add wave -noupdate /butterfly_tb/DUT/controlunit_butterfly_1/out_uAR
add wave -noupdate /butterfly_tb/DUT/controlunit_butterfly_1/out_uIR
add wave -noupdate /butterfly_tb/clock
add wave -noupdate -color {Medium Spring Green} /butterfly_tb/reset
add wave -noupdate -color {Medium Spring Green} /butterfly_tb/start
add wave -noupdate -color {Medium Spring Green} /butterfly_tb/done
add wave -noupdate -color {Medium Spring Green} /butterfly_tb/fullspeed
add wave -noupdate -color White -height 30 -radix fixed#19#decimal#signed /butterfly_tb/DUT/butterfly_dp_1/Wr
add wave -noupdate -radix fixed#19#decimal#signed /butterfly_tb/DUT/butterfly_dp_1/Wr_Q
add wave -noupdate -color White -height 30 /butterfly_tb/DUT/butterfly_dp_1/Wj
add wave -noupdate -color White -height 30 /butterfly_tb/DUT/butterfly_dp_1/Aj_in
add wave -noupdate -color White -height 30 /butterfly_tb/DUT/butterfly_dp_1/Ar_in
add wave -noupdate -color White -height 30 /butterfly_tb/DUT/butterfly_dp_1/Bj_in
add wave -noupdate -color White -height 30 /butterfly_tb/DUT/butterfly_dp_1/Br_in
add wave -noupdate -color Gold -height 30 -radix fixed#19#decimal#signed /butterfly_tb/Ar_out
add wave -noupdate -color Gold -height 30 -radix fixed#19#decimal#signed /butterfly_tb/Aj_out
add wave -noupdate -color Gold -height 30 -radix fixed#19#decimal#signed /butterfly_tb/Br_out
add wave -noupdate -color Gold -height 30 -radix fixed#19#decimal#signed /butterfly_tb/Bj_out
add wave -noupdate /butterfly_tb/DUT/butterfly_dp_1/sh_mpy
add wave -noupdate /butterfly_tb/DUT/butterfly_dp_1/s_mux_B_mpy
add wave -noupdate /butterfly_tb/DUT/butterfly_dp_1/mpy_in_B
add wave -noupdate /butterfly_tb/DUT/butterfly_dp_1/s_mux_A_mpy
add wave -noupdate -radix fixed#19#decimal#signed /butterfly_tb/DUT/butterfly_dp_1/mpy_in_A
add wave -noupdate -radix decimal /butterfly_tb/DUT/butterfly_dp_1/mpy_out
add wave -noupdate -radix decimal /butterfly_tb/DUT/butterfly_dp_1/mpy_reg_Q
add wave -noupdate -radix decimal /butterfly_tb/DUT/butterfly_dp_1/add_in_B_1
add wave -noupdate /butterfly_tb/DUT/butterfly_dp_1/add_sub_1
add wave -noupdate -radix decimal /butterfly_tb/DUT/butterfly_dp_1/add_out_1
add wave -noupdate /butterfly_tb/DUT/butterfly_dp_1/s_mux_B_add_1
add wave -noupdate -radix decimal /butterfly_tb/DUT/butterfly_dp_1/add_reg_1_Q
add wave -noupdate -radix decimal /butterfly_tb/DUT/butterfly_dp_1/add_in_B_2
add wave -noupdate /butterfly_tb/DUT/butterfly_dp_1/add_sub_2
add wave -noupdate /butterfly_tb/DUT/butterfly_dp_1/s_mux_B_add_2
add wave -noupdate /butterfly_tb/DUT/butterfly_dp_1/add_in_A
add wave -noupdate -radix decimal /butterfly_tb/DUT/butterfly_dp_1/add_out_2
add wave -noupdate -radix decimal /butterfly_tb/DUT/butterfly_dp_1/add_reg_2_Q
add wave -noupdate /butterfly_tb/DUT/butterfly_dp_1/s_mux_round_in
add wave -noupdate /butterfly_tb/DUT/butterfly_dp_1/Wr_enable
add wave -noupdate /butterfly_tb/DUT/butterfly_dp_1/Wj_enable
add wave -noupdate -radix decimal /butterfly_tb/DUT/butterfly_dp_1/Wj_Q
add wave -noupdate /butterfly_tb/DUT/butterfly_dp_1/Br_enable
add wave -noupdate -radix decimal /butterfly_tb/DUT/butterfly_dp_1/Br_Q
add wave -noupdate /butterfly_tb/DUT/butterfly_dp_1/Bj_enable
add wave -noupdate -radix decimal /butterfly_tb/DUT/butterfly_dp_1/Bj_Q
add wave -noupdate /butterfly_tb/DUT/butterfly_dp_1/Ar_enable
add wave -noupdate -radix decimal /butterfly_tb/DUT/butterfly_dp_1/Ar_Q
add wave -noupdate /butterfly_tb/DUT/butterfly_dp_1/Aj_enable
add wave -noupdate -radix decimal /butterfly_tb/DUT/butterfly_dp_1/Aj_Q
add wave -noupdate /butterfly_tb/DUT/butterfly_dp_1/Ar_out_enable
add wave -noupdate /butterfly_tb/DUT/butterfly_dp_1/Aj_out_enable
add wave -noupdate /butterfly_tb/DUT/butterfly_dp_1/Br_out_enable
add wave -noupdate /butterfly_tb/DUT/butterfly_dp_1/Bj_out_enable
add wave -noupdate /butterfly_tb/DUT/butterfly_dp_1/add_reg_1_enable
add wave -noupdate /butterfly_tb/DUT/butterfly_dp_1/add_reg_2_enable
add wave -noupdate /butterfly_tb/DUT/butterfly_dp_1/mpy_reg_enable
add wave -noupdate -radix decimal /butterfly_tb/DUT/butterfly_dp_1/round_in
add wave -noupdate -radix fixed#19#decimal#signed /butterfly_tb/DUT/butterfly_dp_1/round_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {131 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 435
configure wave -valuecolwidth 129
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
WaveRestoreZoom {0 ns} {850 ns}
bookmark add wave bookmark0 {{0 ns} {1104 ns}} 0
run 200 us
