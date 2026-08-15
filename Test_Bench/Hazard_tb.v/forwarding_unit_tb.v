`timescale 1ns/1ps

module forwarding_unit_tb;

    reg EX_MEM_RegWrite, MEM_WB_RegWrite;
    reg [4:0] EX_MEM_rd, MEM_WB_rd;
    reg [4:0] ID_EX_rs1, ID_EX_rs2;

    wire [1:0] ForwardA, ForwardB;

    forwarding_unit uut (
        .EX_MEM_RegWrite(EX_MEM_RegWrite),
        .EX_MEM_rd(EX_MEM_rd),
        .MEM_WB_RegWrite(MEM_WB_RegWrite),
        .MEM_WB_rd(MEM_WB_rd),
        .ID_EX_rs1(ID_EX_rs1),
        .ID_EX_rs2(ID_EX_rs2),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );

    initial begin

        // No hazard: everything 0, no forwarding
        EX_MEM_RegWrite=0; EX_MEM_rd=5'd0; MEM_WB_RegWrite=0; MEM_WB_rd=5'd0;
        ID_EX_rs1=5'd1; ID_EX_rs2=5'd2; #10;

        // EX/MEM hazard on rs1 -> ForwardA = 10
        EX_MEM_RegWrite=1; EX_MEM_rd=5'd1; MEM_WB_RegWrite=0; MEM_WB_rd=5'd0;
        ID_EX_rs1=5'd1; ID_EX_rs2=5'd2; #10;

        // EX/MEM hazard on rs2 -> ForwardB = 10
        EX_MEM_RegWrite=1; EX_MEM_rd=5'd2; MEM_WB_RegWrite=0; MEM_WB_rd=5'd0;
        ID_EX_rs1=5'd1; ID_EX_rs2=5'd2; #10;

        // MEM/WB hazard on rs1 -> ForwardA = 01
        EX_MEM_RegWrite=0; EX_MEM_rd=5'd0; MEM_WB_RegWrite=1; MEM_WB_rd=5'd3;
        ID_EX_rs1=5'd3; ID_EX_rs2=5'd4; #10;

        // MEM/WB hazard on rs2 -> ForwardB = 01
        EX_MEM_RegWrite=0; EX_MEM_rd=5'd0; MEM_WB_RegWrite=1; MEM_WB_rd=5'd4;
        ID_EX_rs1=5'd3; ID_EX_rs2=5'd4; #10;

        // Both hazards present on rs1 -> EX/MEM (10) takes priority over MEM/WB (01)
        EX_MEM_RegWrite=1; EX_MEM_rd=5'd6; MEM_WB_RegWrite=1; MEM_WB_rd=5'd6;
        ID_EX_rs1=5'd6; ID_EX_rs2=5'd8; #10;

        // Both hazards present on rs2 -> EX/MEM (10) takes priority over MEM/WB (01)
        EX_MEM_RegWrite=1; EX_MEM_rd=5'd8; MEM_WB_RegWrite=1; MEM_WB_rd=5'd8;
        ID_EX_rs1=5'd6; ID_EX_rs2=5'd8; #10;

        // rd = x0 case: even if it "matches", must NOT forward
        EX_MEM_RegWrite=1; EX_MEM_rd=5'd0; MEM_WB_RegWrite=1; MEM_WB_rd=5'd0;
        ID_EX_rs1=5'd0; ID_EX_rs2=5'd0; #10;

        // RegWrite=0 but rd matches -> must NOT forward
        EX_MEM_RegWrite=0; EX_MEM_rd=5'd9; MEM_WB_RegWrite=0; MEM_WB_rd=5'd9;
        ID_EX_rs1=5'd9; ID_EX_rs2=5'd9; #10;

        #10;
        $finish;
    end

endmodule