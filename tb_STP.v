module tb_STP();
	reg clk;              // Clock signal
    reg serial_in;        // Serial input
    wire  [7:0] parallel_out;  // 8-bit parallel output
    wire valid;        // Output valid signal
    reg rst_n; 

    initial begin
    	clk=1;
    	forever #5 clk=~clk;
    end

    SerialToParallel DUT(.clk(clk),.serial_in(serial_in),.parallel_out(parallel_out),.valid(valid),.rst_n(rst_n));


    initial begin
        rst_n=0;


    	serial_in=0;
    	#10 serial_in =0;
    	#10 serial_in =0;
    	#10 serial_in =0;
    	#10 serial_in =0;
    	#10 serial_in =0;
    	#10 serial_in =1;
    	#10 serial_in =0;
    	// 
        #10 rst_n=1;

    	#10 serial_in=0;
    	#10 serial_in =0;
    	#10 serial_in =0;
    	#10 serial_in =0;
    	#10 serial_in =0;
    	#10 serial_in =0;
    	#10 serial_in =0;
    	#10 serial_in =0;
    	#10 serial_in =0;
    	#10 serial_in =1;

    	#10 serial_in =0;
    	#10 serial_in =0;
    	#10 serial_in =0;
    	#10 serial_in =0;
    	#10 serial_in =0;
    	#10 serial_in =0; 	
    	#10 serial_in =0;
    	#10 serial_in =0;
    	#10 serial_in =1;
    	#10 serial_in =1;

    	#10 serial_in =0;
    	#70serial_in =1;
    	
    end
endmodule 
