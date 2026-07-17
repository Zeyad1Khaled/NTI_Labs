module controller(
    input  [2:0] opcode,
    input  [2:0] phase,
    input        zero,

    output reg sel,
    output reg rd,
    output reg ld_ir,
    output reg inc_pc,
    output reg halt,
    output reg ld_pc,
    output reg data_e,
    output reg ld_ac,
    output reg wr
);

// Intermediate terms
reg HALT;
reg SKZ;
reg ALUOP;
reg STO;
reg JMP;

always @(*) begin

    // Decode opcode
    HALT  = (opcode == 3'd0);
    SKZ   = (opcode == 3'd1);
    ALUOP = (opcode == 3'd2) ||
            (opcode == 3'd3) ||
            (opcode == 3'd4) ||
            (opcode == 3'd5);
    STO   = (opcode == 3'd6);
    JMP   = (opcode == 3'd7);

    // Default outputs
    sel    = 1'b0;
    rd     = 1'b0;
    ld_ir  = 1'b0;
    inc_pc = 1'b0;
    halt   = 1'b0;
    ld_pc  = 1'b0;
    data_e = 1'b0;
    ld_ac  = 1'b0;
    wr     = 1'b0;

    case (phase)

        // INST_ADDR
        3'd0: begin
            sel = 1'b1;
        end

        // INST_FETCH
        3'd1: begin
            sel = 1'b1;
            rd  = 1'b1;
        end

        // INST_LOAD
        3'd2: begin
            sel   = 1'b1;
            rd    = 1'b1;
            ld_ir = 1'b1;
        end

        // IDLE
        3'd3: begin
            sel   = 1'b1;
            rd    = 1'b1;
            ld_ir = 1'b1;
        end

        // OP_ADDR
        3'd4: begin
            if (HALT)
                halt = 1'b1;
            else
                inc_pc = 1'b1;
        end

        // OP_FETCH
        3'd5: begin
            if (ALUOP)
                rd = 1'b1;
        end

        // ALU_OP
        3'd6: begin
            if (ALUOP)
                rd = 1'b1;

            if (STO)
                data_e = 1'b1;

            if (JMP)
                ld_pc = 1'b1;

            // Included to match the original spec if desired.
            // Your testbench doesn't actually check this condition.
            if (SKZ && zero)
                inc_pc = 1'b1;
        end

        // STORE
        3'd7: begin
            if (ALUOP) begin
                rd    = 1'b1;
                ld_ac = 1'b1;
            end

            if (STO) begin
                data_e = 1'b1;
                wr     = 1'b1;
            end

            if (JMP)
                ld_pc = 1'b1;
        end

        default: begin
        end

    endcase

end

endmodule