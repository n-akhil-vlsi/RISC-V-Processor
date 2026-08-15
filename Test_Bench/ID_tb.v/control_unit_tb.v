`timescale 1ns/1ps

module control_unit_tb;

    reg [6:0] opcode;

    wire RegWrite, MemRead, MemWrite, ALUSrc, Branch, Jump, JALR;
    wire [1:0] ALUSrcA, ResultSrc, ALUOp;

    control_unit uut (
        .opcode(opcode),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .ALUSrcA(ALUSrcA),
        .ResultSrc(ResultSrc),
        .Branch(Branch),
        .Jump(Jump),
        .JALR(JALR),
        .ALUOp(ALUOp)
    );

    initial begin
        opcode = 7'b0000000; #10;   // default/invalid

        opcode = 7'b0110011; #10;   // R-Type
        opcode = 7'b0010011; #10;   // I-Type Arithmetic
        opcode = 7'b0000011; #10;   // LW
        opcode = 7'b0100011; #10;   // SW
        opcode = 7'b1100011; #10;   // Branch
        opcode = 7'b1101111; #10;   // JAL
        opcode = 7'b1100111; #10;   // JALR
        opcode = 7'b0110111; #10;   // LUI
        opcode = 7'b0010111; #10;   // AUIPC

        #10;
        $finish;
    end

endmodule