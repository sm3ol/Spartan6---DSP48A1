module tb1 ();

reg mosi,clk,rst;


initial begin
        clk = 1;
        forever #5 clk = ~clk;  // 100 MHz clock
    end
    initial begin
	$readmemh ("mem.dat",w1.r1.U1_spr.mem);
	end

wr_module w1(mosi,clk,rst);

	initial begin
	rst=0;
	#50 rst=1;

		mosi=0;
	#10 mosi=0;

	#10 mosi=1;
	#10 mosi=1;
	#10 mosi=1;
	#10 mosi=1;

	#10 mosi=1;
	#10 mosi=1;
	#10 mosi=1;
	#10 mosi=1;
	///////////

	#10 mosi=0;
	#10 mosi=1;

	#10 mosi=0;
	#10 mosi=0;
	#10 mosi=0;
	#10 mosi=0;

	#10 mosi=0;
	#10 mosi=0;
	#10 mosi=0;
	#10 mosi=1;
	///////////


	end 


endmodule 