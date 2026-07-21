`timescale 1ns / 1ps
module Parity_TBs;
  
  reg clk;
  reg reset;
  reg serial_in;
  wire parity_out;
  
  // DUT instantiation
  stream_parity_gen dut (
    /*.clk(clk),
    .reset(reset),
    .serial_in(serial_in),
    .parity_out(parity_out)
	*/
	.*
  ); 

  always #5 clk = ~clk;
  
  task t_serial_in(input [7:0] in, input expected_parity); 
    
	integer i;
	
	begin
	  for (i = 7; i>=0; i=i-1)
	    begin
		  @(negedge clk);
		  serial_in = in[i];
		end
	  
	  
	  @(negedge clk)
	  if (parity_out == expected_parity)
	     $display("Test passed with frame = %b,  output parit is %b", inputs, expected_parity);
	  else
         $display("Test failed with frame = %b output parit is not as expected", inputs);	  

	end
	
  endtask
  
  reg [7:0] inputs;
  reg expected_parity;
  
  initial 
    begin
	  clk = 0;
      serial_in = 1'b1;
	  reset = 0;
	  /*
	  expected_parity = 1'bx;
	  if (parity_out == expected_parity)
	     $display("Test passed with frame = %b,  output parit is %b", inputs, expected_parity);
	  else
         $display("Test failed with frame = %b output parit is not as expected", inputs);	  
      */
	  @(negedge clk);
	  reset = 1;
	  repeat (2) @(negedge clk);
	  reset = 0;	  
	  /*@(negedge clk);
	  serial_in = 1'b0;
	  @(negedge clk)
	  serial_in = 1'b1;
	  @(negedge clk)
	  serial_in = 1'b1;
	  @(negedge clk)
	  serial_in = 1'b1;
	  @(negedge clk)
	  serial_in = 1'b0;
	  @(negedge clk)
	  serial_in = 1'b1;
	  @(negedge clk)
	  serial_in = 1'b1;	   //  parity_out = 0
	  @(negedge clk)
	  if (parity_out == 1'b0)
	     $display("Test passed with frame = 10111011 output parit is 0");
	  else
         $display("Test failed with frame = 10111011 output parit is not as expected");	  
	  */
	  inputs = 8'b0000_0111;
	  expected_parity = 1'b1;
	  t_serial_in (inputs, expected_parity);

	  inputs = 8'b0010_0111;
	  expected_parity = 1'b0;
	  t_serial_in (inputs, expected_parity);

	  inputs = 8'b0000_0001;
	  expected_parity = 1'b1;
	  t_serial_in (inputs, expected_parity);	  
	  /*
	  @(negedge clk)
	  if (parity_out == expected_parity)sim:/Parity_TBs/clk sim:/Parity_TBs/reset sim:/Parity_TBs/serial_in sim:/Parity_TBs/parity_out sim:/Parity_TBs/dut sim:/Parity_TBs/t_serial_in/in sim:/Parity_TBs/t_serial_in/expected_parity sim:/Parity_TBs/t_serial_in/i sim:/Parity_TBs/expected_parity sim:/Parity_TBs/t_serial_in/inputs sim:/Parity_TBs/inputs
	     $display("Test passed with frame = %b,  output parit is %b", inputs, expected_parity);
	  else
         $display("Test failed with frame = %b output parit is not as expected", inputs);	  
*/
	  #20;
	  
	  $stop;
	
	end
  

endmodule