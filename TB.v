module Tb();

	reg clk,rst_n,MOSI,SS_n;
	wire MISO;

	SPI_slave DUT(MOSI,MISO,SS_n,clk,rst_n);


	initial begin
		clk=1;
		forever #5 clk=~clk;
	end

	initial begin
 	$readmemh ("mem.dat",DUT.U_RAM.U1_spr.mem);
	end 

	initial	begin
		rst_n =0;
		MOSI=0;
		SS_n=0;
		#80 rst_n=1;
		SS_n=1;
		#70;
		SS_n=0;
		// 10 bit 
		#10 MOSI=0;
		#10 MOSI=0;

		#10 MOSI=1;
		#10 MOSI=1;
		#10 MOSI=1;
		#10 MOSI=1;

		#10 MOSI=1;
		#10 MOSI=1;
		#10 MOSI=1;
		#10 MOSI=1;
 
 	///
 		#10 MOSI=0;
		#10 MOSI=1;

		#10 MOSI=0;
		#10 MOSI=0;
		#10 MOSI=0;
		#10 MOSI=0;

		#10 MOSI=0;
		#10 MOSI=0;
		#10 MOSI=0;
		#10 MOSI=1;
 		
	end

endmodule 
