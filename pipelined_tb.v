module pipelined_tb;
    reg clk = 0;
    reg rst = 1;

    pipelined cpu(.clk(clk), .rst(rst));

    always #5 clk = ~clk;

    initial begin
        // Initialize registers
        cpu.regfile[2] = 5;  
        cpu.regfile[4] = 10;  
        cpu.regfile[6] = 3;   
        cpu.regfile[8] = 15;  
        cpu.data_mem[5] = 100; 

        // Load instructions
        cpu.instr_mem[0] = {3'b011, 4'd2, 4'd0, 4'd1, 17'd0}; 
        cpu.instr_mem[1] = {3'b000, 4'd1, 4'd4, 4'd3, 17'd0}; 
        cpu.instr_mem[2] = {3'b001, 4'd3, 4'd6, 4'd5, 17'd0}; 
        cpu.instr_mem[3] = {3'b010, 4'd5, 4'd8, 4'd7, 17'd0}; 

       
        #10 rst = 0;

        #100;

        // Print results
        $display("R1 = %d", cpu.regfile[1]);
        $display("R3 = %d", cpu.regfile[3]);
        $display("R5 = %d", cpu.regfile[5]);
        $display("R7 = %d", cpu.regfile[7]);

        $finish;
    end
endmodule