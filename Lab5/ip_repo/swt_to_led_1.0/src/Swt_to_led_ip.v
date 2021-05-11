module Swt_to_led_ip(
    input   wire            clk,
    input   wire            rstn,
    input   wire    [3:0]   swt_in,
    input   wire    [3:0]   btn_in,
    output  wire    [3:0]   led_out,
    output  wire    [3:0]   swt_data,
    output  wire    [3:0]   btn_data
);

reg [3:0] swt_in_reg;
reg [3:0] btn_in_reg;
reg [3:0] led_out_reg;

// read switch and button input
always @ (posedge clk) begin
    if(rstn == 1'b0) begin
        swt_in_reg <= 4'b0;
        btn_in_reg <= 4'b0;
    end
    else begin
        swt_in_reg <= swt_in;
        btn_in_reg <= btn_in;
    end
end




// LED output logic
genvar logic_i;
generate
    for(logic_i=0; logic_i<4; logic_i=logic_i+1) begin : led_logic
        always @ (posedge clk) begin
            if(rstn == 1'b0) begin
                led_out_reg[logic_i] <= 1'b0;
            end
            else if(btn_in_reg[logic_i] == 1'b1) begin
                led_out_reg[logic_i] <= ~swt_in_reg[logic_i];
            end
            else begin
                led_out_reg[logic_i] <= swt_in_reg[logic_i];
            end
        end
    end
endgenerate


// assign output ports
assign swt_data = swt_in_reg;
assign btn_data = btn_in_reg;
assign led_out = led_out_reg;

endmodule