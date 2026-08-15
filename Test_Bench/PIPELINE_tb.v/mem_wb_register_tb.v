`timescale 1ns/1ps
module mem_wb_register_tb;
    reg clk, reset;

    reg RegWrite_in;
    reg [1:0] ResultSrc_in;
    reg [31:0] read_data_in, alu_result_in, pc_next_in;
    reg [4:0] rd_in;

    wire RegWrite_out;
    wire [1:0] ResultSrc_out;
    wire [31:0] read_data_out, alu_result_out, pc_next_out;
    wire [4:0] rd_out;

    mem_wb_register uut (
        .clk(clk),
        .reset(reset),

        .RegWrite_in(RegWrite_in),
        .ResultSrc_in(ResultSrc_in),

        .read_data_in(read_data_in),
        .alu_result_in(alu_result_in),
        .pc_next_in(pc_next_in),

        .rd_in(rd_in),

        .RegWrite_out(RegWrite_out),
        .ResultSrc_out(ResultSrc_out),

        .read_data_out(read_data_out),
        .alu_result_out(alu_result_out),
        .pc_next_out(pc_next_out),

        .rd_out(rd_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        RegWrite_in = 0; ResultSrc_in = 0;
        read_data_in = 0; alu_result_in = 0; pc_next_in = 0;
        rd_in = 0;
        @(posedge clk); #1;

        // Release reset, normal write
        reset = 0;
        RegWrite_in = 1; ResultSrc_in = 2'b01;
        read_data_in = 32'hAAAA_AAAA; alu_result_in = 32'hBBBB_BBBB; pc_next_in = 32'h0000_1004;
        rd_in = 5'd10;
        @(posedge clk); #1;

        // Another normal write, different values
        RegWrite_in = 0; ResultSrc_in = 2'b10;
        read_data_in = 32'h1111_1111; alu_result_in = 32'h2222_2222; pc_next_in = 32'h0000_2004;
        rd_in = 5'd21;
        @(posedge clk); #1;

        // Third write
        RegWrite_in = 1; ResultSrc_in = 2'b11;
        read_data_in = 32'h3333_3333; alu_result_in = 32'h4444_4444; pc_next_in = 32'h0000_3004;
        rd_in = 5'd5;
        @(posedge clk); #1;

        // mid-run reset -> clears everything regardless of inputs
        reset = 1;
        RegWrite_in = 1; ResultSrc_in = 2'b11;
        read_data_in = 32'hAAAA_AAAA; alu_result_in = 32'hAAAA_AAAA; pc_next_in = 32'hAAAA_AAAA;
        rd_in = 5'd31;
        @(posedge clk); #1;
        reset = 0;

        // resume normal write after reset
        RegWrite_in = 1; ResultSrc_in = 2'b00;
        read_data_in = 32'h5555_5555; alu_result_in = 32'h6666_6666; pc_next_in = 32'h0000_5004;
        rd_in = 5'd7;
        @(posedge clk); #1;

        #10;
        $finish;
    end
endmodule