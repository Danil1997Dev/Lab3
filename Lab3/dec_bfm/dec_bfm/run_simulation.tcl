# setup variables for simulation script
set system_name      dec_test
set QSYS_SIMDIR      $system_name/testbench
set TOP_LEVEL_NAME   tb

# setup simulation commands for module compilation 
source $QSYS_SIMDIR/mentor/msim_setup.tcl

# compile system
dev_com
com

# compile testbench top and test program not included in msim_setup.tcl
vlog -sv test_program.sv -L altera_common_sv_packages
vlog -sv tb.sv

# load and run simulation
elab_debug
do wave.do
run 50000ns

# alias to re-compile changes made to test program, load and run simulation
alias rerun {
   vlog -sv test_program.sv -L altera_common_sv_packages
   elab_debug
   do wave.do
   run 50000ns
}

