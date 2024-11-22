module spi(MOSI,clk,rst_n,SS_n,rx_data,MISO);
	
	
	input wire MOSI,clk,rst_n,SS_n;
	output reg MISO;

	output reg [9:0] rx_data;

	wire tx_valid;
	reg[2:0] current_state,next_state;
	
	parameter IDLE= 3'b000;
	parameter CHECk_CMD= 3'b001;
	parameter WRITE_ADD= 3'b010;
	parameter WRITE_DATA= 3'b011;
	parameter READ_ADD= 3'b100;
	parameter READ_DATA= 3'b101;

	reg [1:0]opcode;


	wire stp_valid;
	reg rst_stp;
	wire [9:0] stp_out;
	reg add_state;

	reg rx_valid;
		// state memory 


		always @(posedge clk or negedge rst_n) begin
			if (!rst_n) begin
				current_state<=IDLE;
				add_state<=0;
			end
			else  begin
				current_state<=next_state;
			end
		end
 
		// Next state logic 
		always @(*)begin
			case (current_state)
			IDLE: if (!SS_n)begin
				next_state<= CHECk_CMD;
			end
			CHECk_CMD: begin
					if (!MOSI)begin
							if (!add_state)
							next_state<= WRITE_ADD;
							else next_state<= WRITE_DATA;
					end else begin
						if (!add_state)
						next_state<= READ_ADD;
						else next_state<= READ_DATA;
					end
			end
			READ_ADD:begin
				
				 if (SS_n) begin next_state<=IDLE;
				 	add_state<=1;
				 	end 
				else next_state<= READ_ADD;	
			end
			READ_DATA: begin
				 if  (SS_n) begin next_state<=IDLE;
					add_state<=0;

				end 
				else next_state<= READ_DATA;
			end
			WRITE_ADD: begin
				if (SS_n) begin 
				next_state<=IDLE;
				add_state<=1;
				 end 
				 	else next_state<= WRITE_ADD;
			end
			WRITE_DATA: begin
				 if (SS_n) begin next_state<=IDLE;
					add_state<=0;
		 
				 end
				else next_state<= WRITE_DATA;
			end
			endcase 
		end


		reg rst_pts;
		wire pts_valid;
		wire pts_out;
		reg rst_ram;
		wire [7:0] ram_out;
		reg [7:0]pts_in;
		reg stp_input;
		reg ram_input;
 	always @(posedge clk or negedge rst_n ) begin
 		if (! rst_n) begin			
			rst_stp<=0;
			ram_input<=0;
			rst_pts<=0;
			rst_ram<=0;

		end	

		else begin
			case (current_state)
			IDLE:begin
					rst_pts<=0;
					rst_stp<=0;

			end
			READ_ADD:begin
				rx_valid<=0;
				if (stp_valid)
					ram_input<=stp_out;
				else begin rst_pts<=1;
				stp_input<=MOSI;end
			end
			READ_DATA:begin
			rx_valid<=0;
			if (tx_valid)begin
				rst_pts<=1;
				pts_in<=ram_out;
			end
			if (pts_valid)
				MISO<=pts_out;

			end
			WRITE_ADD:begin
			if (stp_valid)begin
				ram_input<=stp_out;
				rx_valid<=1;
				end else begin 
				rst_pts<=1;
				stp_input<=MOSI;
				end
			
			end
			WRITE_DATA:begin
				if (stp_valid)begin
				ram_input<=stp_out;
				rx_valid<=1;
				end else begin 
				rst_pts<=1;
				stp_input<=MOSI;
				end
			end

		endcase
 	end


 	RAM U_RAM (.din(ram_input), .rx_valid(rx_valid), .clk(clk),.rst_n(rst_ram),.doutt(ram_out), .tx_valid(tx_valid) );
 	ParallelToSerial U_Pts(.clk(clk),.rst_n(rst_pts),.parallel_in(pts_in),.valid(pts_valid),.serial_out(pts_out));
 	SerialToParallel U_Stp(.clk(clk),.serial_in(stp_input),.parallel_out(stp_out),.valid(stp_valid),.rst_n(rst_stp));


endmodule 
