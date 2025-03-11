module conv_enc_tb;

parameter N = 4;                  // set to desired constraint length + 1;
bit          clk, data_in, reset;
bit  [  1:0] load_mask;		      // 01: load mask 0; 10: load mask 1
bit  [N-1:0] mask, mask0, mask1,   // prepend desired mask vaue with 1
             histo;
logic[  1:0] data_outP;
wire [  1:0] data_out;			  // assumes rate 1/2

// rate 1/2, constraint N-1 convolutional encoder
conv_enc #(.N(N)) ce1(.clk,
             .data_in,
			 .reset,
			 .load_mask,
			 .mask,
			 .data_out);

always begin
  #5ns clk = 1'b1;
  #5ns clk = 1'b0;
end

always @(posedge clk)               // histo = "history"
  histo <= {data_in,histo[N-1:1]};	// just a shift register

always @(negedge clk)
  if(data_outP == data_out)
    $display("expected %b, got %b  YAA!",data_outP,data_out);
  else
    $display("expected %b, got %b  DAMN!",data_outP,data_out);

initial begin
  #10ns mask      =  'o17;//'o15;		  // 5 with 1 prepended
        mask0     =  mask;
  #10ns load_mask = 2'b01;
  #10ns load_mask = 2'b00;
  #10ns mask      =  'o13;//'o17;
        mask1     =  mask;
  #10ns load_mask = 2'b10;
  #10ns load_mask = 2'b00;
  #10ns reset     = 1'b1;		  // start running
  #10ns data_in   = 1'b0;		  // sequence from Viterbi demo
  #90ns data_in   = 1'b1;
// sequence from thesis
  #10ns data_in   = 1'b1;
  #10ns data_in   = 1'b0;
  #10ns data_in   = 1'b1;
  #10ns data_in   = 1'b0;
  #10ns data_in   = 1'b0;
  #10ns data_in   = 1'b0;
  #10ns data_in   = 1'b0;
  #10ns data_in   = 1'b0;
  #10ns data_in   = 1'b0;
  #10ns data_in   = 1'b0;
  #10ns data_in   = 1'b0;
  #10ns data_in   = 1'b0;
  #10ns data_in   = 1'b0;
    
  #40ns $stop;
  #10ns data_in   = 1'b0;
  #10ns data_in   = 1'b1;
  #10ns data_in   = 1'b1;
  #10ns data_in   = 1'b0;
  #40ns $stop; 
  #40ns data_in   = 1'b1;
  #10ns data_in   = 1'b0;
  #10ns data_in   = 1'b1;
  #10ns data_in   = 1'b1;
  #10ns data_in   = 1'b0;
  #10ns data_in   = 1'b0;
  #10ns data_in   = 1'b0;
  #10ns data_in   = 1'b0;
  #10ns data_in   = 1'b0;
  #10ns data_in   = 1'b0;
  #10ns data_in   = 1'b0;
  #10ns data_in   = 1'b0;
  #10ns $stop; 
  #40ns data_in   = 1'b1;
  #10ns data_in   = 1'b0;
  #10ns data_in   = 1'b1;
  #10ns data_in   = 1'b1;
  #10ns data_in   = 1'b1;
  #10ns data_in   = 1'b0;
  #10ns data_in   = 1'b0;
  #40ns $stop; 
  #10ns data_in   = 1'b1;
  #10ns data_in   = 1'b0;
  #10ns data_in   = 1'b1;
  #10ns data_in   = 1'b0;
  #10ns data_in   = 1'b0;
  #10ns data_in   = 1'b0;
  #10ns data_in   = 1'b1;
  #10ns data_in   = 1'b0;
  #60ns $stop;
end

always_comb begin
  data_outP[1] = ^(mask1&histo);
  data_outP[0] = ^(mask0&histo);
end

endmodule