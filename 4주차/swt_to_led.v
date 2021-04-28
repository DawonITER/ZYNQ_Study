module swt_to_led(
input wire [3:0] swt_in,
output wire [3:0] led_out
);

assign led_out = swt_in;

endmodule
