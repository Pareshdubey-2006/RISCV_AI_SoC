module tb_soc_top;

    parameter WIDTH = 8;
    parameter N = 2;

    reg clk;
    reg reset;
    reg start;

    // Memory control signals

    reg we_a;
    reg we_b;

    reg [WIDTH-1:0] data_in_a;
    reg [WIDTH-1:0] data_in_b;

    reg [$clog2(16)-1:0] addr_a;
    reg [$clog2(16)-1:0] addr_b;

    // Instantiate DUT

    soc_top #(WIDTH, N) dut (

        .clk(clk),
        .reset(reset),
        .start(start),

        .we_a(we_a),
        .we_b(we_b),

        .data_in_a(data_in_a),
        .data_in_b(data_in_b),

        .addr_a(addr_a),
        .addr_b(addr_b)

    );

    // Clock generation

    initial begin

        clk = 0;

        forever #5 clk = ~clk;

    end

    // Waveform dump

    initial begin

        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_soc_top);

    end

    // Test sequence

    initial begin

        // Initialize control signals

        we_a = 0;
        we_b = 0;

        addr_a = 0;
        addr_b = 0;

        data_in_a = 0;
        data_in_b = 0;

        reset = 1;
        start = 0;

        #10;

        // Write Matrix A values into memory

        we_a = 1;

        addr_a = 0;
        data_in_a = 8'd1;

        #10;

        addr_a = 1;
        data_in_a = 8'd2;

        #10;

        we_a = 0;

        // Write Matrix B values into memory

        we_b = 1;

        addr_b = 0;
        data_in_b = 8'd3;

        #10;

        addr_b = 1;
        data_in_b = 8'd4;

        #10;

        we_b = 0;

        // Release reset

        reset = 0;

        #10;

        // Start accelerator

        start = 1;

        #10;

        start = 0;

        #100;

        $finish;

    end

    // Monitor outputs

    initial begin

        $monitor(

            "Time=%0t | out00=%d out01=%d out10=%d out11=%d",

            $time,

            dut.out00,
            dut.out01,

            dut.out10,
            dut.out11

        );

    end

endmodule