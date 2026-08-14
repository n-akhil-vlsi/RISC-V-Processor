module mem_wb_register(

    input wire clk,
    input wire reset,

    input wire RegWrite_in,
    input wire [1:0] ResultSrc_in,   // MODIFIED: was MemtoReg_in (1-bit)

    input wire [31:0] read_data_in,
    input wire [31:0] alu_result_in,
    input wire [31:0] pc_next_in,    // NEW: PC+4, for JAL/JALR link value

    input wire [4:0] rd_in,

    output reg RegWrite_out,
    output reg [1:0] ResultSrc_out,  // MODIFIED

    output reg [31:0] read_data_out,
    output reg [31:0] alu_result_out,
    output reg [31:0] pc_next_out,   // NEW

    output reg [4:0] rd_out

);

always @(posedge clk or posedge reset) begin

    if(reset) begin

        RegWrite_out <= 1'b0;
        ResultSrc_out <= 2'b00;

        read_data_out <= 32'd0;
        alu_result_out <= 32'd0;
        pc_next_out <= 32'd0;

        rd_out <= 5'd0;

    end
    else begin

        RegWrite_out <= RegWrite_in;
        ResultSrc_out <= ResultSrc_in;

        read_data_out <= read_data_in;
        alu_result_out <= alu_result_in;
        pc_next_out <= pc_next_in;

        rd_out <= rd_in;

    end

end

endmodule