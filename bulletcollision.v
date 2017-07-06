`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:57:42 05/27/2016 
// Design Name: 
// Module Name:    bulletcollision 
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
module bulletcollision(topy,bottomy, leftx, rightx, bullet, collide
    );

input [10:0] topy;
input [10:0] bottomy;
input [10:0] leftx;
input [10:0] rightx;

input[43:0] bullet;

reg [10:0] bullets [3:0];

output reg collide = 1'b0;

//[3] bottomy, [2] topy, [1] rightx, [0] leftx
always @(topy or bottomy or leftx or rightx or bullet)
begin
	bullets[3] = bullet[43:33];
	bullets[2] = bullet[32:22];
	bullets[1] = bullet[21:11];
	bullets[0] = bullet[10:0];
	
	if(bullets[3] == topy && bullets[1] >= leftx && bullets[0] <= rightx) begin
		collide = 1'b1;
	end else if(bullets[2] == bottomy && bullets[1] >= leftx && bullets[0] <= rightx) begin
		collide = 1'b1;
	end else if(bullets[1] == leftx && bullets[2] <= bottomy && bullets[3] >= topy) begin
		collide = 1'b1;
	end else if(bullets[0] == rightx && bullets[2] <= bottomy && bullets[3] >=topy) begin
		collide = 1'b1;
	end else if(bullets[3] >= topy && bullets[2] <= bottomy && bullets[1] >= leftx && bullets[0] <= rightx) begin
		collide = 1'b1;
	end else begin
		collide = 1'b0;
	end
end
endmodule
