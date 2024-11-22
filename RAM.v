module RAM(din, rx_valid, clk,rst_n,doutt, tx_valid );

	parameter MEM_WIDTH =8;
	parameter MEM_DEPTH	=256;
input wire [9:0] din;
	reg [9:0]din_reg;
input wire rx_valid;
	
input wire clk;
input wire rst_n;


output reg [MEM_WIDTH-1:0] doutt;
output reg tx_valid;

reg [MEM_WIDTH-1:0] address;
reg [MEM_WIDTH-1:0] spr_in;
wire [MEM_WIDTH-1:0] spr_out;
reg blk_select;
reg rd_en;
reg wr_en;
	
	always @(posedge clk) begin
	din_reg<=din;
	end
	
	spr_async U1_spr(.din(spr_in), .dout(spr_out), .rd_en(rd_en),.wr_en(wr_en),.blk_select(blk_select),.address(address));
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			doutt<=0;
			tx_valid<=0;
			blk_select<=0;
			spr_in<=0;
			wr_en<=0;
			rd_en<=0;
			address<=0;
		end
		else begin
			case (din_reg[9:8])
			2'b00:begin 
			if (rx_valid) begin
				address <= din_reg[7:0];
				blk_select<=1;
				wr_en<=1;
				rd_en<=0;
				end

			end
			2'b01: begin if(rx_valid)begin
			spr_in <= din_reg [7:0];
				end
			end
			2'b10: begin
				address<=din_reg[7:0];
				blk_select<= 1;
				rd_en <=1;
				wr_en<=0;
				tx_valid<=0;
			end

			2'b11:begin
				doutt<= spr_out;
				tx_valid<=1;
			end

			default : begin
				doutt<=0;
				tx_valid<=0;
				blk_select<=0;
				spr_in<=0;
				wr_en<=0;
				rd_en<=0;
				address<=0;
			end 
			endcase
		end
	end


endmodule 
