`timescale 1ns/1ps

module register_file_tb;

    reg clk;
    reg we;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] write_data;
    wire [31:0] read_data1, read_data2;

    register_file uut (
        .clk(clk),
        .we(we),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        we = 0;
        rs1 = 0; rs2 = 0; rd = 0;
        write_data = 0;
        #10;

        // Test 1: attempt to write x0, should stay 0
        we = 1; rd = 0; write_data = 32'h11111111;
        @(posedge clk); #1;
        we = 0;
        rs1 = 0;
        #9;

        // Test 2: write x5 = 42, then read next cycle
        we = 1; rd = 5; write_data = 32'd42;
        @(posedge clk); #1;
        we = 0;
        rs1 = 5;
        #9;

        // Test 3: same-cycle write + read bypass, rd == rs1 = x10
        we = 1; rd = 10; write_data = 32'd99;
        rs1 = 10;
        #1;
        @(posedge clk); #1;
        we = 0;
        #8;

        // Test 4: write x7 and x8, then read both ports together
        we = 1; rd = 7; write_data = 32'd123;
        @(posedge clk); #1;
        we = 1; rd = 8; write_data = 32'd456;
        @(posedge clk); #1;
        we = 0;
        rs1 = 7; rs2 = 8;
        #9;

        // Test 5: no write when we=0
        we = 0; rd = 15; write_data = 32'd777;
        @(posedge clk); #1;
        rs1 = 15;
        #9;

        // Test 6: write and read x20 with a fresh distinct value
        we = 1; rd = 20; write_data = 32'd555;
        @(posedge clk); #1;
        we = 0;
        rs1 = 20;
        #10;

        $finish;
    end

endmodule