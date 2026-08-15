`timescale 1ns/1ps

module immediate_generator_tb;

    reg  [31:0] instruction;
    wire [31:0] immediate;

    immediate_generator uut (
        .instruction(instruction),
        .immediate(immediate)
    );

    initial begin

        // I-Type: ADDI x1, x0, 5   -> imm = 5
        instruction = 32'h00500093; #10;

        // I-Type: ADDI x1, x0, -1  -> imm = -1 (all 1s)
        instruction = 32'hFFF00093; #10;

        // S-Type: SW x2, 8(x1)     -> imm = 8
        instruction = 32'h00212423; #10;

        // S-Type: SW with negative offset -> imm = -4
        instruction = 32'hFE212E23; #10;

        // B-Type: BEQ x1, x2, +8   -> imm = 8
        instruction = 32'h00208463; #10;

        // B-Type: BEQ with negative offset
        instruction = 32'hFE208AE3; #10;

        // U-Type: LUI x1, 0x12345  -> imm = 0x12345000
        instruction = 32'h123450B7; #10;

        // U-Type: AUIPC x1, 0x1
        instruction = 32'h00001097; #10;

        // J-Type: JAL x1, +16      -> imm = 16
        instruction = 32'h010000EF; #10;

        // J-Type: JAL with negative offset
        instruction = 32'hFE1FF0EF; #10;

        // default/unsupported opcode
        instruction = 32'h00000000; #10;

        #10;
        $finish;
    end

endmodule