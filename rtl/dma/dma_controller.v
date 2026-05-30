module dma_controller (

    input clk,
    input reset,

    // DMA Control

    input start_dma,

    output reg dma_done,

    // Source Memory Interface A

    input [7:0] src_data_a,

    output reg [3:0] src_addr_a,

    // Source Memory Interface B

    input [7:0] src_data_b,

    output reg [3:0] src_addr_b,

    // Destination Interface A

    output reg [7:0] dst_data_a,
    output reg [3:0] dst_addr_a,

    // Destination Interface B

    output reg [7:0] dst_data_b,
    output reg [3:0] dst_addr_b,

    output reg write_enable

);

    // DMA state machine

    reg [1:0] state;

    parameter IDLE     = 2'b00;
    parameter TRANSFER = 2'b01;
    parameter DONE     = 2'b10;

    always @(posedge clk)
    begin

        if(reset)
        begin

            state <= IDLE;

            src_addr_a <= 0;
            src_addr_b <= 0;

            dst_addr_a <= 0;
            dst_addr_b <= 0;

            dst_data_a <= 0;
            dst_data_b <= 0;

            write_enable <= 0;

            dma_done <= 0;

        end

        else
        begin

            case(state)

                // IDLE STATE

                IDLE:
                begin

                    dma_done <= 0;
                    write_enable <= 0;

                    if(start_dma)
                    begin

                        src_addr_a <= 0;
                        src_addr_b <= 0;

                        dst_addr_a <= 0;
                        dst_addr_b <= 0;

                        state <= TRANSFER;

                    end

                end

                // DATA TRANSFER STATE

                TRANSFER:
                begin

                    // Read source and write destination

                    dst_data_a <= src_data_a;
                    dst_data_b <= src_data_b;

                    write_enable <= 1;

                    // Increment addresses

                    src_addr_a <= src_addr_a + 1;
                    src_addr_b <= src_addr_b + 1;

                    dst_addr_a <= dst_addr_a + 1;
                    dst_addr_b <= dst_addr_b + 1;

                    // Example: transfer 4 elements

                    if(src_addr_a == 4)
                    begin

                        state <= DONE;

                    end

                end

                // DONE STATE

                DONE:
                begin

                    write_enable <= 0;

                    dma_done <= 1;

                    state <= IDLE;

                end

            endcase

        end

    end

endmodule