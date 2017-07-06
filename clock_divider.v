`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:19:24 04/28/2016 
// Design Name: 
// Module Name:    clock_divider 
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
module clock_divider(clk,second,resetclock
    );
input clk;
input resetclock;
output reg [9:0] second = 10'd59;

reg [26:0] dividerSec = 26'b0;

always @(posedge clk) begin
	if(resetclock)begin
		second = 10'd59;
	end else
	if(dividerSec == 27'b101111101011110000100000000)begin
		dividerSec = 27'b111111111111111111111111111;
		// 2Hz
		if(second == 10'd0)begin
			second = 10'd59;
		end else begin
			second = second - 10'd1;
		end
	end
	

	dividerSec = dividerSec + 1'b1;
	
end

endmodule
