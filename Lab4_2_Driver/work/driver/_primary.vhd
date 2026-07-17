library verilog;
use verilog.vl_types.all;
entity driver is
    generic(
        WIDTH           : vl_notype
    );
    port(
        data_in         : in     vl_logic_vector;
        data_en         : in     vl_logic;
        data_out        : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 5;
end driver;
