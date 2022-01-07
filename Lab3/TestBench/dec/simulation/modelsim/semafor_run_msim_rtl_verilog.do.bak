transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/FPGA/Lab2/HDL/IP {D:/FPGA/Lab2/HDL/IP/periodram.v}
vlog -sv -work work +incdir+D:/FPGA/Lab2/HDL {D:/FPGA/Lab2/HDL/dec.sv}

vlog -sv -work work +incdir+D:/FPGA/Lab2/TestBench/dec {D:/FPGA/Lab2/TestBench/dec/dec_tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  dec_tb

add wave *
view structure
view signals
run -all
