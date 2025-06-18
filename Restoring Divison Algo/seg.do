vlog -sv SevenSeg/*.sv     
     
vsim -voptargs=+acc sevenSegController_tb

add wave sim:/sevenSegController_tb/dut/*

run -all
