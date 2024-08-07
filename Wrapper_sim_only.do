# simulation of wrapper only

vlib work
vlog SPI_Slave.V RAM.V SPI_Wrapper.V SPI_Wrapper_tb.V
vsim -voptargs=+acc work.SPI_Wrapper_tb
add wave *
run -all