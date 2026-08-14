module ex_mem_register(

    input wire clk,
    input wire reset,

    input wire RegWrite_in,
    input wire MemRead_in,
    input wire MemWrite_in,
    input wire MemtoReg_in,
    input wire Branch_in,
    input wire Jump_in,

    input wire Zero_in,

    input wire [31:0] branch_target_in,
    input wire [31:0] alu_result_in,
    input wire [31:0] write_data_in,

    input wire [4:0] rd_in,

    output reg RegWrite_out,
    output reg MemRead_out,
    output reg MemWrite_out,
    output reg MemtoReg_out,
    output reg Branch_out,
    output reg Jump_out,

    output reg Zero_out,

    output reg [31:0] branch_target_out,
    output reg [31:0] alu_result_out,
    output reg [31:0] write_data_out,

    output reg [4:0] rd_out

);

always @(posedge clk or posedge reset) begin

    if(reset) begin

        RegWrite_out <= 0;
        MemRead_out <= 0;
        MemWrite_out <= 0;
        MemtoReg_out <= 0;
        Branch_out <= 0;
        Jump_out <= 0;

        Zero_out <= 0;

        branch_target_out <= 32'd0;
        alu_result_out <= 32'd0;
        write_data_out <= 32'd0;

        rd_out <= 5'd0;

    end

    else begin

        RegWrite_out <= RegWrite_in;
        MemRead_out <= MemRead_in;
        MemWrite_out <= MemWrite_in;
        MemtoReg_out <= MemtoReg_in;
        Branch_out <= Branch_in;
        Jump_out <= Jump_in;

        Zero_out <= Zero_in;

        branch_target_out <= branch_target_in;
        alu_result_out <= alu_result_in;
        write_data_out <= write_data_in;

        rd_out <= rd_in;

    end

end

endmodule