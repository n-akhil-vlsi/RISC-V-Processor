module mem_wb_register(

    input wire clk,
    input wire reset,

    input wire RegWrite_in,
    input wire MemtoReg_in,

    input wire [31:0] read_data_in,
    input wire [31:0] alu_result_in,

    input wire [4:0] rd_in,

    output reg RegWrite_out,
    output reg MemtoReg_out,

    output reg [31:0] read_data_out,
    output reg [31:0] alu_result_out,

    output reg [4:0] rd_out

);

always @(posedge clk or posedge reset) begin

    if(reset) begin

        RegWrite_out <= 1'b0;
        MemtoReg_out <= 1'b0;

        read_data_out <= 32'd0;
        alu_result_out <= 32'd0;

        rd_out <= 5'd0;

    end
    else begin

        RegWrite_out <= RegWrite_in;
        MemtoReg_out <= MemtoReg_in;

        read_data_out <= read_data_in;
        alu_result_out <= alu_result_in;

        rd_out <= rd_in;

    end

end

endmodule