library verilog;
use verilog.vl_types.all;
entity PISO is
    generic(
        WIDTH           : integer := 20;
        ADDR_WIDTH      : integer := 8
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        parallel_in     : in     vl_logic_vector;
        ram_valid       : in     vl_logic;
        en              : out    vl_logic;
        serial_out      : out    vl_logic;
        valid           : out    vl_logic;
        addr            : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
    attribute mti_svvh_generic_type of ADDR_WIDTH : constant is 1;
end PISO;
