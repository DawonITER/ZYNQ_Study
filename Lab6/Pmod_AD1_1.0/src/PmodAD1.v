/* ==================================================================
* Author - YS LEE
* Create Date - 2020/04/23
* Design Name - PmodAD1 Contorller
* Module Name - PmodAD1_Control
* Target Device - Xilinx 7 series FPGA, Ultrascale+ FPGA, Zynq-7000 SoC, Zynq Ultrascale+
* Version - V0.1
* Description
*   Control frequency - 10MHz
*   Trigger frequency - 100kHz
================================================================== */


`timescale 1ns / 1ps

module PmodAD1_Control#(
    parameter DATA_SIZE = 15
)
(
    input   wire            clk,
    input   wire            resetn,
    input   wire            D0,
    input   wire            D1,
    input   wire            trig,
    output  wire            cs,
    output  wire            sclk,
    output  wire    [31:0]  adcData0,
    output  wire    [31:0]  adcData1
);

    reg [5:0] counter;
    reg trig_reg;
    reg trig_reg_prev;
    reg cs_reg;
    reg [31:0] data0;
    reg [31:0] data1;

    wire trigger;

    always @ (negedge resetn, posedge clk)
    begin
        if(resetn == 1'b0)
        begin
            trig_reg <= 1'b0;
            trig_reg_prev <= 1'b0;
        end
        else
        begin
            trig_reg <= trig;
            trig_reg_prev <= trig_reg;
        end
    end

    assign trigger = (trig_reg & ~trig_reg_prev);

    always @ (negedge resetn, posedge clk)
    begin
        if(resetn == 1'b0 || trigger == 1'b1)
        begin
            counter <= 6'd0;
        end
        else if(trig == 1'b1)
        begin
            if(counter >= DATA_SIZE + 4)
            begin
                counter <= counter;
            end
            else 
            begin
                counter <= counter + 1;
            end
        end
        else 
        begin
            counter <= 6'd0;
        end
    end

    always @ (negedge resetn, posedge clk)
    begin
        if(resetn == 1'b0 || trigger == 1'b1)
        begin
            cs_reg <= 1'b1;
        end
        else if(counter >= 2 && counter <= DATA_SIZE + 2 && trig == 1'b1)
        begin
            cs_reg <= 1'b0;
        end
        else
        begin
            cs_reg <= 1'b1;
        end
    end

    always @ (negedge resetn, negedge clk)
    begin
        if(resetn == 1'b0 || trigger == 1'b1)
        begin
            data0 <= 32'd0;
            data1 <= 32'd0;
        end
        else
        begin
            if(cs_reg == 1'b0)
            begin
                if(counter >= 2 && counter <= DATA_SIZE + 3)
                begin
                    data0[DATA_SIZE - counter + 3] <= D0;
                    data1[DATA_SIZE - counter + 3] <= D1;
                end
                else
                begin
                    data0 <= data0;
                    data1 <= data1;
                end
            end
        end
    end

    assign sclk = clk;
    assign cs = cs_reg;
    assign adcData0 = (counter == DATA_SIZE + 4) ? data0 : adcData0;
    assign adcData1 = (counter == DATA_SIZE + 4) ? data1 : adcData1;

endmodule
