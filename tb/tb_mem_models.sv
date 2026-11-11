`timescale 1ns/1ps
module tb_mem_models;
    logic clk = 0; always #5 clk = ~clk;
    logic [31:0] ia, da, dw; logic [3:0] ws; wire [31:0] ir, dr;
    imem_model #(.DEPTH(64), .HEXFILE("build/test_add.hex")) imem(.clk, .imem_addr(ia), .imem_rdata(ir));
    dmem_model #(.DEPTH(64)) dmem(.clk, .dmem_addr(da), .dmem_wdata(dw), .dmem_wstrb(ws), .dmem_rdata(dr));
    initial begin
        ia = 0; da = 0; dw = 0; ws = 0;
        @(posedge clk); #1 ia = 4; $display("imem[0]=%h (attendu 00500093)", ir);
        @(posedge clk); #1 $display("imem[1]=%h (attendu 00700113)", ir);
        da = 8; dw = 32'h11223344; ws = 4'b1111; @(posedge clk); #1 ws = 0; @(posedge clk); #1;
        $display("dmem[8]=%h (attendu 11223344)", dr);
        dw = 32'hFFFFFFFF; ws = 4'b0010; @(posedge clk); #1 ws = 0; @(posedge clk); #1;
        $display("dmem[8] après sb off1=%h (attendu 1122ff44)", dr);
        $finish;
    end
endmodule
