library verilog;
use verilog.vl_types.all;
entity ALU is
    generic(
        WIDTH           : integer := 8
    );
    port(
        alu_en          : in     vl_logic;
        opcode          : in     vl_logic_vector(2 downto 0);
        in_a            : in     vl_logic_vector;
        in_b            : in     vl_logic_vector;
        alu_out         : out    vl_logic_vector;
        a_is_zero       : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
end ALU;
