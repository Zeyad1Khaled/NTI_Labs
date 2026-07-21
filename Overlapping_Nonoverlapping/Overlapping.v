module overlapping(
  input din,
  input clk,
  input rst,
  
  output reg seq_detected
);
reg [2:0]current_state,next_state;

localparam 
s0='b0,
s1='b01,
s2='b10,
s3='b11,
s4='b100,
s5='b101,
s6='b110;

always@(*)begin
  seq_detected=0;
  case(current_state)
    s0:next_state=din?s1:s0; //1
    s1:next_state=din?s2:s0; //11
    s2:next_state=din?s2:s3; //110
    s3:next_state=din?s4:s0; //1101
    s4:next_state=din?s2:s5; //11010
    s5:next_state=din?s6:s0; //110101
    s6:begin 
    seq_detected='b1;
    next_state=din?s2:s0;
    end
    default:next_state = s0;
endcase
end

always@(posedge clk or posedge rst)begin
  if(rst)begin
    current_state<=s0;
  end
else begin
  current_state<=next_state;
end
end

endmodule