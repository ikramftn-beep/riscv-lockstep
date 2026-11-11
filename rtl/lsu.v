// Load/Store Unit : combinatoire.
// Écriture : réplique/décale rs2 et génère dmem_wstrb.
// Lecture  : sélectionne octet/demi-mot dans dmem_rdata, extension signe/zéro.
// funct3 : 000 B | 001 H | 010 W | 100 BU | 101 HU
module lsu (
    input  logic        mem_read,
    input  logic        mem_write,
    input  logic [2:0]  funct3,
    input  logic [31:0] addr,          // résultat ALU
    input  logic [31:0] store_data,    // rs2 (après forwarding)
    input  logic [31:0] dmem_rdata,
    output logic [31:0] dmem_addr,
    output logic [31:0] dmem_wdata,
    output logic [3:0]  dmem_wstrb,
    output logic [31:0] load_data,
    output logic        misaligned     // bonus sûreté : futur signal de faute lockstep
);
    logic [1:0] off;
    assign off       = addr[1:0];
    assign dmem_addr = {addr[31:2], 2'b00};

    // ---------- STORE ----------
    always @* begin
        dmem_wdata = store_data;
        dmem_wstrb = 4'b0000;
        if (mem_write) begin
            case (funct3[1:0])
                2'b00: begin dmem_wdata = {4{store_data[7:0]}};  dmem_wstrb = 4'b0001 << off; end
                2'b01: begin dmem_wdata = {2{store_data[15:0]}}; dmem_wstrb = off[1] ? 4'b1100 : 4'b0011; end
                2'b10: begin dmem_wdata = store_data;            dmem_wstrb = 4'b1111; end
                default: dmem_wstrb = 4'b0000;
            endcase
        end
    end

    // ---------- LOAD ----------
    logic [31:0] shifted;
    always @* begin
        shifted   = dmem_rdata >> (8 * off);
        case (funct3)
            3'b000: load_data = {{24{shifted[7]}},  shifted[7:0]};   // LB
            3'b001: load_data = {{16{shifted[15]}}, shifted[15:0]};  // LH
            3'b010: load_data = dmem_rdata;                          // LW
            3'b100: load_data = {24'h0, shifted[7:0]};               // LBU
            3'b101: load_data = {16'h0, shifted[15:0]};              // LHU
            default: load_data = 32'h0;
        endcase
    end

    // ---------- Alignement ----------
    always @* begin
        misaligned = 1'b0;
        if (mem_read | mem_write)
            case (funct3[1:0])
                2'b01:   misaligned = off[0];
                2'b10:   misaligned = |off;
                default: misaligned = 1'b0;
            endcase
    end
endmodule
