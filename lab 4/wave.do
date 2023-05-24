vlib work
vlog part3.v
vsim part3
log {/*}
add wave {/*}
force clock 1
force reset 0
force ParallelLoadn 0
force RotateRight 0
force ASRight 0
Force Data_IN 0

run 10ns

force reset 1
force reset 0
force ASRight 1
force RotateRight 0
force ParallelLoadn 1
force Data_IN 11111111

run 10ns

force ASRight 1
force RotateRight 1
force ParallelLoadn 1
force Data_IN 11011011

run 10ns

force ASRight 1
force RotateRight 0
force ParallelLoadn 0
force Data_IN 00110101

run 10ns