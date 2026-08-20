`timescale 1ns/1ps
 
module riscv_processor_tb_case9_reset;
 
    // CASE 9: Reset | Start PC: 224 | Main instructions: 224-252
    // 224: addi x21,x0,1    -> pre-reset sequential instr,RD will be updated
    // 228: addi x22,x0,2    -> same as above
    // 232: addi x23,x0,3    -> same as above
    // 236: addi x24,x0,4    -> Here the RD will not be updated becz RESET is applied at the middle of the instruction.When the reset is asseted then all the in-flight will be killed.
    // 240: addi x25,x0,5    -> reset is applied when the instruction is not reached WB state so the RD will not be updated,Due to RESET this instruction will get killed.
    // 244: addi x26,x0,6    -> same as above
    // 248: addi x27,x0,7    -> same as above
    // 252: addi x28,x0,8    -> reset is applied here,so the instructions which are in-flight are killed,same BEHAVIOUR as FLUSH.

    //A reset in the middle of pipeline execution clears all in-flight instructions and restarts the pipeline from PC = 0, without corrupting already-committed register values.
    
    //The behaviour of the RESET and the FLUSH is similar .RESET clears the entire Processor,so all the instructions which are in-flight will be killed and will not be executed.

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
 
        wait (dut.pc == 32'd236);
 
        repeat (4) @(posedge clk);
        reset = 1'b1;
        repeat (2) @(posedge clk);
        reset = 1'b0;

        repeat (20) @(posedge clk);
 
        $finish;
    end
 
endmodule