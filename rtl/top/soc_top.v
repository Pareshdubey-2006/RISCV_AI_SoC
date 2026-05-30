module soc_top #(

    parameter WIDTH = 8,
    parameter N = 2

)(

    input clk,
    input reset,
    input start,

    input we_a,
    input we_b,

    input [WIDTH-1:0] data_in_a,
    input [WIDTH-1:0] data_in_b,

    input [$clog2(16)-1:0] addr_a,
    input [$clog2(16)-1:0] addr_b,

    // Exposed accelerator outputs

    output [(2*WIDTH)-1:0] out00,
    output [(2*WIDTH)-1:0] out01,

    output [(2*WIDTH)-1:0] out10,
    output [(2*WIDTH)-1:0] out11

);

    wire done;

    // Memory interface signals

    wire [WIDTH-1:0] mem_data_out_a;
    wire [WIDTH-1:0] mem_data_out_b;

    // PicoRV32 interface signals

    wire trap;

    wire        mem_valid;
    wire        mem_instr;
    wire        mem_ready;

    wire [31:0] mem_addr;
    wire [31:0] mem_wdata;
    wire [3:0]  mem_wstrb;
    wire [31:0] mem_rdata;

    // DMA interface signals

    wire dma_done;

    wire [3:0] dma_src_addr_a;
    wire [3:0] dma_src_addr_b;

    wire [3:0] dma_dst_addr_a;
    wire [3:0] dma_dst_addr_b;

    wire [7:0] dma_dst_data_a;
    wire [7:0] dma_dst_data_b;

    wire dma_write_enable;

    // DMA to Accelerator signals

    wire [WIDTH-1:0] dma_accel_data_a;
    wire [WIDTH-1:0] dma_accel_data_b;

    // Tie-offs

    assign mem_ready = 1'b1;
    assign mem_rdata = 32'b0;

    // DMA feeds accelerator

    assign dma_accel_data_a = dma_dst_data_a;
    assign dma_accel_data_b = dma_dst_data_b;

    // PicoRV32

    picorv32 cpu_inst (

        .clk(clk),
        .resetn(~reset),

        .trap(trap),

        .mem_valid(mem_valid),
        .mem_instr(mem_instr),
        .mem_ready(mem_ready),

        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),
        .mem_wstrb(mem_wstrb),
        .mem_rdata(mem_rdata),

        .pcpi_wr(1'b0),
        .pcpi_rd(32'b0),
        .pcpi_wait(1'b0),
        .pcpi_ready(1'b0),

        .irq(32'b0)

    );

    // DMA Controller

    dma_controller dma_inst (

        .clk(clk),
        .reset(reset),

        .start_dma(start),

        .dma_done(dma_done),

        .src_data_a(mem_data_out_a),
        .src_addr_a(dma_src_addr_a),

        .src_data_b(mem_data_out_b),
        .src_addr_b(dma_src_addr_b),

        .dst_data_a(dma_dst_data_a),
        .dst_addr_a(dma_dst_addr_a),

        .dst_data_b(dma_dst_data_b),
        .dst_addr_b(dma_dst_addr_b),

        .write_enable(dma_write_enable)

    );

    // Memory A

    memory_block #(WIDTH, 16) mem_a (

        .clk(clk),

        .we(we_a),
        .addr(addr_a),

        .data_in(data_in_a),

        .data_out(mem_data_out_a)

    );

    // Memory B

    memory_block #(WIDTH, 16) mem_b (

        .clk(clk),

        .we(we_b),
        .addr(addr_b),

        .data_in(data_in_b),

        .data_out(mem_data_out_b)

    );

    // Accelerator Wrapper

    accelerator_wrapper #(WIDTH, N) accel_inst (

        .clk(clk),
        .reset(reset),
        .start(start),

        .a0(dma_accel_data_a),
        .a1(dma_accel_data_a),

        .b0(dma_accel_data_b),
        .b1(dma_accel_data_b),

        .done(done),

        .out00(out00),
        .out01(out01),

        .out10(out10),
        .out11(out11)

    );

endmodule