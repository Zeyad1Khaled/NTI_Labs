library verilog;
use verilog.vl_types.all;
entity overlapping is
    port(
        din             : in     vl_logic;
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        seq_detected    : out    vl_logic
    );
end overlapping;
