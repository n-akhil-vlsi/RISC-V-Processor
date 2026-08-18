`timescale 1ns/1ps
 
module riscv_processor_tb_case8_forward_priority;
 
    // CASE 8: Forward Priority | Start PC: 196 | Main instructions: 196-220
    // 196: addi x16,x0,5    -> instrA: x16=5
    // 200: addi x16,x0,10   -> instrB: x16=10 (WAW overwrite)
    // 204: add  x17,x16,x0  -> PRIORITY: must fwd EX/MEM(10), not MEM/WB(5)
    // 208: addi x18,x0,1    -> instrA2: x18=1
    // 212: addi x18,x0,2    -> instrB2: x18=2 (WAW overwrite)
    // 216: add  x19,x18,x18 -> PRIORITY on both operands: must use 2, not 1
 
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
 
        // run enough cycles for PC to reach 220 (55 fetches from 0),
        // plus WB latency, plus margin so x16/x17/x18/x19 fully settle
        repeat (65) @(posedge clk);
 
        $finish;
    end
 
    // waveform dump only - no $display
    initial begin
        $dumpfile("riscv_processor_tb_case8_forward_priority.vcd");
        $dumpvars(0, riscv_processor_tb_case8_forward_priority);
    end
 
endmodule