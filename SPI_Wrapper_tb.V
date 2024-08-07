module SPI_Wrapper_tb();
	
	parameter IDLE = 3'b000;
	parameter CHK_CMD = 3'b001;
	parameter WRITE = 3'b010;
	parameter READ_ADD = 3'b011;
	parameter READ_DATA = 3'b100;

	reg MOSI,SS_n,clk,rst_n;
	wire MISO_dut;
	reg tmp;
	

	SPI_Wrapper #(.IDLE(IDLE),.CHK_CMD(CHK_CMD),.WRITE(WRITE),.READ_ADD(READ_ADD),.READ_DATA(READ_DATA)) DUT (MOSI,SS_n,clk,rst_n,MISO_dut);

	initial begin
		clk=0;
		forever 
		#1 clk=~clk;
	end

	integer i;
	initial begin 
		rst_n=0;
		SS_n=1;

		@(negedge clk);

		if (MISO_dut != 0) begin
			$display("Error - wrong output");
			$stop;
		end

		rst_n=1;
		SS_n=0;
        

		@(negedge clk);

		repeat(3)begin
			MOSI = 0;
			@(negedge clk);
		end

		repeat (8) begin
			MOSI=1;
			@(negedge clk);
		end

		SS_n=1;
		tmp=0;
		@(negedge clk);

		for (i = 0; i<10000 ; i=i+1 ) begin

			tmp=~tmp;
			SS_n = 0;
            @(negedge clk) ;

            repeat(2) begin
                    MOSI = 0;
                    @(negedge clk);
                end
            
            if (tmp) begin
                MOSI = 1;
                @(negedge clk);
            end
            else begin
                MOSI = 0;
                @(negedge clk);
            end

            repeat(8) begin
             	MOSI = $random;
                @(negedge clk);
                end

            SS_n = 1;
            @(negedge clk);

        end

        SS_n=0;
        

		@(negedge clk);

		repeat(2)begin
			MOSI = 1 ;
			@(negedge clk);
		end

		MOSI = 0;
		@(negedge clk);

		repeat (8) begin
			MOSI=$random;
			@(negedge clk);
		end

		SS_n=1;
		tmp=0;
		@(negedge clk);

		for (i = 0; i<10000 ; i=i+1 ) begin

			tmp=~tmp;
			SS_n = 0;
            @(negedge clk) ;

            repeat(2) begin
                    MOSI = 1;
                    @(negedge clk);
                end
            
            if (tmp) begin
                MOSI = 1;
                @(negedge clk);
            end
            else begin
                MOSI = 0;
                @(negedge clk);
            end

            repeat(8) begin
             	MOSI = $random;
                @(negedge clk);
                end

            if (tmp)begin
            	repeat(8)
            		@(negedge clk);
            end

            @(negedge clk);
            SS_n = 1;
            @(negedge clk);

        end		

		$display("output is %b",MISO_dut);

	$stop;
	end
endmodule

