transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {/home/wackoz/github/SDI_20_21/labsRR/UART/rx/components/voter/voter_3bit.vhd}

