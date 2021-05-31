/* ==================================================================
* Company - Dawonsys
* Author - YS LEE
* Create Date - 2020/04/16
* Design Name - Clock Divider
* Module Name - clock_divider
* Target Device - Xilinx 7 series FPGA, Ultrascale+ FPGA, Zynq-7000 SoC, Zynq Ultrascale+
* Version - V1.0
* Description
================================================================== */
`timescale 1ns / 1ps

module clock_divider#(
    parameter CLOCK_IN = 100000000,
    parameter CLOCK_OUT = 100000
)
(
    input   wire            clk_in,
    output  wire            clk_out,
    input   wire            resetn
);

    localparam CLOCK_DIV = (CLOCK_IN/CLOCK_OUT/2 - 1);

    reg [31:0] counter;
    reg clk_out_reg;

    always @ (negedge resetn, posedge clk_in)
    begin
        if(resetn == 1'b0)
        begin
            counter <= 31'd0;
            clk_out_reg <= 0;
        end
        else if(counter == CLOCK_DIV)
        begin
            counter <= 0;
            clk_out_reg <= ~clk_out_reg;
        end
        else
        begin
            counter <= counter + 1;
        end
    end

    assign clk_out = clk_out_reg;

endmodule