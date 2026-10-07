module multiplexor #(parameter WIDTH)(
 input wire [WIDTH-1:0] in0,in1,
 input sel,
  output reg [WIDTH-1:0] mux_out
);

always@(*)begin
  if(sel)begin
    mux_out=in1;
  end
  else
    mux_out=in0;
end

endmodule
