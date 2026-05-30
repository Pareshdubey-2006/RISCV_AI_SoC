module systolic_nxn #(

    parameter WIDTH = 8,
    parameter N = 2

)(

    input clk,

    input [WIDTH-1:0] a0,
    input [WIDTH-1:0] a1,

    input [WIDTH-1:0] b0,
    input [WIDTH-1:0] b1,

    output [(2*WIDTH)-1:0] out00,
    output [(2*WIDTH)-1:0] out01,

    output [(2*WIDTH)-1:0] out10,
    output [(2*WIDTH)-1:0] out11

);

genvar i, j;

wire [WIDTH-1:0] a_bus [0:N-1][0:N-1];
wire [WIDTH-1:0] b_bus [0:N-1][0:N-1];

wire [(2*WIDTH)-1:0] acc_bus [0:N-1][0:N-1];

generate

for(i = 0; i < N; i = i + 1)
begin : rows

    for(j = 0; j < N; j = j + 1)
    begin : cols

        if(i == 0 && j == 0)
        begin

            pe #(WIDTH) pe_inst(

                .clk(clk),

                .a_in(a0),
                .b_in(b0),

                .acc_in(0),

                .a_out(a_bus[i][j]),
                .b_out(b_bus[i][j]),

                .acc_out(acc_bus[i][j])

            );

        end

        else if(j == 0)
        begin

            pe #(WIDTH) pe_inst(

                .clk(clk),

                .a_in(a1),
                .b_in(b_bus[i-1][j]),

                .acc_in(0),

                .a_out(a_bus[i][j]),
                .b_out(b_bus[i][j]),

                .acc_out(acc_bus[i][j])

            );

        end

        else if(i == 0)
        begin

            pe #(WIDTH) pe_inst(

                .clk(clk),

                .a_in(a_bus[i][j-1]),
                .b_in(b1),

                .acc_in(acc_bus[i][j-1]),

                .a_out(a_bus[i][j]),
                .b_out(b_bus[i][j]),

                .acc_out(acc_bus[i][j])

            );

        end

        else
        begin

            pe #(WIDTH) pe_inst(

                .clk(clk),

                .a_in(a_bus[i][j-1]),
                .b_in(b_bus[i-1][j]),

                .acc_in(acc_bus[i][j-1]),

                .a_out(a_bus[i][j]),
                .b_out(b_bus[i][j]),

                .acc_out(acc_bus[i][j])

            );

        end

    end

end

endgenerate

assign out00 = acc_bus[0][0];
assign out01 = acc_bus[0][1];

assign out10 = acc_bus[1][0];
assign out11 = acc_bus[1][1];

endmodule