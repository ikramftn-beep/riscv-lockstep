// Mémoire de données : écriture par octets (wstrb), lecture synchrone 1 cycle.
module dmem_model #(
    parameter DEPTH   = 1024,
    parameter HEXFILE = ""
)(
    input  logic        clk,
    input  logic [31:0] dmem_addr,
    input  logic [31:0] dmem_wdata,
    input  logic [3:0]  dmem_wstrb,           // 0000 = pas d'écriture
    output logic [31:0] dmem_rdata
);
    logic [31:0] mem [0:DEPTH-1];
    wire  [$clog2(DEPTH)-1:0] widx = dmem_addr[$clog2(DEPTH)+1:2];
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1) mem[i] = 32'h0;
        if (HEXFILE != "") $readmemh(HEXFILE, mem);
    end
    always_ff @(posedge clk) begin
        if (dmem_wstrb[0]) mem[widx][7:0]   <= dmem_wdata[7:0];
        if (dmem_wstrb[1]) mem[widx][15:8]  <= dmem_wdata[15:8];
        if (dmem_wstrb[2]) mem[widx][23:16] <= dmem_wdata[23:16];
        if (dmem_wstrb[3]) mem[widx][31:24] <= dmem_wdata[31:24];
        dmem_rdata <= mem[widx];              // lit l'ancienne valeur si écriture même cycle
    end
endmodule
