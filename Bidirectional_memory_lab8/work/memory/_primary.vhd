library verilog;
use verilog.vl_types.all;
entity memory is
    generic(
        AWIDTH          : integer := 5;
        DWIDTH          : integer := 8
    );
    port(
        wr              : in     vl_logic;
        rd              : in     vl_logic;
        addr            : in     vl_logic_vector;
        clk             : in     vl_logic;
        data            : inout  vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of AWIDTH : constant is 1;
    attribute mti_svvh_generic_type of DWIDTH : constant is 1;
end memory;
