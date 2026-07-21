module memory #(parameter AWIDTH=5,DWIDTH=8)(
  input wire wr,rd,
  input [AWIDTH-1:0] addr,
  input clk,
  
  inout [DWIDTH-1:0] data
);
reg [DWIDTH-1:0] memory [0:(1<<(AWIDTH))-1];

always@(posedge clk)begin
  
  if(wr && !rd)begin
    memory[addr]<=data;
  end
  
end
assign data=rd?memory[addr]:{DWIDTH{1'bz}};
endmodule