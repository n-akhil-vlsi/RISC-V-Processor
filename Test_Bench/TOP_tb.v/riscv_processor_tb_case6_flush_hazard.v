`timescale 1ns/1ps
 
module riscv_processor_tb_case6_flush_hazard;
 
    // CASE 6: Flush + Hazard | Start PC: 140 | Main instructions: 140-160
    // 140: addi x5,x0,30    -> x5 = 30 (reused reg)
    // 144: bne  x5,x6,+12   -> x5(30) != x6(1) -> branch TAKEN -> flush next 2
    // 148: addi x6,x0,111   -> SHOULD BE FLUSHED
    // 152: add  x7,x6,x6    -> SHOULD BE FLUSHED (also has hazard on x6 if not flushed)
    // 156: addi x8,x0,222   -> branch target lands here, x8=222
    // 160: add  x9,x8,x8    -> EX/MEM FORWARD: x8 used immediately after target
 
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
 
        // run enough cycles for PC to reach 160 (40 fetches from 0),
        // plus WB latency, plus extra cycles for the branch flush,
        // plus margin so x5/x6/x7/x8/x9 fully settle
        repeat (49) @(posedge clk);
 
        $finish;
    end
 

endmodule