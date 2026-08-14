module data_memory(

    input wire clk,
    input wire MemRead,
    input wire MemWrite,

    input wire [31:0] address,
    input wire [31:0] write_data,

    output wire [31:0] read_data

);

reg [31:0] memory [0:63];

// Synchronous Write
always @(posedge clk) begin

    if(MemWrite)
        memory[address[31:2]] <= write_data;                    //LSB 2 bits are ignored because they are always 0.

end

// Asynchronous Read
assign read_data = (MemRead) ? memory[address[31:2]] : 32'd0;

endmodule