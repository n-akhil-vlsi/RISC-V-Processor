`timescale 1ns/1ps
 
module riscv_processor_tb_case4_stall_forwarding;
 
    // CASE 4: Stall + Forwarding | Start PC: 84 | Main instructions: 84-96
    // 84: sw  x2,4(x0)      -> store x2(10) to mem[1]
    // 88: lw  x22,4(x0)     -> load into x22
    // 92: add x23,x22,x3    -> LOAD-USE HAZARD: x22 used immediately -> stall
    // 96: sub x24,x23,x22   -> EX/MEM fwd x23 + MEM/WB fwd x22
 
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
 
        // run enough cycles for PC to reach 96 (25 fetches from 0),
        // plus WB latency, plus 1 extra cycle for the load-use stall,
        // plus margin so x23/x24 fully settle in the register file
        repeat (31) @(posedge clk);
 
        $finish;
    end 
endmodule
 