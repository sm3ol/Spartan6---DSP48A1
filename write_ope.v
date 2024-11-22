module wr_module(mosi,clk,rst);
	
	input wire clk,rst,mosi;

	wire [9:0] parallel_out;
	wire [7:0] doutt;
	wire tx_valid;
	reg rx_valid;
	wire valid;
	reg [9:0] parallel_out_reg;

	RAM r1( parallel_out_reg , rx_valid, clk,rst,doutt, tx_valid );
	SerialToParallel s1(.clk(clk),.rst_n(rst),.serial_in(mosi),.parallel_out(parallel_out),.valid(valid));

	always @(posedge clk or negedge rst) begin
		if (! rst) begin
			rx_valid <=0;
			
		end
		else  begin
			rx_valid<=valid;
			parallel_out_reg<=parallel_out;
		end
	end

endmodule