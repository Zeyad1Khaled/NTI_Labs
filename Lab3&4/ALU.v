module ALU#(parameter WIDTH=8)(
  input alu_en,
  input [2:0] opcode,
  input [WIDTH-1:0] in_a,in_b,
  
  output reg [WIDTH-1:0] alu_out,
  output reg a_is_zero
);

always@(*)begin
  if(!alu_en)begin
    alu_out={WIDTH{1'b0}};
  end
  
  else begin
    case(opcode)
      3'b000:alu_out=in_a + in_b;
      3'b001:alu_out=in_a - in_b;
      3'b010:alu_out=in_a & in_b;
      3'b011:alu_out=in_a ^ in_b;
      3'b100:alu_out=in_a | in_b;
      3'b101:alu_out=in_a;
      default:alu_out={WIDTH{1'b0}};
      endcase
      
    end
    
end



always@(*)begin
  if((!in_a) && (alu_en))begin
    a_is_zero=1'b1;
  end
  else
  a_is_zero=1'b0;  
end

endmodule