`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/05 15:13:50
// Design Name: 
// Module Name: SWT_to_LED
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SWT_to_LED(
    input   wire                clk,
    input   wire                resetn,
    input   wire    [3:0]       SwitchIn,
    input   wire    [3:0]       LedDataControl,
    input   wire    [3:0]       LedDataIn,
    output  wire    [3:0]       LedOutput
    );
    
    reg     [3:0]       SwtInRegs;
    reg     [3:0]       LedOutRegs;
    reg     [3:0]       LedOutControlDataRegs;
    
    always @ (posedge clk) begin
        if(resetn == 1'b0) begin
            SwtInRegs <= 4'b0;
            LedOutControlDataRegs <= 4'b0;
        end
        else begin
            SwtInRegs <= SwitchIn;
            LedOutControlDataRegs <= LedDataIn;
        end
    end
    
    genvar led_i;
    generate
        for(led_i=0; led_i<3; led_i=led_i+1) begin : LED_output
            always @ (posedge clk) begin
                if(resetn == 1'b0) begin
                    LedOutRegs[led_i] <= 1'b0;
                end
                else if(LedDataControl[led_i] == 1'b1) begin
                    LedOutRegs[led_i] <= LedOutControlDataRegs[led_i];
                end
                else begin
                    LedOutRegs[led_i] <= SwtInRegs[led_i];
                end
            end
        end
    endgenerate

    assign LedOutput = LedOutRegs;

endmodule
