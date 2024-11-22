module tb_write();

	reg MOSI,clk,rst_n,SS_n;
	wire MISO;

	initial begin
		clk=1;
		forever #5 clk=~clk;
	end

	initial begin
		rst_n=0;
		MOSI=1;
		SS_n=0;
		#10;

		rst_n=1;
		MOSI=0;
		SS_n=1;
		#10;

		rst_n=1;
		MOSI=1;
		SS_n=0;
		#10;

		rst_n=1;
		MOSI=0;
		SS_n=0;
		#10;

		MOSI=0;
		#70 MOSI=1;
		#30 SS_n =1;


	end

	MOSI_input DUT (MOSI,clk,rst_n,SS_n,,rx_valid,rx_data);
endmodule