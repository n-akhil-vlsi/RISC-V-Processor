module register_file (

    input wire clk,
    input wire we,  //it is the control signal(Regwrite)

    input wire [4:0] rs1,
    input wire [4:0] rs2,
    input wire [4:0] rd,

    input wire [31:0] write_data,

    output wire [31:0] read_data1,
    output wire [31:0] read_data2

);

    // 32 Registers of 32 bits each
    reg [31:0] registers [0:31];

    integer i;

    // Initialize all registers to zero
    initial 
    begin
        for(i = 0; i < 32; i = i + 1)
            registers[i] = 32'b0;
    end

    //Read is Asynchronous because we are not changing or modifying anything in any module,we are just reading the values anytime.
    
    assign read_data1 = (rs1 == 5'd0) ? 32'b0 :(we && (rd == rs1)) ? write_data : registers[rs1];
    assign read_data2 = (rs2 == 5'd0) ? 32'b0 :(we && (rd == rs2)) ? write_data : registers[rs2];


    //We synchronize the write so that the state of the processor changes only at controlled clock edges to maintain the synchronization.
    
    always @(posedge clk) 
    begin
      if (we && (rd != 5'd0)) 
        begin
        registers[rd] <= write_data;
        $display("Time=%0t : Writing x%0d = %0d", $time, rd, write_data);
        end
    end

    always @(posedge clk) 
    begin
        $display("x1=%0d x2=%0d x3=%0d",registers[1],registers[2],registers[3]);
    end
endmodule