module apb_accelerator_interface (

    input PCLK,
    input PRESETn,

    // APB Signals

    input PSEL,
    input PENABLE,
    input PWRITE,

    input [31:0] PADDR,
    input [31:0] PWDATA,

    output reg [31:0] PRDATA,

    // Accelerator Signals

    output reg start,
    input done

);

    // Control register

    reg start_reg;

    always @(posedge PCLK)
    begin

        // Active-low reset

        if(!PRESETn)
        begin

            start_reg <= 0;
            start <= 0;

            PRDATA <= 0;

        end

        else
        begin

            // APB WRITE TRANSACTION

            if(PSEL && PENABLE && PWRITE)
            begin

                case(PADDR)

                    // START REGISTER

                    32'h00000000:
                    begin

                        start_reg <= PWDATA[0];

                    end

                endcase

            end

            // Generate accelerator start

            start <= start_reg;

            // APB READ TRANSACTION

            if(PSEL && PENABLE && !PWRITE)
            begin

                case(PADDR)

                    // DONE STATUS REGISTER

                    32'h00000004:
                    begin

                        PRDATA <= {31'b0, done};

                    end

                    default:
                    begin

                        PRDATA <= 32'b0;

                    end

                endcase

            end

        end

    end

endmodule