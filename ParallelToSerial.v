module ParallelToSerial(
    input rst_n,            // Active low reset
    input clk,              // Clock signal
    input wire [7:0] parallel_in,  // 8-bit parallel input
    output reg valid,       // Output valid signal
    output reg serial_out   // Serial output
);

    reg [2:0] bit_count = 0;  // Counter for the number of bits transmitted
    reg [7:0] shift_reg;      // Shift register to hold the parallel input

    always @(posedge clk or negedge rst_n ) begin
        if (!rst_n) begin
            // Reset state
            shift_reg <= 0;
            valid <= 0;
            bit_count <= 0;
            serial_out <= 0;
        end else begin
            if (bit_count == 0 && valid == 0) begin
                // Load the parallel data into the shift register at the start
                shift_reg <= parallel_in;
                serial_out <= shift_reg[0];  // Output LSB first
                valid <= 1;  // Valid is high initially to indicate start of transmission
                bit_count <= 1;  // Increment bit count after setup
            end else if (bit_count < 8) begin
                shift_reg <= shift_reg >> 1;  // Shift right to get the next bit
                serial_out <= shift_reg[0];  // Continue outputting bits
                bit_count <= bit_count + 1;  // Increment bit count
            end

            if (bit_count == 8) begin
                bit_count <= 0;  // Reset the bit counter after all bits are sent
                valid <= 0;  // Reset valid signal to indicate end of transmission
            end
        end
    end
endmodule
