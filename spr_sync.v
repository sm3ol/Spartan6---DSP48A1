module spr_async(din, dout, rd_en,wr_en,blk_select,address);


	parameter MEM_WIDTH =8;
	parameter MEM_DEPTH	=256;
			input wire [MEM_WIDTH-1:0] address;
			input wire [MEM_WIDTH-1:0]din;
				// enable signals 
				input wire rd_en;
				input wire wr_en;
				input wire blk_select;

				//output 
				output reg [MEM_WIDTH-1:0] dout;


	reg [MEM_WIDTH-1:0] mem[MEM_DEPTH-1:0];


	always @(*) begin
		if (blk_select) begin
			if (wr_en)
			mem[address]<=din;
			if(rd_en)
			dout<=mem[address];
		end
	end

endmodule 
