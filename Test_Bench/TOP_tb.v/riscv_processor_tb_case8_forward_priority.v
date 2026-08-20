`timescale 1ns/1ps
 
module riscv_processor_tb_case8_forward_priority;
 
    // CASE 8: Forward Priority | Start PC: 196 | Main instructions: 196-220
    // 196: addi x16,x0,5    -> instrA: x16=5
    // 200: addi x16,x0,10   -> instrB: x16=10 (WAW overwrite)
    // 204: add  x17,x16,x0  -> PRIORITY: it must fwd the latest value that is from the  EX/MEM(10), not MEM/WB(5)           x17=10.
    // 208: addi x18,x0,1    -> instrA2: x18=1
    // 212: addi x18,x0,2    -> instrB2: x18=2 (WAW overwrite)
    // 216: add  x19,x18,x18 -> PRIORITY on both operands: must use the value from the 212 instruction the (latest value).   x19=2+2=4.
 
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

        repeat (65) @(posedge clk);
 
        $finish;
    end
 
endmodule