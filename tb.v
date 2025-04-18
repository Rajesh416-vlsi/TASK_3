`timescale 1ns / 1ps

module tb_pipelined_processor;
    reg clk;
    reg reset;
    integer i;

    
    PipelinedProcessor uut (
        .clk(clk),
        .reset(reset)
    );

   
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    
    initial begin
        $dumpfile("pipeline_processor.vcd");
        $dumpvars(0, tb_pipelined_processor);
        $dumpvars(0, uut);
    end

   
    initial begin
       
        reset = 1;
        #10;
        reset = 0;
        #100;
        $display("Final Register Values:");
        for (i = 0; i < 8; i = i + 1) begin
            $display("R%0d: %d", i, uut.register_file[i]);
        end
        
        $display("Pipeline Register Values:");
        $display("PC: %d", uut.PC);
        $display("IF/ID IR: %b", uut.IF_ID_IR);
        $display("IF/ID PC: %d", uut.IF_ID_PC);
        $display("ID/EX A: %d", uut.ID_EX_A);
        $display("ID/EX B: %d", uut.ID_EX_B);
        $display("ID/EX IMM: %d", uut.ID_EX_IMM);
        $display("ID/EX RD: %d", uut.ID_EX_RD);
        $display("EX/MEM ALU_OUT: %d", uut.EX_MEM_ALU_OUT);
        $display("EX/MEM B: %d", uut.EX_MEM_B);
        $display("EX/MEM RD: %d", uut.EX_MEM_RD);
        $display("MEM/WB ALU_OUT: %d", uut.MEM_WB_ALU_OUT);
        $display("MEM/WB RD: %d", uut.MEM_WB_RD);
        $display("MEM/WB RegWrite: %d", uut.MEM_WB_RegWrite);
        
        $finish; 
    end

   
    always @(posedge clk) begin
        $display("Time: %0t | PC: %d | IF_ID_IR: %b | ID_EX_A: %d | EX_MEM_ALU_OUT: %d | MEM_WB_ALU_OUT: %d", 
                  $time, uut.PC, uut.IF_ID_IR, uut.ID_EX_A, uut.EX_MEM_ALU_OUT, uut.MEM_WB_ALU_OUT);
    end

endmodule
