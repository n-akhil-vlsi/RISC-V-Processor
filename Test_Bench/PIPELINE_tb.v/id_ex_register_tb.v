`timescale 1ns/1ps
module id_ex_register_tb;
    reg clk, reset, flush;

    reg RegWrite_in, MemRead_in, MemWrite_in;
    reg [1:0] ResultSrc_in;
    reg ALUSrc_in;
    reg [1:0] ALUSrcA_in;
    reg Branch_in, Jump_in, JALR_in;
    reg [1:0] ALUOp_in;
    reg [31:0] pc_in, pc_next_in, read_data1_in, read_data2_in, immediate_in;
    reg [4:0] rs1_in, rs2_in, rd_in;
    reg [2:0] funct3_in;
    reg [6:0] funct7_in;

    wire RegWrite_out, MemRead_out, MemWrite_out;
    wire [1:0] ResultSrc_out;
    wire ALUSrc_out;
    wire [1:0] ALUSrcA_out;
    wire Branch_out, Jump_out, JALR_out;
    wire [1:0] ALUOp_out;
    wire [31:0] pc_out, pc_next_out, read_data1_out, read_data2_out, immediate_out;
    wire [4:0] rs1_out, rs2_out, rd_out;
    wire [2:0] funct3_out;
    wire [6:0] funct7_out;

    id_ex_register uut (
        .clk(clk),
        .reset(reset),
        .flush(flush),

        .RegWrite_in(RegWrite_in),
        .MemRead_in(MemRead_in),
        .MemWrite_in(MemWrite_in),
        .ResultSrc_in(ResultSrc_in),
        .ALUSrc_in(ALUSrc_in),
        .ALUSrcA_in(ALUSrcA_in),
        .Branch_in(Branch_in),
        .Jump_in(Jump_in),
        .JALR_in(JALR_in),
        .ALUOp_in(ALUOp_in),

        .pc_in(pc_in),
        .pc_next_in(pc_next_in),
        .read_data1_in(read_data1_in),
        .read_data2_in(read_data2_in),
        .immediate_in(immediate_in),

        .rs1_in(rs1_in),
        .rs2_in(rs2_in),
        .rd_in(rd_in),

        .funct3_in(funct3_in),
        .funct7_in(funct7_in),

        .RegWrite_out(RegWrite_out),
        .MemRead_out(MemRead_out),
        .MemWrite_out(MemWrite_out),
        .ResultSrc_out(ResultSrc_out),
        .ALUSrc_out(ALUSrc_out),
        .ALUSrcA_out(ALUSrcA_out),
        .Branch_out(Branch_out),
        .Jump_out(Jump_out),
        .JALR_out(JALR_out),
        .ALUOp_out(ALUOp_out),

        .pc_out(pc_out),
        .pc_next_out(pc_next_out),
        .read_data1_out(read_data1_out),
        .read_data2_out(read_data2_out),
        .immediate_out(immediate_out),

        .rs1_out(rs1_out),
        .rs2_out(rs2_out),
        .rd_out(rd_out),

        .funct3_out(funct3_out),
        .funct7_out(funct7_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1; flush = 0;
        RegWrite_in = 0; MemRead_in = 0; MemWrite_in = 0;
        ResultSrc_in = 0; ALUSrc_in = 0; ALUSrcA_in = 0;
        Branch_in = 0; Jump_in = 0; JALR_in = 0; ALUOp_in = 0;
        pc_in = 0; pc_next_in = 0; read_data1_in = 0; read_data2_in = 0; immediate_in = 0;
        rs1_in = 0; rs2_in = 0; rd_in = 0; funct3_in = 0; funct7_in = 0;
        @(posedge clk); #1;

        // Release reset, normal write
        reset = 0;
        RegWrite_in = 1; MemRead_in = 0; MemWrite_in = 1;
        ResultSrc_in = 2'b01; ALUSrc_in = 1; ALUSrcA_in = 2'b10;
        Branch_in = 1; Jump_in = 0; JALR_in = 1; ALUOp_in = 2'b11;
        pc_in = 32'd4; pc_next_in = 32'd8;
        read_data1_in = 32'hAAAA_AAAA; read_data2_in = 32'hBBBB_BBBB; immediate_in = 32'h0000_00FF;
        rs1_in = 5'd5; rs2_in = 5'd10; rd_in = 5'd15;
        funct3_in = 3'b010; funct7_in = 7'b0100000;
        @(posedge clk); #1;

        // Another normal write, different values
        RegWrite_in = 0; MemRead_in = 1; MemWrite_in = 0;
        ResultSrc_in = 2'b10; ALUSrc_in = 0; ALUSrcA_in = 2'b01;
        Branch_in = 0; Jump_in = 1; JALR_in = 0; ALUOp_in = 2'b00;
        pc_in = 32'd8; pc_next_in = 32'd12;
        read_data1_in = 32'h1111_1111; read_data2_in = 32'h2222_2222; immediate_in = 32'h0000_00AB;
        rs1_in = 5'd1; rs2_in = 5'd2; rd_in = 5'd3;
        funct3_in = 3'b000; funct7_in = 7'b0000000;
        @(posedge clk); #1;

        // flush=1 -> clears control signals only, data still passes through
        flush = 1;
        RegWrite_in = 1; MemRead_in = 1; MemWrite_in = 1;
        ResultSrc_in = 2'b11; ALUSrc_in = 1; ALUSrcA_in = 2'b11;
        Branch_in = 1; Jump_in = 1; JALR_in = 1; ALUOp_in = 2'b10;
        pc_in = 32'd20; pc_next_in = 32'd24;
        read_data1_in = 32'h3333_3333; read_data2_in = 32'h4444_4444; immediate_in = 32'h0000_00CD;
        rs1_in = 5'd7; rs2_in = 5'd8; rd_in = 5'd9;
        funct3_in = 3'b101; funct7_in = 7'b0100000;
        @(posedge clk); #1;

        // flush released, normal write resumes
        flush = 0;
        RegWrite_in = 1; MemRead_in = 0; MemWrite_in = 0;
        ResultSrc_in = 2'b00; ALUSrc_in = 0; ALUSrcA_in = 2'b00;
        Branch_in = 0; Jump_in = 0; JALR_in = 0; ALUOp_in = 2'b01;
        pc_in = 32'd24; pc_next_in = 32'd28;
        read_data1_in = 32'h5555_5555; read_data2_in = 32'h6666_6666; immediate_in = 32'h0000_00EF;
        rs1_in = 5'd11; rs2_in = 5'd12; rd_in = 5'd13;
        funct3_in = 3'b001; funct7_in = 7'b0000000;
        @(posedge clk); #1;

        // mid-run reset -> clears everything regardless of flush
        reset = 1; flush = 0;
        pc_in = 32'd100; pc_next_in = 32'd104;
        read_data1_in = 32'hAAAA_AAAA; read_data2_in = 32'hAAAA_AAAA; immediate_in = 32'hAAAA_AAAA;
        rs1_in = 5'd31; rs2_in = 5'd31; rd_in = 5'd31;
        funct3_in = 3'b111; funct7_in = 7'b1111111;
        @(posedge clk); #1;
        reset = 0;

        #10;
        $finish;
    end
endmodule