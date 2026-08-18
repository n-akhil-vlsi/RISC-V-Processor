module instruction_memory (

    input  wire [31:0] address,
    output wire [31:0] instruction

);

    // 64 x 32-bit Instruction Memory
    reg [31:0] memory [0:63];

    initial begin
       $readmemh("E:/RISC-V-Processor-VIVADO/Memory/program.mem", memory);        //It loads the hexadecimal instructions from Memory/program.mem into the memory array when simulation starts.
    end

    assign instruction = memory[address[31:2]];     //each instruction is 4 bytes, the instructions are stored at addresses 0, 4, 8, 12, 16, .... Therefore, the lowest 2 address bits are always 00.

endmodule