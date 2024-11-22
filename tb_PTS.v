module tb_PTS();

	reg clk;              // Clock signal
    reg [7:0] parallel_in;  // 8-bit parallel input
    wire valid;        // Output valid signal
 	wire serial_out;        // Serial input
 	reg rst_n;

	ParallelToSerial DUT (.clk(clk),.parallel_in(parallel_in),.valid(valid),.serial_out(serial_out),.rst_n(rst_n));


	initial begin
		clk =1;
		forever #5 clk=~clk;
	end


	initial begin
		rst_n=0;
		parallel_in =5;
		# 100 rst_n=1;
		parallel_in=3;
		#30;
		parallel_in=4;
		#50 parallel_in=7;
	end

endmodule 
