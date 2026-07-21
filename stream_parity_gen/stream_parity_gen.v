module stream_parity_gen (
  
  input clk,reset,
  input serial_in,
  output reg parity_out
  
);
reg [7:0] shift_register;

function parity (
  input [7:0]in
);
begin
parity=^in;
end
endfunction

always@(posedge clk)begin
  if(reset)begin
    shift_register  <= 8'b0;
    parity_out<='b0;
  end
else begin
  shift_register<={shift_register[6:0],serial_in};
  parity_out <= parity({shift_register[6:0], serial_in});
  
end
end
endmodule


