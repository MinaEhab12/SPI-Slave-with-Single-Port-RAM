module SPI_Wrapper (MOSI,SS_n,clk,rst_n,MISO);


	parameter IDLE = 3'b000;
	parameter CHK_CMD = 3'b001;
	parameter WRITE = 3'b010;
	parameter READ_ADD = 3'b011;
	parameter READ_DATA = 3'b100;

	input clk,rst_n,SS_n,MOSI;

	output MISO;

	wire [7:0] dout;
	wire tx_valid,rx_valid;
	wire [9:0] rx_data;

	SPI_Slave #(.IDLE(IDLE),.CHK_CMD(CHK_CMD),.WRITE(WRITE),.READ_ADD(READ_ADD),.READ_DATA(READ_DATA)) SPI (MOSI,SS_n,clk,rst_n,dout,tx_valid,MISO,rx_data,rx_valid);
	RAM_Sync_Single_port RAM (rx_data,rx_valid,clk,rst_n,dout,tx_valid);

endmodule