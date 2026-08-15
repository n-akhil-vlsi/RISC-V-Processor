`timescale 1ns/1ps

module branch_unit_tb;

    reg Branch, Jump, JALR, Zero;
    reg [2:0] funct3;
    reg [31:0] pc, rs1, immediate;

    wire PCSrc;
    wire [31:0] branch_target;

    branch_unit uut (
        .Branch(Branch),
        .Jump(Jump),
        .JALR(JALR),
        .Zero(Zero),
        .funct3(funct3),
        .pc(pc),
        .rs1(rs1),
        .immediate(immediate),
        .PCSrc(PCSrc),
        .branch_target(branch_target)
    );

    initial begin

        pc = 32'd100; rs1 = 32'd0; immediate = 32'd8;

        // BEQ, condition true (Zero=1) -> taken
        Branch=1; Jump=0; JALR=0; funct3=3'b000; Zero=1; #10;

        // BEQ, condition false (Zero=0) -> not taken
        Branch=1; Jump=0; JALR=0; funct3=3'b000; Zero=0; #10;

        // BNE, condition true (Zero=0) -> taken
        Branch=1; Jump=0; JALR=0; funct3=3'b001; Zero=0; #10;

        // BNE, condition false (Zero=1) -> not taken
        Branch=1; Jump=0; JALR=0; funct3=3'b001; Zero=1; #10;

        // BLT, taken (Zero=0)
        Branch=1; Jump=0; JALR=0; funct3=3'b100; Zero=0; #10;

        // BGE, taken (Zero=1)
        Branch=1; Jump=0; JALR=0; funct3=3'b101; Zero=1; #10;

        // BLTU, taken (Zero=0)
        Branch=1; Jump=0; JALR=0; funct3=3'b110; Zero=0; #10;

        // BGEU, taken (Zero=1)
        Branch=1; Jump=0; JALR=0; funct3=3'b111; Zero=1; #10;

        // Branch=0 -> PCSrc must be 0 regardless of condition
        Branch=0; Jump=0; JALR=0; funct3=3'b000; Zero=1; #10;

        // JAL: Jump=1 -> PCSrc=1 unconditionally, target = pc + immediate
        Branch=0; Jump=1; JALR=0; funct3=3'b000; Zero=0;
        pc = 32'd200; immediate = 32'd16; #10;

        // JALR: target = (rs1 + immediate) & ~1, PCSrc=1
        Branch=0; Jump=1; JALR=1; funct3=3'b000; Zero=0;
        rs1 = 32'd50; immediate = 32'd5;   // 55 -> odd, LSB must be cleared
        #10;

        #10;
        $finish;
    end

endmodule