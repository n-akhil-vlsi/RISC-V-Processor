`timescale 1ns/1ps
module data_memory_tb;
    reg clk;
    reg MemRead, MemWrite;
    reg [2:0] funct3;
    reg [31:0] address, write_data;
    wire [31:0] read_data;
    data_memory uut (
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .funct3(funct3),
        .address(address),
        .write_data(write_data),
        .read_data(read_data)
    );
    always #5 clk = ~clk;
    initial begin
        clk = 0;
        MemRead = 0; MemWrite = 0;
        funct3 = 0; address = 0; write_data = 0;
        #10;
        // Store Word at word 0, then Load Word back
        MemWrite = 1; funct3 = 3'b010; address = 32'd0; write_data = 32'hABCD1234;
        @(posedge clk); #1;
        MemWrite = 0; MemRead = 1; funct3 = 3'b010; address = 32'd0;
        #9;
        // Store Byte at word 1, byte offset 0
        MemRead = 0; MemWrite = 1; funct3 = 3'b000; address = 32'd4; write_data = 32'h000000AA;
        @(posedge clk); #1;
        MemWrite = 0;
        // Load Byte signed (0xAA -> sign-extends to negative since bit7=1)
        MemRead = 1; funct3 = 3'b000; address = 32'd4;
        #9;
        // Load Byte unsigned (0xAA -> zero-extends, stays positive)
        funct3 = 3'b100; address = 32'd4;
        #9;
        // Store Byte at word 1, byte offset 1
        MemRead = 0; MemWrite = 1; funct3 = 3'b000; address = 32'd5; write_data = 32'h0000007F;
        @(posedge clk); #1;
        MemWrite = 0;
        // Load Byte signed at offset 1 (0x7F -> positive, MSB=0)
        MemRead = 1; funct3 = 3'b000; address = 32'd5;
        #9;
        // Store Half-word at word 2, offset 0 (lower half)
        MemRead = 0; MemWrite = 1; funct3 = 3'b001; address = 32'd8; write_data = 32'h0000FACE;
        @(posedge clk); #1;
        MemWrite = 0;
        // Load Half-word signed (0xFACE -> negative, bit15=1)
        MemRead = 1; funct3 = 3'b001; address = 32'd8;
        #9;
        // Load Half-word unsigned (0xFACE -> zero-extended, positive)
        funct3 = 3'b101; address = 32'd8;
        #9;
        // Store Half-word at word 2, offset 2 (upper half)
        MemRead = 0; MemWrite = 1; funct3 = 3'b001; address = 32'd10; write_data = 32'h00001234;
        @(posedge clk); #1;
        MemWrite = 0;
        // Load Half-word signed at upper half (0x1234 -> positive)
        MemRead = 1; funct3 = 3'b001; address = 32'd10;
        #9;
        // MemRead = 0 -> read_data must be 0
        MemRead = 0; address = 32'd0; funct3 = 3'b010;
        #9;
        #10;
        $finish;
    end
endmodule