`timescale 1ns/1ps
 
module riscv_processor_tb_case5_branch_jump;
 
    // CASE 5: Branch/Jump | Start PC: 112 | Main instructions: 112-136
    // 112: add  x28,x1,x2    -> x28 = 15 (computed right before branch)
    // 116: beq  x28,x3,+8    -> BRANCH FORWARDING: needs x28 fwd to compare; taken
    // 120: addi x29,x0,99    -> SHOULD BE FLUSHED (branch taken skips this)
    // 124: jal  x30,+8       -> branch target; jump ahead, link x30
    // 128: addi x31,x0,88    -> SHOULD BE FLUSHED (jal skips this)
    // 132: addi x1,x0,55     -> jal target lands here, x1=55
    // 136: addi x2,x0,66     -> filler
 
    reg clk;
    reg reset;
 
    riscv_processor dut (
        .clk   (clk),
        .reset (reset)
    );
 
    // clock: 10ns period
    initial clk = 1'b0;
    always #5 clk = ~clk;
 
    initial begin
        reset = 1'b1;
        repeat (2) @(posedge clk);
        reset = 1'b0;
 
        // run enough cycles for PC to reach 136 (34 fetches from 0),
        // plus WB latency, plus a couple extra cycles for the branch/jump
        // flushes, plus margin so x28/x30/x1/x2 fully settle
        repeat (42) @(posedge clk);
 
        $finish;
    end
endmodule