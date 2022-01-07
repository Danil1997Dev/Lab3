onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {clock and reset}
add wave -noupdate /tb/dut/dec_test_inst_clk_bfm_clk_clk
add wave -noupdate /tb/dut/dec_test_inst_reset_bfm_reset_reset
add wave -noupdate -divider {master bfm}
add wave -noupdate -radix hexadecimal /tb/dut/dec_test_inst/master/avm_address
add wave -noupdate -radix hexadecimal /tb/dut/dec_test_inst/master/avm_burstcount
add wave -noupdate -radix hexadecimal /tb/dut/dec_test_inst/master/avm_waitrequest
add wave -noupdate -radix hexadecimal /tb/dut/dec_test_inst/master/avm_write
add wave -noupdate -radix hexadecimal /tb/dut/dec_test_inst/master/avm_writedata
add wave -noupdate -radix hexadecimal /tb/dut/dec_test_inst/master/avm_byteenable
add wave -noupdate -radix hexadecimal /tb/dut/dec_test_inst/master/avm_read
add wave -noupdate -radix hexadecimal /tb/dut/dec_test_inst/master/avm_readdatavalid
add wave -noupdate -radix hexadecimal /tb/dut/dec_test_inst/master/avm_readdata
add wave -noupdate -divider {sem}
add wave -noupdate -radix hexadecimal /tb/dut/dec_test_inst/sem/ctl_wr
add wave -noupdate -radix hexadecimal /tb/dut/dec_test_inst/sem/ctl_rd
add wave -noupdate -radix hexadecimal /tb/dut/dec_test_inst/sem/ctl_addr
add wave -noupdate -radix hexadecimal /tb/dut/dec_test_inst/sem/ctl_wrdata
add wave -noupdate -radix hexadecimal /tb/dut/dec_test_inst/sem/ctl_rddata
add wave -noupdate -radix hexadecimal /tb/dut/dec_test_inst/sem/ram_wr
add wave -noupdate -radix hexadecimal /tb/dut/dec_test_inst/sem/ram_addr
add wave -noupdate -radix hexadecimal /tb/dut/dec_test_inst/sem/ram_wrdata
add wave -noupdate -radix hexadecimal /tb/dut/dec_test_inst/sem/train
add wave -noupdate -radix hexadecimal /tb/dut/dec_test_inst/sem/red
add wave -noupdate -radix hexadecimal /tb/dut/dec_test_inst/sem/yellow
add wave -noupdate -radix hexadecimal /tb/dut/dec_test_inst/sem/green
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {14950 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 300
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 2
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
WaveRestoreZoom {0 ns} {15220 ns}

