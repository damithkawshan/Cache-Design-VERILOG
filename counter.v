`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Damith Kawshan
// 
// Create Date:    11:00:41 05/01/2019 
// Design Name: 
// Module Name:    counter 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module counter(
    input clk,
    input start,//this should be a pulse lasting one clock cycle
    output [3:0] out_val,
    input reset,
	 output done
    );

reg [3:0] val;

initial begin
	val=0;
end

assign done=(val==8)?1'b1:1'b0;
assign out_val=val;

always @(posedge clk) begin
	if ((start | ~(val==0))&~reset) begin
		if (val<8) begin
			val<=val+1; 
		end
		else begin
			val<=0;
		end
	end
	else val<=0;
end

endmodule
