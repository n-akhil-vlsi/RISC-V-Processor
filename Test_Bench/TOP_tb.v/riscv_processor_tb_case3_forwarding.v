`timescale 1ns/1ps
 
module riscv_processor_tb_case3_forwarding;
 
    // CASE 3: Forwarding | Start PC: 56 | Main instructions: 56-64
    // 56: add x15,x1,x2    -> x15 = 5+10 = 15
    // 60: sub x16,x15,x3   -> x15 value is forwarded and value is 15,x3 is also 15 so output is 0.  x16=0.
    // 64: add x17,x15,x16  -> x16 value is forwarded from previous and value is 0 and x15 is also forwarded and value is 15.  x17=15.
    // 68 to 80 fillers. 
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
 
        repeat (23) @(posedge clk);
 
        $finish;
    end

endmodule
 