`timescale 1ns/1ps
module instruction_memory_tb;
    reg  [31:0] address;
    wire [31:0] instruction;
    integer i;

    instruction_memory uut (
        .address(address),
        .instruction(instruction)
    );

    initial begin
        for (i = 0; i < 64; i = i + 1) begin
            address = i * 4;
            #10;
        end
        $finish;
    end
endmodule