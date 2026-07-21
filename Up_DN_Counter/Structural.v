module counter2_structural(
    
    input clock,
    input reset,
    input up,
    
    output [1:0] count
);
//wires


wire q0, q1;
wire d0, d1;
wire x1, x2;
wire a, b;
wire not_up;


not  (d0, q0);

xor  (x1, q1, q0);
xnor (x2, q1, q0);

not  (not_up, up);

and  (a, up, x1);
and  (b, not_up, x2);

or   (d1, a, b);
dff FF0(
.clk(clock),
.reset(reset),
.d(d0),
.q(q0)
);

dff FF1(
.clk(clock),
.reset(reset),
.d(d1),
.q(q1)
);


assign count = {q1, q0};

endmodule