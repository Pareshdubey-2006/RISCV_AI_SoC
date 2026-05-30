module memory_block #(

    parameter WIDTH = 8,
    parameter DEPTH = 16

)(

    input clk,

    input we,                     // Write enable
    input [$clog2(DEPTH)-1:0] addr,

    input [WIDTH-1:0] data_in,

    output reg [WIDTH-1:0] data_out

);

    // Memory array

    reg [WIDTH-1:0] memory [0:DEPTH-1];

    always @(posedge clk)
    begin

        // Write operation

        if(we)
            memory[addr] <= data_in;

        // Read operation

        data_out <= memory[addr];

    end

endmodule