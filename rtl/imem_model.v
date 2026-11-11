// Mémoire d'instructions : lecture synchrone, latence 1 cycle.
// Charge un .hex (1 mot 32 bits par ligne) avec $readmemh.
module imem_model #(
    parameter DEPTH   = 1024,                 // en mots
    parameter HEXFILE = "build/test_add.hex"
)(
    input  logic        clk,
    input  logic [31:0] imem_addr,            // adresse octet
    output logic [31:0] imem_rdata
);
    logic [31:0] mem [0:DEPTH-1];
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1) mem[i] = 32'h0000_0013; // NOP (addi x0,x0,0)
        $readmemh(HEXFILE, mem);
    end
    always_ff @(posedge clk)
        imem_rdata <= mem[imem_addr[$clog2(DEPTH)+1:2]];
endmodule
