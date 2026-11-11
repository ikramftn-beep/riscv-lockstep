`timescale 1ns/1ps
module tb_lsu;
    logic mem_read, mem_write; logic [2:0] funct3;
    logic [31:0] addr, store_data, dmem_rdata;
    wire  [31:0] dmem_addr, dmem_wdata, load_data; wire [3:0] dmem_wstrb; wire misaligned;
    int errors = 0;

    lsu dut(.*);

    task automatic chk_store(string n, logic [2:0] f, logic [31:0] a, logic [31:0] d,
                             logic [3:0] exp_strb, logic [31:0] exp_wdata_masked);
        logic [31:0] m;
        mem_read = 0; mem_write = 1; funct3 = f; addr = a; store_data = d; #1;
        m = {{8{dmem_wstrb[3]}},{8{dmem_wstrb[2]}},{8{dmem_wstrb[1]}},{8{dmem_wstrb[0]}}};
        if (dmem_wstrb !== exp_strb) begin errors++; $display("FAIL %s: wstrb=%b attendu %b", n, dmem_wstrb, exp_strb); end
        else if ((dmem_wdata & m) !== exp_wdata_masked) begin errors++; $display("FAIL %s: wdata=%h attendu %h", n, dmem_wdata & m, exp_wdata_masked); end
        else $display("ok   %s", n);
    endtask

    task automatic chk_load(string n, logic [2:0] f, logic [31:0] a, logic [31:0] rd, logic [31:0] exp);
        mem_read = 1; mem_write = 0; funct3 = f; addr = a; dmem_rdata = rd; store_data = 0; #1;
        if (load_data !== exp) begin errors++; $display("FAIL %s: got %h attendu %h", n, load_data, exp); end
        else $display("ok   %s", n);
    endtask

    initial begin
        chk_store("sb off0", 3'b000, 32'h100, 32'hAABBCCDD, 4'b0001, 32'h000000DD);
        chk_store("sb off1", 3'b000, 32'h101, 32'hAABBCCDD, 4'b0010, 32'h0000DD00);
        chk_store("sb off2", 3'b000, 32'h102, 32'hAABBCCDD, 4'b0100, 32'h00DD0000);
        chk_store("sb off3", 3'b000, 32'h103, 32'hAABBCCDD, 4'b1000, 32'hDD000000);
        chk_store("sh off0", 3'b001, 32'h100, 32'hAABBCCDD, 4'b0011, 32'h0000CCDD);
        chk_store("sh off2", 3'b001, 32'h102, 32'hAABBCCDD, 4'b1100, 32'hCCDD0000);
        chk_store("sw",      3'b010, 32'h100, 32'hAABBCCDD, 4'b1111, 32'hAABBCCDD);
        mem_write = 0; #1;
        if (dmem_wstrb !== 0) begin errors++; $display("FAIL wstrb non nul sans write"); end else $display("ok   pas d'écriture");
        chk_load("lb  neg off1", 3'b000, 32'h101, 32'h0000_8000, 32'hFFFFFF80);
        chk_load("lbu neg off1", 3'b100, 32'h101, 32'h0000_8000, 32'h00000080);
        chk_load("lb  pos off3", 3'b000, 32'h103, 32'h7F00_0000, 32'h0000007F);
        chk_load("lh  neg off2", 3'b001, 32'h102, 32'h8001_0000, 32'hFFFF8001);
        chk_load("lhu neg off2", 3'b101, 32'h102, 32'h8001_0000, 32'h00008001);
        chk_load("lh  off0",     3'b001, 32'h100, 32'h0000_1234, 32'h00001234);
        chk_load("lw",           3'b010, 32'h100, 32'hDEADBEEF, 32'hDEADBEEF);
        mem_read = 1; mem_write = 0; funct3 = 3'b010; addr = 32'h101; #1;
        if (!misaligned) begin errors++; $display("FAIL lw non aligné non détecté"); end else $display("ok   lw non aligné détecté");

        if (errors == 0) $display("=== tb_lsu : TOUS LES TESTS PASSENT ===");
        else             $display("=== tb_lsu : %0d ERREUR(S) ===", errors);
        $finish;
    end
endmodule
