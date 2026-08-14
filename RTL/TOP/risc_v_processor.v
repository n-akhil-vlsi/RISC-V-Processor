module riscv_processor(
    input wire clk,
    input wire reset);
// IF Stage
wire [31:0] pc;
wire [31:0] next_pc;
wire [31:0] instruction;

wire [31:0] if_id_pc;
wire [31:0] if_id_pc_next;
wire [31:0] if_id_instruction;

// Instruction Fields
wire [6:0] opcode;
wire [4:0] rs1;
wire [4:0] rs2;
wire [4:0] rd;
wire [2:0] funct3;
wire [6:0] funct7;

// ID Stage
wire [31:0] read_data1;
wire [31:0] read_data2;

wire [31:0] immediate;

wire RegWrite;
wire MemRead;
wire MemWrite;
wire MemtoReg;
wire ALUSrc;
wire Branch;
wire Jump;

wire [1:0] ALUOp;

// Hazard Detection
wire PCWrite;
wire IF_ID_Write;
wire ControlMux;

// ID/EX Pipeline Register
wire [31:0] id_ex_pc;
wire [31:0] id_ex_pc_next;

wire [31:0] id_ex_read_data1;
wire [31:0] id_ex_read_data2;

wire [31:0] id_ex_immediate;

wire [4:0] id_ex_rs1;
wire [4:0] id_ex_rs2;
wire [4:0] id_ex_rd;

wire [2:0] id_ex_funct3;
wire [6:0] id_ex_funct7;

wire id_ex_RegWrite;
wire id_ex_MemRead;
wire id_ex_MemWrite;
wire id_ex_MemtoReg;
wire id_ex_ALUSrc;
wire id_ex_Branch;
wire id_ex_Jump;

wire [1:0] id_ex_ALUOp;

// Forwarding Unit

wire [1:0] ForwardA;
wire [1:0] ForwardB;

// EX Stage

wire [31:0] alu_input1;
wire [31:0] alu_input2;

wire [31:0] forwardA_data;
wire [31:0] forwardB_data;

wire [3:0] ALUControl;

wire [31:0] alu_result;

wire Zero;
// Branch Unit

wire [31:0] branch_target;

wire PCSrc;


// EX/MEM Pipeline Register

wire [31:0] ex_mem_alu_result;
wire [31:0] ex_mem_write_data;
wire [31:0] ex_mem_branch_target;

wire ex_mem_zero;

wire [4:0] ex_mem_rd;

wire ex_mem_RegWrite;
wire ex_mem_MemRead;
wire ex_mem_MemWrite;
wire ex_mem_MemtoReg;
wire ex_mem_Branch;
wire ex_mem_Jump;

// MEM Stage

wire [31:0] memory_read_data;

// MEM/WB Pipeline Register

wire [31:0] mem_wb_read_data;
wire [31:0] mem_wb_alu_result;

wire [4:0] mem_wb_rd;

wire mem_wb_RegWrite;
wire mem_wb_MemtoReg;

// Write Back Stage

wire [31:0] write_back_data;

pc pc_inst(

    .clk(clk),
    .reset(reset),

    .PCWrite(PCWrite),

    .pc_next(next_pc),
    .pc(pc)

);
wire [31:0] pc_plus4;

assign pc_plus4 = pc + 32'd4;
assign next_pc = (PCSrc) ? branch_target : pc_plus4;

instruction_memory instruction_memory_inst(

    .address(pc),
    .instruction(instruction)

);

if_id_register if_id_register_inst(

    .clk(clk),
    .reset(reset),

    .write_enable(IF_ID_Write),

    .pc_in(pc),
    .pc_next_in(pc_plus4),
    .instruction_in(instruction),

    .pc_out(if_id_pc),
    .pc_next_out(if_id_pc_next),
    .instruction_out(if_id_instruction)

);

assign opcode = if_id_instruction[6:0];

assign rd = if_id_instruction[11:7];

assign funct3 = if_id_instruction[14:12];

assign rs1 = if_id_instruction[19:15];

assign rs2 = if_id_instruction[24:20];

assign funct7 = if_id_instruction[31:25];

// Control Unit

control_unit control_unit_inst(

    .opcode(opcode),

    .RegWrite(RegWrite),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .MemtoReg(MemtoReg),
    .Branch(Branch),
    .Jump(Jump),
    .ALUOp(ALUOp)

);

// Immediate Generator

immediate_generator immediate_generator_inst(

    .instruction(if_id_instruction),
    .immediate(immediate)

);

// Register File

register_file register_file_inst(

    .clk(clk),
    .we(mem_wb_RegWrite),

    .rs1(rs1),
    .rs2(rs2),
    .rd(mem_wb_rd),

    .write_data(write_back_data),

    .read_data1(read_data1),
    .read_data2(read_data2)

);

// Hazard Detection Unit

hazard_detection_unit hazard_detection_unit_inst(

    .ID_EX_MemRead(id_ex_MemRead),
    .ID_EX_rd(id_ex_rd),

    .IF_ID_rs1(rs1),
    .IF_ID_rs2(rs2),

    .PCWrite(PCWrite),
    .IF_ID_Write(IF_ID_Write),
    .ControlMux(ControlMux)

);

// ID/EX Pipeline Register

id_ex_register id_ex_register_inst(

    .clk(clk),
    .reset(reset),

    .RegWrite_in(ControlMux ? 1'b0 : RegWrite),
    .MemRead_in(ControlMux ? 1'b0 : MemRead),
    .MemWrite_in(ControlMux ? 1'b0 : MemWrite),
    .MemtoReg_in(ControlMux ? 1'b0 : MemtoReg),
    .ALUSrc_in(ControlMux ? 1'b0 : ALUSrc),
    .Branch_in(ControlMux ? 1'b0 : Branch),
    .Jump_in(ControlMux ? 1'b0 : Jump),
    .ALUOp_in(ControlMux ? 2'b00 : ALUOp),

    .pc_in(if_id_pc),
    .pc_next_in(if_id_pc_next),

    .read_data1_in(read_data1),
    .read_data2_in(read_data2),

    .immediate_in(immediate),

    .rs1_in(rs1),
    .rs2_in(rs2),
    .rd_in(rd),

    .funct3_in(funct3),
    .funct7_in(funct7),

    .RegWrite_out(id_ex_RegWrite),
    .MemRead_out(id_ex_MemRead),
    .MemWrite_out(id_ex_MemWrite),
    .MemtoReg_out(id_ex_MemtoReg),
    .ALUSrc_out(id_ex_ALUSrc),
    .Branch_out(id_ex_Branch),
    .Jump_out(id_ex_Jump),
    .ALUOp_out(id_ex_ALUOp),

    .pc_out(id_ex_pc),
    .pc_next_out(id_ex_pc_next),

    .read_data1_out(id_ex_read_data1),
    .read_data2_out(id_ex_read_data2),

    .immediate_out(id_ex_immediate),

    .rs1_out(id_ex_rs1),
    .rs2_out(id_ex_rs2),
    .rd_out(id_ex_rd),

    .funct3_out(id_ex_funct3),
    .funct7_out(id_ex_funct7)

);

// Forwarding Unit

forwarding_unit forwarding_unit_inst(

    .EX_MEM_RegWrite(ex_mem_RegWrite),
    .EX_MEM_rd(ex_mem_rd),

    .MEM_WB_RegWrite(mem_wb_RegWrite),
    .MEM_WB_rd(mem_wb_rd),

    .ID_EX_rs1(id_ex_rs1),
    .ID_EX_rs2(id_ex_rs2),

    .ForwardA(ForwardA),
    .ForwardB(ForwardB)

);

// ALU Control

alu_control alu_control_inst(

    .ALUOp(id_ex_ALUOp),
    .funct3(id_ex_funct3),
    .funct7(id_ex_funct7),

    .ALUControl(ALUControl)

);
assign forwardA_data =
        (ForwardA == 2'b00) ? id_ex_read_data1 :
        (ForwardA == 2'b10) ? ex_mem_alu_result :
        (ForwardA == 2'b01) ? write_back_data :
                              id_ex_read_data1;

assign alu_input1 = forwardA_data;

assign forwardB_data =
        (ForwardB == 2'b00) ? id_ex_read_data2 :
        (ForwardB == 2'b10) ? ex_mem_alu_result :
        (ForwardB == 2'b01) ? write_back_data :
                              id_ex_read_data2;

assign alu_input2 =
        (id_ex_ALUSrc) ?
        id_ex_immediate :
        forwardB_data;
                    
//ALU

alu alu_inst(

    .A(alu_input1),
    .B(alu_input2),

    .ALUControl(ALUControl),

    .Result(alu_result),
    .Zero(Zero)

);

// Branch Unit

branch_unit branch_unit_inst(

    .Branch(id_ex_Branch),
    .Jump(id_ex_Jump),

    .Zero(Zero),

    .pc(id_ex_pc),
    .immediate(id_ex_immediate),

    .branch_target(branch_target),
    .PCSrc(PCSrc)

);

// EX/MEM Pipeline Register

ex_mem_register ex_mem_register_inst(

    .clk(clk),
    .reset(reset),

    .RegWrite_in(id_ex_RegWrite),
    .MemRead_in(id_ex_MemRead),
    .MemWrite_in(id_ex_MemWrite),
    .MemtoReg_in(id_ex_MemtoReg),
    .Branch_in(id_ex_Branch),
    .Jump_in(id_ex_Jump),

    .Zero_in(Zero),

    .branch_target_in(branch_target),
    .alu_result_in(alu_result),
    .write_data_in(forwardB_data),

    .rd_in(id_ex_rd),

    .RegWrite_out(ex_mem_RegWrite),
    .MemRead_out(ex_mem_MemRead),
    .MemWrite_out(ex_mem_MemWrite),
    .MemtoReg_out(ex_mem_MemtoReg),
    .Branch_out(ex_mem_Branch),
    .Jump_out(ex_mem_Jump),

    .Zero_out(ex_mem_zero),

    .branch_target_out(ex_mem_branch_target),
    .alu_result_out(ex_mem_alu_result),
    .write_data_out(ex_mem_write_data),

    .rd_out(ex_mem_rd)

);

// Data Memory

data_memory data_memory_inst(

    .clk(clk),

    .MemRead(ex_mem_MemRead),
    .MemWrite(ex_mem_MemWrite),

    .address(ex_mem_alu_result),

    .write_data(ex_mem_write_data),

    .read_data(memory_read_data)

);

// MEM/WB Pipeline Register

mem_wb_register mem_wb_register_inst(

    .clk(clk),
    .reset(reset),

    .RegWrite_in(ex_mem_RegWrite),
    .MemtoReg_in(ex_mem_MemtoReg),

    .read_data_in(memory_read_data),
    .alu_result_in(ex_mem_alu_result),

    .rd_in(ex_mem_rd),

    .RegWrite_out(mem_wb_RegWrite),
    .MemtoReg_out(mem_wb_MemtoReg),

    .read_data_out(mem_wb_read_data),
    .alu_result_out(mem_wb_alu_result),

    .rd_out(mem_wb_rd)

);

// Write Back

assign write_back_data =
        (mem_wb_MemtoReg) ?
        mem_wb_read_data :
        mem_wb_alu_result;
endmodule