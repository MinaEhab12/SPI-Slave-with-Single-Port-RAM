module RAM_Sync_Single_port (din,rx_valid,clk,rst_n,dout,tx_valid);
	

	parameter MEM_DEPTH = 256;
	parameter ADDR_SIZE = 8;

	input [9:0] din;
	input clk,rst_n,rx_valid;

	output reg [ADDR_SIZE-1:0] dout;
	output reg tx_valid;

	reg [ADDR_SIZE-1:0] mem [MEM_DEPTH-1:0];
	reg [ADDR_SIZE-1:0] addr_rd,addr_wr;

	always @(posedge clk) begin
		if (!rst_n) begin
			dout<=0;
			tx_valid<=0;
		end
		else 
			case(din[9:8])

			2'b00: if(rx_valid)begin 
						addr_wr<=din[7:0];
						tx_valid<=0;
				   end

			2'b01: if(rx_valid)begin  
						mem[addr_wr]<=din[7:0];
						tx_valid<=0;
				   end

			2'b10: if(rx_valid)begin 
					addr_rd<=din[7:0];
					tx_valid<=0;
				   end 

			2'b11: begin
					dout<=mem[addr_rd];
				    tx_valid<=1;
				   end
			endcase
	end
endmodule
