module SPI_Slave (MOSI,SS_n,clk,rst_n,tx_data,tx_valid,MISO,rx_data,rx_valid);

	input MOSI,clk,rst_n,SS_n,tx_valid;
	input [7:0] tx_data;

	output reg MISO,rx_valid;
	output reg [9:0] rx_data;

	parameter IDLE = 3'b000;
	parameter CHK_CMD = 3'b001;
	parameter WRITE = 3'b010;
	parameter READ_ADD = 3'b011;
	parameter READ_DATA = 3'b100;


	reg [3:0] counter;
	reg rd_mode;
	reg [9:0] RISO;

	(* fsm_encoding = "sequential" *)
	reg [2:0] cs,ns;

	always @(posedge clk) begin
		if (!rst_n)begin
			cs<=IDLE;
		end
		else
			cs<=ns;
	end

	always @(*) begin
		case(cs)
			IDLE:if (SS_n)
					ns=IDLE;
				 else
				  	ns=CHK_CMD;
			CHK_CMD:if (SS_n)
						ns=IDLE;
					else if (SS_n == 0 && MOSI == 0)
						ns=WRITE;
					else if (SS_n == 0 && MOSI == 1 && rd_mode == 0)
						ns=READ_ADD;
					else if (SS_n == 0 && MOSI == 1 && rd_mode == 1)
						ns=READ_DATA;
			WRITE:if(SS_n)
					ns=IDLE;
				  else  
				  	ns=WRITE;
			READ_ADD:if(SS_n)
						ns=IDLE;
					 else 
					 	ns=READ_ADD;
			READ_DATA:if(SS_n)
						ns=IDLE;
					  else 
					  	ns=READ_DATA;
		endcase
	end


	always @(posedge clk) begin
		case (cs)
        IDLE: begin
        	counter <=0;
        	rx_valid<=0;
            MISO <= 0;
            rx_data <= 0;
            RISO <= 0;

        	end
		WRITE:begin
			if (counter != 10)begin
				counter<=counter+1;
				RISO[9-counter]<=MOSI;
			end
			else if (counter == 10)begin
					rx_data<=RISO;
					rx_valid<=1;
					counter<=0;
					rd_mode<=0;		  	
			end
			end
		READ_ADD:begin
			if (counter != 10)begin
				counter<=counter+1;
				RISO[9-counter]<=MOSI;
			end
			else if (counter == 10)begin
					rx_data<=RISO;
					rx_valid<=1;
					counter<=0;
					rd_mode<=1;			  	
			end	
			end
		READ_DATA: begin
			if (tx_valid == 0 && counter < 10)begin
				counter<=counter+1;
				RISO[9-counter]<=MOSI;
			end
			else if (tx_valid == 0 && counter == 10)begin
					rx_data<=RISO;
					rx_valid<=1;
					counter<=0;		  	
			end
			else if (tx_valid==1 && counter < 8 ) begin
					counter<=counter+1;
					MISO<=tx_data[7-counter];
			end
			else if (counter >= 8 )begin
					counter<=0;
					rd_mode<=0;	
			end
			end
		endcase
	end

endmodule




