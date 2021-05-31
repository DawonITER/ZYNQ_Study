/* ======================================================
* Company - Dawonsys
* Author - YS LEE
* Create Date - 2020/04/10
* Design Name - AD5628 Contorl
* Module Name - AD5628_control
* Target Device - Xilinx Zynq-7000, Zynq Ultrascale+
* Version - V0.1
* Description
*   Control frequency - 25MHz (Max. 50MHz)
*   Trigger frequency - 100kHz (Max. 400KHz / Output voltage settling time - 2.5 us)
* ======================================================
*
*
* ======================================================
* Data Transfer stream
* D31 D30 D29 D28 D27 D26 D25 D24 D23 D22 D21 D20 D19 D18 ... D08 D07 ... D00
*  X   X   X   X  C3  C2  C1  C0  A3  A2  A1  A0  D11 D10 ... D00  X       X
* 
* ======================================================
* Commnad
* C3 C2 C1 C0
* 0  0  0  0  Write input register
* 0  0  0  1  Update Register
* 0  0  1  0  Write input register, update all
* 0  0  1  1  Write and update register
* 0  1  0  0  Power down / Power up DAC
* 0  1  0  1  Load clear code
* 0  1  1  0  Load LDAC register
* 0  1  1  1  Reset
* 1  0  0  0  Set up internal REF register
* ======================================================
* Address
* A3 A2 A1 A0
* 0  0  0  0  DAC A
* 0  0  0  1  DAC B
* 0  0  1  0  DAC C
* 0  0  1  1  DAC D
* 0  1  0  0  DAC E
* 0  1  0  1  DAC F
* 0  1  1  0  DAC G
* 0  1  1  1  DAC H
* 1  1  1  1  All DACs
========================================================= */

/*=========================================================
* TODO: 
*  1 - Design control register and logic
========================================================= */

`timescale 1ns / 1ps

module AD5628_control #(
    parameter DATA_SIZE = 32
    )
(
    input   wire            resetn,
    input   wire            clk,        // use 25MHz Frequency
    input   wire    [31:0]  data0,
    input   wire    [31:0]  data1,
    input   wire    [31:0]  data2,
    input   wire    [31:0]  data3,
    input   wire    [31:0]  data4,
    input   wire    [31:0]  data5,
    input   wire    [31:0]  data6,
    input   wire    [31:0]  data7,
    input   wire            trig,       // use 100kHz Frequency
    output  wire            sync,
    output  wire            sclk,
    output  wire            dout
);

    reg sync_reg;
    reg dout_reg;
    reg [5:0] counter;
    reg [3:0] address_count;
    reg trig_reg;
    reg trig_reg_prev;

    wire [31:0] ldac_data;
    wire [31:0] vref_setup;
    wire transfer_enable;
    wire [31:0] data0_out;
    wire [31:0] data1_out;
    wire [31:0] data2_out;
    wire [31:0] data3_out;
    wire [31:0] data4_out;
    wire [31:0] data5_out;
    wire [31:0] data6_out;
    wire [31:0] data7_out;

    // assignment AD5628 register data
    assign ldac_data = 32'h0060_00FF;       // DAC port LDAC register input
    assign vref_setup = 32'h0800_0001;     // Setting internal reference voltage set up (2.5V)
    assign data0_out = {4'b0000, 4'b0011, 4'b0000, data0[11:0], 8'h00};     // write and update DAC channel A
    assign data1_out = {4'b0000, 4'b0011, 4'b0001, data1[11:0], 8'h00};     // write and update DAC channel B
    assign data2_out = {4'b0000, 4'b0011, 4'b0010, data2[11:0], 8'h00};     // write and update DAC channel C
    assign data3_out = {4'b0000, 4'b0011, 4'b0011, data3[11:0], 8'h00};     // write and update DAC channel D
    assign data4_out = {4'b0000, 4'b0011, 4'b0100, data4[11:0], 8'h00};     // write and update DAC channel E
    assign data5_out = {4'b0000, 4'b0011, 4'b0101, data5[11:0], 8'h00};     // write and update DAC channel F
    assign data6_out = {4'b0000, 4'b0011, 4'b0110, data6[11:0], 8'h00};     // write and update DAC channel G
    assign data7_out = {4'b0000, 4'b0011, 4'b0111, data7[11:0], 8'h00};     // write and update DAC channel H

    // trigger positive edge detection
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
    
    assign transfer_enable = (trig_reg & ~trig_reg_prev) ? 1:0;
    
    // counter process
    always @ (negedge resetn, posedge clk)
    begin
        if(resetn == 1'b0 || transfer_enable == 1'b1)
        begin
            counter <= 6'd0;
        end
        else if(counter == DATA_SIZE + 1)
        begin
            counter <= 6'd0;
        end
        else 
        begin
            counter <= counter + 1;
        end
    end

    // Sync(Chip Select) process
    always @ (negedge resetn, posedge clk)
    begin
        if(resetn == 1'b0 || transfer_enable == 1'b1)
        begin
            sync_reg <= 1'b1;
        end
        else if (trig == 1'b1)
        begin
            if(counter >= 1 && counter <= DATA_SIZE)
            begin
                sync_reg <= 1'b0;
            end
            else
            begin
                sync_reg <= 1'b1;
            end
        end
        else 
        begin
            sync_reg <= 1'b1;
        end
    end

    // output data address calculation
    always @ (negedge resetn, posedge clk)
    begin
        if(resetn == 1'b0)
        begin
            address_count <= 4'd0;
        end
        else if(address_count >= 10)
        begin
            address_count <= 4'd0;
        end
        else if(counter == DATA_SIZE + 1)
        begin
            address_count <= address_count + 1;
        end
    end

    // Data out process
    always @ (negedge resetn, posedge clk)
    begin
        if(resetn == 1'b0 || transfer_enable == 1'b1)
        begin
            dout_reg <= 1'b0;
        end
        else if(trig == 1'b1)
        begin
            if(counter >= 1 && counter <= DATA_SIZE)
            begin
                case(address_count)
                    4'd0 : dout_reg <= data0_out[DATA_SIZE - counter];
                    4'd1 : dout_reg <= data1_out[DATA_SIZE - counter];
                    4'd2 : dout_reg <= data2_out[DATA_SIZE - counter];
                    4'd3 : dout_reg <= data3_out[DATA_SIZE - counter];
                    4'd4 : dout_reg <= data4_out[DATA_SIZE - counter];
                    4'd5 : dout_reg <= data5_out[DATA_SIZE - counter];
                    4'd6 : dout_reg <= data6_out[DATA_SIZE - counter];
                    4'd7 : dout_reg <= data7_out[DATA_SIZE - counter];
                    4'd8 : dout_reg <= ldac_data[DATA_SIZE - counter];
                    4'd9 : dout_reg <= vref_setup[DATA_SIZE - counter];
                    default: dout_reg <= 0;
                endcase
            end
            else
            begin
                dout_reg <= 1'b0;
            end
        end
        else
        begin
            dout_reg <= 1'b0;
        end
    end

    // output port assignment
    assign dout = dout_reg;
    assign sclk = clk;
    assign sync = sync_reg;

endmodule