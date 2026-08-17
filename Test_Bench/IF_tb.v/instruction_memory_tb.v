`timescale 1ns/1ps
module instruction_memory_tb;
    reg [31:0] address;
    wire [31:0] instruction;

    instruction_memory uut (
        .address(address),
        .instruction(instruction)
    );

    initial begin
        // preload memory directly (in case Memory/program.mem isn't available)
        uut.memory[0] = 32'h00500093; // addi x1, x0, 5
        uut.memory[1] = 32'h00A00113; // addi x2, x0, 10
        uut.memory[2] = 32'h002081B3; // add  x3, x1, x2
        uut.memory[3] = 32'h40208233; // sub  x4, x1, x2
        uut.memory[4] = 32'h0000006F; // jal  x0, 0

        address = 32'd0;
        #10;

        address = 32'd4;
        #10;

        address = 32'd8;
        #10;

        address = 32'd12;
        #10;

        address = 32'd16;
        #10;

        // unaligned lower bits should be ignored (byte offset within word)
        address = 32'd18;
        #10;

        #10;
        $finish;
    end
endmodule