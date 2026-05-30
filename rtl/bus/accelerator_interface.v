module accelerator_interface (

    input clk,
    input reset,

    // Bus signals

    input write_en,
    input read_en,

    input [31:0] addr,
    input [31:0] write_data,

    output reg [31:0] read_data,

    // Accelerator control

    output reg start,

    input done

);

    // Control register

    reg start_reg;

    always @(posedge clk)
    begin

        if(reset)
        begin

            start_reg <= 0;
            start <= 0;

            read_data <= 0;

        end

        else
        begin

            // WRITE OPERATION

            if(write_en)
            begin

                case(addr)

                    32'h00000000:
                    begin

                        start_reg <= write_data[0];

                    end

                endcase

            end

            // START SIGNAL

            start <= start_reg;

            // READ OPERATION

            if(read_en)
            begin

                case(addr)

                    // DONE STATUS REGISTER

                    32'h00000004:
                    begin

                        read_data <= {31'b0, done};

                    end

                    default:
                    begin

                        read_data <= 32'b0;

                    end

                endcase

            end

        end

    end

endmodule