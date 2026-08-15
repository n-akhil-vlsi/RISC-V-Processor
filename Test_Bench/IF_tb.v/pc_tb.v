`timescale 1ns/1ps

module pc_tb;

    reg clk;
    reg reset;
    reg PCWrite;
    reg [31:0] pc_next;
    wire [31:0] pc;

    pc uut (
        .clk(clk),
        .reset(reset),
        .PCWrite(PCWrite),
        .pc_next(pc_next),
        .pc(pc)
    );

    // clock: 10ns period
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        PCWrite = 0;
        pc_next = 32'h0000_0000;

        // Test 1: reset holds pc at 0
        @(posedge clk);
        #1;
        if (pc !== 32'h0) $display("FAIL: reset did not clear pc, pc=%h", pc);
        else $display("PASS: reset -> pc=%h", pc);

        // release reset
        reset = 0;

        // Test 2: PCWrite=0 -> pc must hold
        pc_next = 32'h0000_0004;
        PCWrite = 0;
        @(posedge clk);
        #1;
        if (pc !== 32'h0) $display("FAIL: pc changed while PCWrite=0, pc=%h", pc);
        else $display("PASS: stall held pc=%h", pc);

        // Test 3: PCWrite=1 -> pc updates to pc_next
        PCWrite = 1;
        pc_next = 32'h0000_0004;
        @(posedge clk);
        #1;
        if (pc !== 32'h0000_0004) $display("FAIL: pc did not update, pc=%h", pc);
        else $display("PASS: pc updated -> pc=%h", pc);

        // Test 4: sequential update
        pc_next = 32'h0000_0008;
        @(posedge clk);
        #1;
        if (pc !== 32'h0000_0008) $display("FAIL: sequential update failed, pc=%h", pc);
        else $display("PASS: pc=%h", pc);

        // Test 5: mid-run reset
        reset = 1;
        @(posedge clk);
        #1;
        if (pc !== 32'h0) $display("FAIL: mid-run reset failed, pc=%h", pc);
        else $display("PASS: mid-run reset -> pc=%h", pc);
        reset = 0;

        $display("Testbench complete.");
        $finish;
    end

    initial begin
        $dumpfile("pc_tb.vcd");
        $dumpvars(0, pc_tb);
    end

endmodule