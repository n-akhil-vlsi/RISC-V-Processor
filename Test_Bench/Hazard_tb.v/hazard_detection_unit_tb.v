`timescale 1ns/1ps

module hazard_detection_unit_tb;

    reg  ID_EX_MemRead;
    reg  [4:0] ID_EX_rd;
    reg  [4:0] IF_ID_rs1, IF_ID_rs2;

    wire PCWrite, IF_ID_Write, ControlMux;

    hazard_detection_unit uut (
        .ID_EX_MemRead(ID_EX_MemRead),
        .ID_EX_rd(ID_EX_rd),
        .IF_ID_rs1(IF_ID_rs1),
        .IF_ID_rs2(IF_ID_rs2),
        .PCWrite(PCWrite),
        .IF_ID_Write(IF_ID_Write),
        .ControlMux(ControlMux)
    );

    initial begin

        // No load in EX -> no stall regardless of matching regs
        ID_EX_MemRead = 0; ID_EX_rd = 5'd5; IF_ID_rs1 = 5'd5; IF_ID_rs2 = 5'd3; #10;

        // Load in EX, but rd doesn't match rs1/rs2 -> no stall
        ID_EX_MemRead = 1; ID_EX_rd = 5'd5; IF_ID_rs1 = 5'd1; IF_ID_rs2 = 5'd2; #10;

        // Load in EX, rd matches rs1 -> stall
        ID_EX_MemRead = 1; ID_EX_rd = 5'd5; IF_ID_rs1 = 5'd5; IF_ID_rs2 = 5'd2; #10;

        // Load in EX, rd matches rs2 -> stall
        ID_EX_MemRead = 1; ID_EX_rd = 5'd7; IF_ID_rs1 = 5'd2; IF_ID_rs2 = 5'd7; #10;

        // Load in EX, rd matches both rs1 and rs2 -> stall
        ID_EX_MemRead = 1; ID_EX_rd = 5'd9; IF_ID_rs1 = 5'd9; IF_ID_rs2 = 5'd9; #10;

        // Edge case: rd = x0, even if "matching" -> real processors don't stall on x0,
        ID_EX_MemRead = 1; ID_EX_rd = 5'd0; IF_ID_rs1 = 5'd0; IF_ID_rs2 = 5'd3; #10;

        // Back to no-load -> stall clears
        ID_EX_MemRead = 0; ID_EX_rd = 5'd9; IF_ID_rs1 = 5'd9; IF_ID_rs2 = 5'd9; #10;

        #10;
        $finish;
    end

endmodule