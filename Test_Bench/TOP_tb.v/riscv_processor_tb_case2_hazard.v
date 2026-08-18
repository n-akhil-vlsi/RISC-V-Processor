`timescale 1ns/1ps
 
module riscv_processor_tb_case2_hazard;
 
    // CASE 2: Load-use | Start PC: 28 | Main instructions: 28-36
    // 28: sw  x1,0(x0)     -> store x1(5) to mem[0]
    // 32: lw  x9,0(x0)     -> load into x9
    // 36: add x10,x9,x2    -> LOAD-USE HAZARD: x9 used right after load, must stall
 
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
 
        // run enough cycles for PC to reach 36 (9 fetches from 0),
        // plus WB latency, plus 1 extra cycle for the load-use stall
        repeat (20) @(posedge clk);
 
        $finish;
    end

endmodule
 