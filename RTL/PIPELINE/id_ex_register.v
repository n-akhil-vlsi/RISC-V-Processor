module id_ex_register(

    input wire clk,
    input wire reset,
    input wire flush,     //if flush takes place then think it as the instruction with no life passing through each registers and modules.             

    input wire RegWrite_in,
    input wire MemRead_in,
    input wire MemWrite_in,
    input wire [1:0] ResultSrc_in,
    input wire ALUSrc_in,
    input wire [1:0] ALUSrcA_in,
    input wire Branch_in,
    input wire Jump_in,
    input wire JALR_in,
    input wire [1:0] ALUOp_in,

    input wire [31:0] pc_in,
    input wire [31:0] pc_next_in,
    input wire [31:0] read_data1_in,
    input wire [31:0] read_data2_in,
    input wire [31:0] immediate_in,

    input wire [4:0] rs1_in,
    input wire [4:0] rs2_in,
    input wire [4:0] rd_in,

    input wire [2:0] funct3_in,
    input wire [6:0] funct7_in,

    output reg RegWrite_out,
    output reg MemRead_out,
    output reg MemWrite_out,
    output reg [1:0] ResultSrc_out,
    output reg ALUSrc_out,
    output reg [1:0] ALUSrcA_out,
    output reg Branch_out,
    output reg Jump_out,
    output reg JALR_out,
    output reg [1:0] ALUOp_out,

    output reg [31:0] pc_out,
    output reg [31:0] pc_next_out,
    output reg [31:0] read_data1_out,
    output reg [31:0] read_data2_out,
    output reg [31:0] immediate_out,

    output reg [4:0] rs1_out,
    output reg [4:0] rs2_out,
    output reg [4:0] rd_out,

    output reg [2:0] funct3_out,
    output reg [6:0] funct7_out

);

always @(posedge clk or posedge reset) begin

    if(reset) begin

        RegWrite_out <= 0;
        MemRead_out <= 0;
        MemWrite_out <= 0;
        ResultSrc_out <= 2'b00;
        ALUSrc_out <= 0;
        ALUSrcA_out <= 2'b00;
        Branch_out <= 0;
        Jump_out <= 0;
        JALR_out <= 0;
        ALUOp_out <= 2'b00;

        pc_out <= 32'd0;
        pc_next_out <= 32'd0;

        read_data1_out <= 32'd0;
        read_data2_out <= 32'd0;

        immediate_out <= 32'd0;

        rs1_out <= 5'd0;
        rs2_out <= 5'd0;
        rd_out <= 5'd0;

        funct3_out <= 3'd0;
        funct7_out <= 7'd0;

    end

    else if(flush) begin                 //bubble — zero control signals only
                                         //making the control signals 0 means removing the instruction from the datapath just adding the bubble(NOP).
        RegWrite_out <= 0;               //no need of making every signal 0 if we make control signals 0 then the instruction will not work.
        MemRead_out <= 0;
        MemWrite_out <= 0;
        ResultSrc_out <= 2'b00;
        ALUSrc_out <= 0;
        ALUSrcA_out <= 2'b00;
        Branch_out <= 0;
        Jump_out <= 0;
        JALR_out <= 0;
        ALUOp_out <= 2'b00;

        pc_out <= pc_in;
        pc_next_out <= pc_next_in;

        read_data1_out <= read_data1_in;
        read_data2_out <= read_data2_in;

        immediate_out <= immediate_in;

        rs1_out <= rs1_in;
        rs2_out <= rs2_in;
        rd_out <= rd_in;

        funct3_out <= funct3_in;
        funct7_out <= funct7_in;

    end

    else begin

        RegWrite_out <= RegWrite_in;
        MemRead_out <= MemRead_in;
        MemWrite_out <= MemWrite_in;
        ResultSrc_out <= ResultSrc_in;
        ALUSrc_out <= ALUSrc_in;
        ALUSrcA_out <= ALUSrcA_in;
        Branch_out <= Branch_in;
        Jump_out <= Jump_in;
        JALR_out <= JALR_in;
        ALUOp_out <= ALUOp_in;

        pc_out <= pc_in;
        pc_next_out <= pc_next_in;

        read_data1_out <= read_data1_in;
        read_data2_out <= read_data2_in;

        immediate_out <= immediate_in;

        rs1_out <= rs1_in;
        rs2_out <= rs2_in;
        rd_out <= rd_in;

        funct3_out <= funct3_in;
        funct7_out <= funct7_in;

    end

end

endmodule