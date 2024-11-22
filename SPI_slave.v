	module SPI_slave(MOSI,MISO,SS_n,clk,rst_n);

		input wire clk,rst_n,MOSI,SS_n;
		output reg MISO;
		

		parameter IDLE =3'b000;
		parameter WRITE =3'b001;
		parameter READ_DATA =3'b010;
		parameter READ_ADD =3'b011;
		parameter CHECK_CMD =3'b100;

		reg [2:0]current_state;
		reg [2:0]next_state;





		wire serial_out;
		wire pts_valid;
		reg stp_input;
		wire stp_valid;
		wire [7:0] stp_out;
		reg ram_rx_valid;
		wire [7:0] Uram_out;
		wire tx_valid;
		reg read_dta;
		reg rst;

		always @(posedge clk)begin
			case (current_state)
			IDLE: begin
			
			if (SS_n)
				next_state<=IDLE;
			else next_state<= CHECK_CMD;
			end	
			CHECK_CMD:begin
				if (SS_n)
				next_state<= IDLE;
				else begin
					if (MOSI) begin
						if (read_dta)
						next_state <= READ_DATA;
						else next_state<= READ_ADD;
						end
					else next_state <= WRITE;
				end	
			end
			WRITE: begin
				if (SS_n)
				next_state<= IDLE;
			end
			READ_DATA:begin
				if (SS_n)
				next_state <= IDLE;
			end
			READ_ADD: begin
				if (SS_n)
				next_state<= IDLE;

			end
			default: next_state<= IDLE;
			endcase

		end


		always @(posedge clk or posedge rst_n) begin
			if (! rst_n) begin
				current_state <= IDLE;
				read_dta<=0;
				rst<=0;

			end
			else 
			current_state<=next_state;
				
		end


		SerialToParallel U_STP(.clk(clk),.rst_n(rst),.serial_in(stp_input),.parallel_out(stp_out),.valid(stp_valid));
		
		RAM U_RAM(.din(stp_out), .rx_valid(ram_rx_valid), .clk(clk),.rst_n(rst_n),.doutt(Uram_out), .tx_valid(tx_valid) );
		ParallelToSerial U_PTS (.clk(clk),.parallel_in(Uram_out),.valid(pts_valid),.serial_out(serial_out),.rst_n(tx_valid));


		always @(posedge clk)begin
			case (current_state)
				IDLE:begin	MISO<=0;
					rst<=0;
					end
				WRITE: begin
					stp_input<=MOSI;
					if (stp_valid)
					ram_rx_valid=1;
					end
				READ_ADD:begin
					rst<=1;
					stp_input<=MOSI;
					ram_rx_valid<=0;
					if (stp_valid)
						read_dta<=1;
					else read_dta<=0;
			
				end
				READ_DATA: begin
					MISO<=serial_out;
				end
				
			endcase
		end

	endmodule 
