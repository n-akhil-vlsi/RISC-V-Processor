`timescale 1ns/1ps
 
module riscv_processor_tb_case4_stall_forwarding;
 
    // CASE 4: Stall + Forwarding | Start PC: 84 | Main instructions: 84-96
    // 84: sw  x2,4(x0)      -> store x2(10) to mem[1]
    // 88: lw  x22,4(x0)     -> load into x22
    // 92: add x23,x22,x3    -> Hazard detection happens and it stalls the IF/ID ,the stalls happens becz of lw and add and then forwarding of the data happens. 
    // 96: sub x24,x23,x22   -> forwarding of data happens,due to the add and sub instructions.
    //100 to 108 fillers.


    //here the stall and forwarding happens between the lw and add 
    //forwarding also happens between add and sub
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
 
        repeat (31) @(posedge clk);
 
        $finish;
    end 
endmodule
 