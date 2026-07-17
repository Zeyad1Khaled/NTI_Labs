module RAM #(parameter ADDR_WIDTH=8,DATA_WIDTH=20)(
  input clk,
  input rst_n,wr_en,rd_en,
  input [ADDR_WIDTH-1:0]addr,
  input [DATA_WIDTH-1:0] din,
  
  output reg [DATA_WIDTH-1:0] dout,
  output reg valid
  
);
integer i;

reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

always @(posedge clk or negedge rst_n)begin
  if(!rst_n) begin
    dout  <= {DATA_WIDTH{1'b0}};
    valid <= 1'b0;

    for(i=0;i<(1<<ADDR_WIDTH);i=i+1)
        mem[i] <= {DATA_WIDTH{1'b0}};
end
    
  
else if(wr_en)begin
  $display("RAM WRITE: time=%0t addr=%0d data=%b",
         $time, addr, din);
    mem[addr]<=din;
    valid<=1'b0;
    dout <= {DATA_WIDTH{1'b0}};
  end
  
else if(rd_en)begin
  $display("RAM READ: time=%0t addr=%0d rd_en=%b data=%b",
         $time, addr, rd_en, mem[addr]);
    dout<=mem[addr];
    valid<=1'b1;
    
  end
  
else begin
    valid <= 1'b0;
end
end

endmodule