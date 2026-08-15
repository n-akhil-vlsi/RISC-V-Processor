`timescale 1ns/1ps

module alu_control_tb;

    reg  [1:0] ALUOp;
    reg  [2:0] funct3;
    reg  [6:0] funct7;
    wire [3:0] ALUControl;

    alu_control uut (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .ALUControl(ALUControl)
    );

    initial begin

        // Load/Store -> always ADD
        ALUOp = 2'b00; funct3 = 3'b000; funct7 = 7'b0000000; #10;

        // Branch: BEQ -> SUB
        ALUOp = 2'b01; funct3 = 3'b000; funct7 = 7'b0000000; #10;
        // Branch: BNE -> SUB
        ALUOp = 2'b01; funct3 = 3'b001; funct7 = 7'b0000000; #10;
        // Branch: BLT -> SLT
        ALUOp = 2'b01; funct3 = 3'b100; funct7 = 7'b0000000; #10;
        // Branch: BGE -> SLT
        ALUOp = 2'b01; funct3 = 3'b101; funct7 = 7'b0000000; #10;
        // Branch: BLTU -> SLTU
        ALUOp = 2'b01; funct3 = 3'b110; funct7 = 7'b0000000; #10;
        // Branch: BGEU -> SLTU
        ALUOp = 2'b01; funct3 = 3'b111; funct7 = 7'b0000000; #10;

        // R-Type: ADD
        ALUOp = 2'b10; funct3 = 3'b000; funct7 = 7'b0000000; #10;
        // R-Type: SUB
        ALUOp = 2'b10; funct3 = 3'b000; funct7 = 7'b0100000; #10;
        // R-Type: AND
        ALUOp = 2'b10; funct3 = 3'b111; funct7 = 7'b0000000; #10;
        // R-Type: OR
        ALUOp = 2'b10; funct3 = 3'b110; funct7 = 7'b0000000; #10;
        // R-Type: XOR
        ALUOp = 2'b10; funct3 = 3'b100; funct7 = 7'b0000000; #10;
        // R-Type: SLL
        ALUOp = 2'b10; funct3 = 3'b001; funct7 = 7'b0000000; #10;
        // R-Type: SRL
        ALUOp = 2'b10; funct3 = 3'b101; funct7 = 7'b0000000; #10;
        // R-Type: SRA
        ALUOp = 2'b10; funct3 = 3'b101; funct7 = 7'b0100000; #10;
        // R-Type: SLT
        ALUOp = 2'b10; funct3 = 3'b010; funct7 = 7'b0000000; #10;
        // R-Type: SLTU
        ALUOp = 2'b10; funct3 = 3'b011; funct7 = 7'b0000000; #10;

        // I-Type: ADDI
        ALUOp = 2'b11; funct3 = 3'b000; funct7 = 7'b0000000; #10;
        // I-Type: ANDI
        ALUOp = 2'b11; funct3 = 3'b111; funct7 = 7'b0000000; #10;
        // I-Type: ORI
        ALUOp = 2'b11; funct3 = 3'b110; funct7 = 7'b0000000; #10;
        // I-Type: XORI
        ALUOp = 2'b11; funct3 = 3'b100; funct7 = 7'b0000000; #10;
        // I-Type: SLTI
        ALUOp = 2'b11; funct3 = 3'b010; funct7 = 7'b0000000; #10;
        // I-Type: SLTIU
        ALUOp = 2'b11; funct3 = 3'b011; funct7 = 7'b0000000; #10;
        // I-Type: SLLI
        ALUOp = 2'b11; funct3 = 3'b001; funct7 = 7'b0000000; #10;
        // I-Type: SRLI
        ALUOp = 2'b11; funct3 = 3'b101; funct7 = 7'b0000000; #10;
        // I-Type: SRAI
        ALUOp = 2'b11; funct3 = 3'b101; funct7 = 7'b0100000; #10;

        #10;
        $finish;
    end

endmodule