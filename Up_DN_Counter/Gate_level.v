module counter2_gate (
    input clock,
    input reset,
    input up,
    output reg [1:0] count
);

wire q0, q1;
wire d0, d1;
wire x1, x2, a, b;

assign q0 = count[0];
assign q1 = count[1];

not  (d0, q0);
xor  (x1, q1, q0);
xnor (x2, q1, q0);

and  (a, up, x1);
and  (b, ~up, x2);
or   (d1, a, b);

always @(posedge clock or posedge reset) begin
    if (reset)
        count <= 2'b00;
    else begin
        count[0] <= d0;
        count[1] <= d1;
    end
end

endmodule