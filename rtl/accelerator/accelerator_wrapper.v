module accelerator_wrapper #(

    parameter WIDTH = 8,
    parameter N = 2

)(

    input clk,
    input reset,
    input start,

    input [WIDTH-1:0] a0,
    input [WIDTH-1:0] a1,

    input [WIDTH-1:0] b0,
    input [WIDTH-1:0] b1,

    output reg done,

    output [(2*WIDTH)-1:0] out00,
    output [(2*WIDTH)-1:0] out01,

    output [(2*WIDTH)-1:0] out10,
    output [(2*WIDTH)-1:0] out11

);

    wire [(2*WIDTH)-1:0] internal_out00;
    wire [(2*WIDTH)-1:0] internal_out01;

    wire [(2*WIDTH)-1:0] internal_out10;
    wire [(2*WIDTH)-1:0] internal_out11;

    systolic_nxn #(WIDTH, N) accelerator_core (

        .clk(clk),

        .a0(a0),
        .a1(a1),

        .b0(b0),
        .b1(b1),

        .out00(internal_out00),
        .out01(internal_out01),

        .out10(internal_out10),
        .out11(internal_out11)

    );

    assign out00 = internal_out00;
    assign out01 = internal_out01;

    assign out10 = internal_out10;
    assign out11 = internal_out11;

    always @(posedge clk or posedge reset)
    begin

        if(reset)
            done <= 0;

        else if(start)
            done <= 1;

        else
            done <= 0;

    end

endmodule