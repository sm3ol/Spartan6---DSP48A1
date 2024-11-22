module Ram_tb();

	reg [9:0]din;
	reg  rx_valid;
	reg  clk;
	reg rst_n;
	wire [7:0]dout; 
	wire tx_valid;


	RAM DUT(din, rx_valid, clk,rst_n,dout, tx_valid );
initial begin
 	$readmemh ("mem.dat",DUT.U1_spr.mem);
end 
	initial begin
		clk=1;
		forever #5 clk=~clk;
	end

	initial begin
			din=0;
			rx_valid=0;
			rst_n=0;
			#50 rst_n=1;

			din=10'b0011111111;
			rx_valid=1;

			#10 din =10'b01_0000_0011;
			#10;
			din=10'b0011111110;
			rx_valid=0;
			#10 din =10'b01_0000_0111;
			
			#10 din=10'b0011111110;
			rx_valid=1;
			#10 din =10'b00_0000_0011;
			#10 din =10'b01_0000_0111;



			#10 din =10'b10_1111_1111;
			#50 din =10'b11_1111_0011;

			#50 din =10'b10_1111_1110;
			#50 din =10'b10_0000_0011;

			#50 din =10'b11_0000_0011;

			rst_n=0;
	end
endmodule 
