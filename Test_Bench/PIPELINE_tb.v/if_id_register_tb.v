`timescale 1ns/1ps

module if_id_register_tb;

    reg clk, reset, write_enable, flush;
    reg [31:0] pc_in, pc_next_in, instruction_in;

    wire [31:0] pc_out, pc_next_out, instruction_out;

    if_id_register uut (
        .clk(clk),
        .reset(reset),
        .write_enable(write_enable),
        .flush(flush),
        .pc_in(pc_in),
        .pc_next_in(pc_next_in),
        .instruction_in(instruction_in),
        .pc_out(pc_out),
        .pc_next_out(pc_next_out),
        .instruction_out(instruction_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1; write_enable = 0; flush = 0;
        pc_in = 0; pc_next_in = 0; instruction_in = 0;
        @(posedge clk); #1;

        // Release reset, normal write
        reset = 0; write_enable = 1; flush = 0;
        pc_in = 32'd4; pc_next_in = 32'd8; instruction_in = 32'h00500093;
        @(posedge clk); #1;

        // Another normal write
        pc_in = 32'd8; pc_next_in = 32'd12; instruction_in = 32'h00A00113;
        @(posedge clk); #1;

        // write_enable=0 -> hold previous values
        write_enable = 0;
        pc_in = 32'd12; pc_next_in = 32'd16; instruction_in = 32'hFFFFFFFF;
        @(posedge clk); #1;

        // flush=1 -> clears to 0 (NOP bubble), overrides write_enable even if 1
        write_enable = 1; flush = 1;
        pc_in = 32'd20; pc_next_in = 32'd24; instruction_in = 32'h11111111;
        @(posedge clk); #1;

        // flush released, normal write resumes
        flush = 0; write_enable = 1;
        pc_in = 32'd24; pc_next_in = 32'd28; instruction_in = 32'h00208463;
        @(posedge clk); #1;

        // mid-run reset -> clears everything regardless of flush/write_enable
        reset = 1;
        write_enable = 1; flush = 0;
        pc_in = 32'd100; pc_next_in = 32'd104; instruction_in = 32'hAAAAAAAA;
        @(posedge clk); #1;
        reset = 0;

        #10;
        $finish;
    end

endmodule