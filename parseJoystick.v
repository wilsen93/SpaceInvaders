`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:18:09 05/24/2016 
// Design Name: 
// Module Name:    parseJoystick 
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
module parseJoystick(clk,xPos,yPos, direction
    );

//input clk;
//input [39:0] data;
output reg [2:0] direction;

input [9:0] xPos;
input [9:0] yPos;
input clk;

//direction 3'b0 is not moving
// 3'b001 up
// 3'b010 down
// 3'b011 right
// 3'b100 left

always @(clk)begin
		if(xPos >= 10'd462 && xPos <= 10'd562
			&& yPos >= 10'd462 && yPos <= 10'd562)begin
			
			direction <= 3'b0;
		end else 
		if(yPos > 10'd562 && xPos > 10'd462 && xPos < 10'd562)begin
			direction <= 3'b001;
		end else if(yPos < 10'd462 && xPos > 10'd462 && xPos < 10'd562)begin
			direction <= 3'b010;
		end else if(xPos > 10'd562 && yPos > 10'd462 && yPos < 10'd562)begin
			direction <= 3'b011;
		end else if(xPos < 10'd462 && yPos > 10'd462 && yPos < 10'd562)begin
			direction <= 3'b100;
		end /*else begin
			direction <= direction;
		end*/

	
end

endmodule
