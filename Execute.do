# simulation of wrapper with all its internal signals

vlib work
vlog SPI_Slave.V RAM.V SPI_Wrapper.V SPI_Wrapper_tb.V
vsim -voptargs=+acc work.SPI_Wrapper_tb
add wave -r /SPI_Wrapper_tb/DUT/SPI/*
add wave -r /SPI_Wrapper_tb/DUT/RAM/*
add wave *
run -all