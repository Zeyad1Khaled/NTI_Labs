module SIPO#(parameter WIDTH=20)(
  
  input wire clk,
  input wire shift_en,rst_n,serial_in,
  
  output reg [WIDTH-1:0] parallel_out
);

always@(posedge clk or negedge rst_n)begin
  if(!rst_n)
      parallel_out<= {WIDTH{1'b0}};
  
  else if (shift_en)begin
		parallel_out<={parallel_out[WIDTH-2:0],serial_in};
  end
  
end


endmodule

