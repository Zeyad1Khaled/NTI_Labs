library verilog;
use verilog.vl_types.all;
entity SIPO is
    generic(
        WIDTH           : integer := 20
    );
    port(
        clk             : in     vl_logic;
        shift_en        : in     vl_logic;
        rst_n           : in     vl_logic;
        serial_in       : in     vl_logic;
        parallel_out    : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
end SIPO;
