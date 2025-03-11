// rate 1/2 nonsystematic convolutional encoder with programmable taps and length
// bitwise row of AND gates makes feedforward pattern programmable
// N = 1 + constraint length
module conv_enc #(parameter N = 6)( // N = shift reg. length
  input               clk,
                      data_in,
                      reset,
  input       [  1:0] load_mask,  // 1: load mask0 pattern; 2: load mask1 
  input       [N-1:0] mask,       // mask pattern to be loaded; prepend with 1  
  output logic[  1:0] data_out);  // encoded data out

/* fill in the guts.
Hint: You need to build two parallel single-bit shift registers 
and AND/XOR networks. Build two indepenent single-bit encoders in paralle.
 */

// declare registers defining wires to them
// shift register to hold N bits of data (data_in + N-1 bits of history)
logic [N-1:0] shift_reg;
logic [N-1:0] maskq0;
logic [N-1:0] maskq1;

// define shift_reg behavior
// trigger on positive edge of clock or negative edge of reset
always_ff @(posedge clk or negedge reset) begin
    if (!reset) begin
        // Reset the shift register to all zeros
        shift_reg <= '0;  // set all bits of shift_reg to 0
    end 
    // check if load_mask == 00 (not loading)
    else if (load_mask == 2'b00) begin
        // shift registers, pushing right most bit out and data_in to left
        shift_reg <= {data_in, shift_reg[N-1:1]};
    end
end  // Added missing end here

// Mask0 register 
always_ff @(posedge clk) begin
    if (load_mask[0]) begin
        maskq0 <= mask;  // Load mask0 when load_mask[0] is 1
    end
end

// Mask1 register
always_ff @(posedge clk) begin
    if (load_mask[1]) begin
        maskq1 <= mask;  // Load mask1 when load_mask[1] is 1
    end
end

// Output calculation trick from slides
assign data_out[0] = ^(maskq0 & shift_reg);  // Reduction XOR of (mask0 AND shift_reg)
assign data_out[1] = ^(maskq1 & shift_reg);  // Reduction XOR of (mask1 AND shift_reg)

endmodule