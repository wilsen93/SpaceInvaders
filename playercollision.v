`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:21:46 05/28/2016 
// Design Name: 
// Module Name:    playercollision 
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
module playercollision(topy,bottomy, leftx, rightx, wall, collide
    );

input [10:0] topy;
input [10:0] bottomy;
input [10:0] leftx;
input [10:0] rightx;

input[43:0] wall;

reg[10:0] walls[3:0];

output reg collide = 1'b0;

//[3] bottomy, [2] topy, [1] rightx, [0] leftx
always @(topy or bottomy or leftx or rightx or wall)
begin
	walls[3] = wall[43:33];
	walls[2] = wall[32:22];
	walls[1] = wall[21:11];
	walls[0] = wall[10:0];
	
	if(wall[2] == bottomy + 11'd1 && rightx <= wall[1] && leftx >= wall[0])begin
		collide = 1'b1;
	end
end

endmodule
