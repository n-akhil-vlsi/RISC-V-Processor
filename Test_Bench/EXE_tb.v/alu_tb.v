`timescale 1ns/1ps

module alu_tb;

    reg  [31:0] A, B;
    reg  [3:0]  ALUControl;
    wire [31:0] Result;
    wire        Zero;

    alu uut (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .Result(Result),
        .Zero(Zero)
    );

    initial begin

        // ADD: 10 + 5 = 15
        A = 32'd10; B = 32'd5; ALUControl = 4'b0000; #10;

        // SUB: 10 - 10 = 0 (checks Zero flag)
        A = 32'd10; B = 32'd10; ALUControl = 4'b0001; #10;

        // SUB: 5 - 10 = -5
        A = 32'd5; B = 32'd10; ALUControl = 4'b0001; #10;

        // AND
        A = 32'hFF00FF00; B = 32'h0F0F0F0F; ALUControl = 4'b0010; #10;

        // OR
        A = 32'hFF00FF00; B = 32'h0F0F0F0F; ALUControl = 4'b0011; #10;

        // XOR
        A = 32'hFF00FF00; B = 32'h0F0F0F0F; ALUControl = 4'b0100; #10;

        // SLL: 1 << 4 = 16
        A = 32'd1; B = 32'd4; ALUControl = 4'b0101; #10;

        // SRL: 0x8000_0000 >> 4 (logical)
        A = 32'h80000000; B = 32'd4; ALUControl = 4'b0110; #10;

        // SRA: 0x8000_0000 >>> 4 (arithmetic, sign-extended)
        A = 32'h80000000; B = 32'd4; ALUControl = 4'b0111; #10;

        // SLT: -1 < 1 -> 1 (signed)
        A = 32'hFFFFFFFF; B = 32'd1; ALUControl = 4'b1000; #10;

        // SLT: 5 < 2 -> 0 (signed)
        A = 32'd5; B = 32'd2; ALUControl = 4'b1000; #10;

        // SLTU: 0xFFFFFFFF < 1 -> 0 (unsigned, since FFFFFFFF is huge)
        A = 32'hFFFFFFFF; B = 32'd1; ALUControl = 4'b1001; #10;

        // SLTU: 2 < 5 -> 1 (unsigned)
        A = 32'd2; B = 32'd5; ALUControl = 4'b1001; #10;

        // default/unsupported ALUControl
        A = 32'd7; B = 32'd3; ALUControl = 4'b1111; #10;

        #10;
        $finish;
    end

endmodule