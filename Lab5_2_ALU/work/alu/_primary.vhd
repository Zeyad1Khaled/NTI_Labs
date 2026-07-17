library verilog;
use verilog.vl_types.all;
entity alu is
    generic(
        WIDTH           : integer := 8
    );
    port(
        in_a            : in     vl_logic_vector;
        in_b            : in     vl_logic_vector;
        opcode          : in     vl_logic_vector(2 downto 0);
        a_is_zero       : out    vl_logic;
        alu_out         : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
end alu;
