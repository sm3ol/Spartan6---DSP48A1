module SerialToParallel (
    input clk,    
    input rst_n, 
    input serial_in,        // Serial input
    output reg [9:0] parallel_out,  // 10-bit parallel output
    output reg valid        // Output valid signal
);


 reg [3:0] bit_count=0;  // Counter for the number of bits received

 always @(posedge clk ) begin
        
        if (!rst_n) begin
            parallel_out<=0;
            bit_count<=0;
            valid<=0;
        end
      // Shift the serial input into the parallel output register
        else begin 
            parallel_out <= (parallel_out << 1) | serial_in;

            // Increment the bit count
            bit_count <= bit_count + 1;

            // Check if a full byte has been received
            if (bit_count == 9) begin
                valid <= 1;  // Set valid high to indicate data is ready
                bit_count <= 0;  // Reset the bit counter
            end else
                valid <= 0;  // Clear the valid signal
            end
         end

 endmodule 