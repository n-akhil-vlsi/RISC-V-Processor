module if_id_register(

    input wire clk,
    input wire reset,
    input wire write_enable,
    input wire flush,             //if flush takes place then think it as the instruction with no life passing through each registers and modules.     

    input wire [31:0] pc_in,
    input wire [31:0] pc_next_in,
    input wire [31:0] instruction_in,

    output reg [31:0] pc_out,
    output reg [31:0] pc_next_out,
    output reg [31:0] instruction_out

);

always @(posedge clk or posedge reset) begin

    if(reset) 
    begin
        pc_out <= 32'd0;
        pc_next_out <= 32'd0;
        instruction_out <= 32'd0;
    end

    else if(flush) 
    begin                                     //flush takes priority over write_enable
        pc_out <= 32'd0;                      //flush means--this instruction doesn't count, treat it as if it never happened,even though it technically passed through the fetch stage.
        pc_next_out <= 32'd0;                 //after flushing, it's the bubble — not the actual instruction — that goes through every subsequent pipeline register.
        instruction_out <= 32'd0;            // NOP bubble
    end


    else if(write_enable) 
    begin
        pc_out <= pc_in;
        pc_next_out <= pc_next_in;
        instruction_out <= instruction_in;
    end

end

endmodule