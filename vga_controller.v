`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:32:08 05/20/2016 
// Design Name: 
// Module Name:    vga_controller 
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
module vga_controller(clk,clear,hsync,vsync,pixelx,pixely,draw
    );

input wire clk;
input wire clear;
output reg hsync;
output reg vsync;
output reg [10:0] pixelx;
output reg [10:0] pixely;
output reg draw;

//800x600 60 Hz using a 40 Mhz clock
reg [10:0] totalHorizontalPixels = 11'd1056;
reg [10:0] horizontalSyncPulse = 11'd128;
reg [10:0] totalVerticalLines = 11'd628;
reg [10:0] verticalSyncPulse = 11'd4;

reg [10:0] horizontalCounter = 11'd0;
reg [10:0] verticalCounter = 11'd0;

//Positioning offset;
reg [10:0] RightHorizontalOffset = 11'd1000; 
reg [10:0] LeftHorizontalOffset = 11'd200;
reg [10:0] TopVerticalOffset = 11'd14;
reg [10:0] BottomVerticalOffset = 11'd614;

always @(posedge clk)begin
	if(clear)begin
		horizontalCounter <= 11'd0;
		verticalCounter <= 11'd0;
	end else begin
		if(horizontalCounter == totalHorizontalPixels - 11'd1)begin
			horizontalCounter <= 11'd0;
			verticalCounter <= verticalCounter + 11'd1;
		end else begin
			horizontalCounter <= horizontalCounter + 11'd1;
		end
		
		if(verticalCounter == totalVerticalLines - 11'd1)begin
			verticalCounter <= 11'd0;
		end
	end
	
	if((horizontalCounter > LeftHorizontalOffset) && (horizontalCounter < RightHorizontalOffset) 
		&& (verticalCounter > TopVerticalOffset) && (verticalCounter < BottomVerticalOffset))begin
			draw <= 1'd1;
			pixelx <= horizontalCounter - LeftHorizontalOffset;
			pixely <= verticalCounter - TopVerticalOffset;
		end else begin
			draw <= 1'd0;
			pixelx <= 11'd0;
			pixely <= 11'd0;
		end
	
end

always @(*)begin
	if(horizontalCounter < horizontalSyncPulse)begin
		hsync = 1'd1;
	end else begin
		hsync = 1'd0;
	end
	
	if(verticalCounter < verticalSyncPulse)begin
		vsync = 1'd1;
	end else begin
		vsync = 1'd0;
	end
end



endmodule
