library verilog;
use verilog.vl_types.all;
entity \register\ is
    generic(
        WIDTH           : integer := 8
    );
    port(
        data_in         : in     vl_logic_vector;
        load            : in     vl_logic;
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        data_out        : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
end \register\;
