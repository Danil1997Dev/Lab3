set path d:/intelFPGA/18.1/Lab2/Lab2
transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+ $path/HDL/IP/periodram.v 
vlog -sv -work work +incdir+ $path/HDL/dec.sv 

vlog -sv -work work +incdir+ $path/TestBench/dec/dec_tb.sv 

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  dec_tb

add wave *
add wave -position insertpoint sim:/dec_tb/my_sem/b2v_inst3/*
add wave -position insertpoint sim:/dec_tb/my_sem/*
view structure
view signals
run -all
