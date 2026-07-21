library verilog;
use verilog.vl_types.all;
entity stream_parity_gen is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        serial_in       : in     vl_logic;
        parity_out      : out    vl_logic
    );
end stream_parity_gen;
