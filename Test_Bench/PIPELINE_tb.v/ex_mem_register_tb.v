`timescale 1ns/1ps
module ex_mem_register_tb;
    reg clk, reset;

    reg RegWrite_in, MemRead_in, MemWrite_in;
    reg [1:0] ResultSrc_in;
    reg Branch_in, Jump_in;
    reg Zero_in;
    reg [2:0] funct3_in;
    reg [31:0] branch_target_in, alu_result_in, write_data_in, pc_next_in;
    reg [4:0] rd_in;

    wire RegWrite_out, MemRead_out, MemWrite_out;
    wire [1:0] ResultSrc_out;
    wire Branch_out, Jump_out;
    wire Zero_out;
    wire [2:0] funct3_out;
    wire [31:0] branch_target_out, alu_result_out, write_data_out, pc_next_out;
    wire [4:0] rd_out;

    ex_mem_register uut (
        .clk(clk),
        .reset(reset),

        .RegWrite_in(RegWrite_in),
        .MemRead_in(MemRead_in),
        .MemWrite_in(MemWrite_in),
        .ResultSrc_in(ResultSrc_in),
        .Branch_in(Branch_in),
        .Jump_in(Jump_in),

        .Zero_in(Zero_in),

        .funct3_in(funct3_in),

        .branch_target_in(branch_target_in),
        .alu_result_in(alu_result_in),
        .write_data_in(write_data_in),
        .pc_next_in(pc_next_in),

        .rd_in(rd_in),

        .RegWrite_out(RegWrite_out),
        .MemRead_out(MemRead_out),
        .MemWrite_out(MemWrite_out),
        .ResultSrc_out(ResultSrc_out),
        .Branch_out(Branch_out),
        .Jump_out(Jump_out),

        .Zero_out(Zero_out),

        .funct3_out(funct3_out),

        .branch_target_out(branch_target_out),
        .alu_result_out(alu_result_out),
        .write_data_out(write_data_out),
        .pc_next_out(pc_next_out),

        .rd_out(rd_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        RegWrite_in = 0; MemRead_in = 0; MemWrite_in = 0;
        ResultSrc_in = 0; Branch_in = 0; Jump_in = 0;
        Zero_in = 0; funct3_in = 0;
        branch_target_in = 0; alu_result_in = 0; write_data_in = 0; pc_next_in = 0;
        rd_in = 0;
        @(posedge clk); #1;

        // Release reset, normal write
        reset = 0;
        RegWrite_in = 1; MemRead_in = 0; MemWrite_in = 1;
        ResultSrc_in = 2'b01; Branch_in = 1; Jump_in = 0;
        Zero_in = 1; funct3_in = 3'b010;
        branch_target_in = 32'h0000_1000; alu_result_in = 32'hAAAA_AAAA;
        write_data_in = 32'hBBBB_BBBB; pc_next_in = 32'h0000_1004;
        rd_in = 5'd10;
        @(posedge clk); #1;

        // Another normal write, different values
        RegWrite_in = 0; MemRead_in = 1; MemWrite_in = 0;
        ResultSrc_in = 2'b10; Branch_in = 0; Jump_in = 1;
        Zero_in = 0; funct3_in = 3'b001;
        branch_target_in = 32'h0000_2000; alu_result_in = 32'h1111_1111;
        write_data_in = 32'h2222_2222; pc_next_in = 32'h0000_2004;
        rd_in = 5'd21;
        @(posedge clk); #1;

        // Third write
        RegWrite_in = 1; MemRead_in = 1; MemWrite_in = 1;
        ResultSrc_in = 2'b11; Branch_in = 1; Jump_in = 1;
        Zero_in = 1; funct3_in = 3'b101;
        branch_target_in = 32'h0000_3000; alu_result_in = 32'h3333_3333;
        write_data_in = 32'h4444_4444; pc_next_in = 32'h0000_3004;
        rd_in = 5'd5;
        @(posedge clk); #1;

        // mid-run reset -> clears everything regardless of inputs
        reset = 1;
        RegWrite_in = 1; MemRead_in = 1; MemWrite_in = 1;
        ResultSrc_in = 2'b11; Branch_in = 1; Jump_in = 1;
        Zero_in = 1; funct3_in = 3'b111;
        branch_target_in = 32'hAAAA_AAAA; alu_result_in = 32'hAAAA_AAAA;
        write_data_in = 32'hAAAA_AAAA; pc_next_in = 32'hAAAA_AAAA;
        rd_in = 5'd31;
        @(posedge clk); #1;
        reset = 0;   

        // resume normal write after reset
        RegWrite_in = 1; MemRead_in = 0; MemWrite_in = 0;
        ResultSrc_in = 2'b00; Branch_in = 0; Jump_in = 0;
        Zero_in = 0; funct3_in = 3'b000;
        branch_target_in = 32'h0000_5000; alu_result_in = 32'h5555_5555;
        write_data_in = 32'h6666_6666; pc_next_in = 32'h0000_5004;
        rd_in = 5'd7;
        @(posedge clk); #1;

        #10;
        $finish;
    end
endmodule