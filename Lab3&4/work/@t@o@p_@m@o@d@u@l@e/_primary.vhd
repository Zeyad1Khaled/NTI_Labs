library verilog;
use verilog.vl_types.all;
entity TOP_MODULE is
    generic(
        WIDTH           : integer := 20;
        Addr_width      : integer := 8;
        ALU_OUT         : integer := 8
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        wr_en           : in     vl_logic;
        addr            : in     vl_logic_vector;
        din             : in     vl_logic_vector;
        \out\           : out    vl_logic_vector;
        a_is_zero       : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
    attribute mti_svvh_generic_type of Addr_width : constant is 1;
    attribute mti_svvh_generic_type of ALU_OUT : constant is 1;
end TOP_MODULE;
