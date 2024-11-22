/*module MOSI_input (MOSI,clk,rst_n,SS_n,,rx_valid,rx_data);
	
	input wire MOSI,clk,rst_n,SS_n,tx_valid;
	input [7:0] Ram_out;

	output reg [9:0] rx_data;
	output reg rx_valid;
	reg[3:0] current_state,next_state
	
	parameter IDLE		= 	3'b000;
	parameter CHECk_CMD	= 	3'b001;
	parameter WRITE_ADD	= 	3'b010;
	parameter WRITE_DATA=	3'b011;
	parameter READ_ADD	= 	3'b100;
	parameter READ_DATA	= 	3'b101;


	wire valid;
	reg rst_stp;
	wire [9:0] stp_out;

	always @(posedge clk or negedge rst_n) begin
		if (! rst_n) begin
			
			rst_stp<=0;
			rx_data<=0;

		end
		else if (!SS_n) begin
			if (!MOSI)
				rst_stp<=1;
		end
		else if (SS_n)
			rst_stp<=0;
	
		if (valid)
		begin
		rst_stp<=0;
		rx_data<=stp_out;	
		end

	end

	always@(clk)begin
		if (valid)	begin
			if (stp_out[9])
			rx_valid<=0;
			else rx_valid<=1; 
			
		end
	end

	

	SerialToParallel U_Stp(.clk(clk),.serial_in(MOSI),.parallel_out(stp_out),.valid(valid),.rst_n(rst_stp));


endmodule 