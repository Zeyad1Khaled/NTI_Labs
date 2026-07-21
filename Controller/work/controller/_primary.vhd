library verilog;
use verilog.vl_types.all;
entity controller is
    port(
        opcode          : in     vl_logic_vector(2 downto 0);
        phase           : in     vl_logic_vector(2 downto 0);
        zero            : in     vl_logic;
        sel             : out    vl_logic;
        rd              : out    vl_logic;
        ld_ir           : out    vl_logic;
        inc_pc          : out    vl_logic;
        halt            : out    vl_logic;
        ld_pc           : out    vl_logic;
        data_e          : out    vl_logic;
        ld_ac           : out    vl_logic;
        wr              : out    vl_logic
    );
end controller;
