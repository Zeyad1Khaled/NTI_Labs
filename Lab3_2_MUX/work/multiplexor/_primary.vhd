library verilog;
use verilog.vl_types.all;
entity multiplexor is
    generic(
        WIDTH           : vl_notype
    );
    port(
        in0             : in     vl_logic_vector;
        in1             : in     vl_logic_vector;
        sel             : in     vl_logic;
        mux_out         : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 5;
end multiplexor;
