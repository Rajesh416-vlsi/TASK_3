module PipelinedProcessor(
    input clk, reset
);

   
    reg [31:0] instruction_memory [0:15];
    reg [31:0] register_file [0:7];
    reg [31:0] data_memory [0:15];
    reg [31:0] IF_ID_IR, IF_ID_PC;
    reg [31:0] ID_EX_A, ID_EX_B, ID_EX_IMM;
    reg [2:0] ID_EX_RD;
    reg [31:0] EX_MEM_ALU_OUT, EX_MEM_B;
    reg [2:0] EX_MEM_RD;
    reg [31:0] MEM_WB_ALU_OUT;
    reg [2:0] MEM_WB_RD;
    reg MEM_WB_RegWrite;

    integer i;

    initial begin
        
        instruction_memory[0] = 32'b000000_00001_00010_00011_00000_100000; 
        instruction_memory[1] = 32'b000000_00011_00001_00100_00000_100010; 
        instruction_memory[2] = 32'b100011_00001_00101_0000000000000100;  

        
        for (i = 0; i < 8; i = i + 1)
            register_file[i] = i;
    end

    
    reg [31:0] PC = 0;
    always @(posedge clk or posedge reset) begin
        if (reset) PC <= 0;
        else begin
            IF_ID_IR <= instruction_memory[PC >> 2];
            IF_ID_PC <= PC;
            PC <= PC + 4;
        end
    end

   
    always @(posedge clk) begin
        ID_EX_A <= register_file[IF_ID_IR[25:21]];
        ID_EX_B <= register_file[IF_ID_IR[20:16]];
        ID_EX_IMM <= {{16{IF_ID_IR[15]}}, IF_ID_IR[15:0]};
        ID_EX_RD <= IF_ID_IR[15:11];
    end

   
    always @(posedge clk) begin
        case (IF_ID_IR[31:26])
            6'b000000: 
                if (IF_ID_IR[5:0] == 6'b100000) 
                    EX_MEM_ALU_OUT <= ID_EX_A + ID_EX_B;
                else if (IF_ID_IR[5:0] == 6'b100010) 
                    EX_MEM_ALU_OUT <= ID_EX_A - ID_EX_B;
            6'b100011: 
                EX_MEM_ALU_OUT <= ID_EX_A + ID_EX_IMM;
        endcase
        EX_MEM_B <= ID_EX_B;
        EX_MEM_RD <= ID_EX_RD;
    end

    
    always @(posedge clk) begin
        if (IF_ID_IR[31:26] == 6'b100011) 
            MEM_WB_ALU_OUT <= data_memory[EX_MEM_ALU_OUT >> 2];
        else
            MEM_WB_ALU_OUT <= EX_MEM_ALU_OUT;
        MEM_WB_RD <= EX_MEM_RD;
        MEM_WB_RegWrite <= 1;
    end

  
    always @(posedge clk) begin
        if (MEM_WB_RegWrite)
            register_file[MEM_WB_RD] <= MEM_WB_ALU_OUT;
    end

endmodule
