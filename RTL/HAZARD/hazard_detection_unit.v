module hazard_detection_unit(

    input wire ID_EX_MemRead,
    input wire [4:0] ID_EX_rd,

    input wire [4:0] IF_ID_rs1,
    input wire [4:0] IF_ID_rs2,

    output reg PCWrite,
    output reg IF_ID_Write,
    output reg ControlMux

);

always @(*) begin

    if (ID_EX_MemRead &&
       ((ID_EX_rd == IF_ID_rs1) ||
        (ID_EX_rd == IF_ID_rs2))) begin

        // Stall Pipeline
        PCWrite     = 1'b0;
        IF_ID_Write = 1'b0;
        ControlMux  = 1'b1;

    end
    else begin

        // Normal Operation
        PCWrite     = 1'b1;
        IF_ID_Write = 1'b1;
        ControlMux  = 1'b0;

    end

end

endmodule