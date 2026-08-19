`timescale 1ns/1ps
   
module riscv_processor_tb_case1_normal;
 
    // TEST 1: Normal | Start PC: 0 | Main instructions: 0-24
    // (7 addi's: x1=5, x2=10, x3=15, x4=20, x6=1, x7=2, x8=3)
 
    reg clk;
    reg reset;
 
    riscv_processor dut (
        .clk   (clk),
        .reset (reset)
    );
 
    initial clk = 1'b0;
    always #5 clk = ~clk;
 
    initial begin
        reset = 1'b1;
        repeat (2) @(posedge clk);
        reset = 1'b0;
 
        repeat (11) @(posedge clk);
 
        $finish;
    end
 

 
endmodule