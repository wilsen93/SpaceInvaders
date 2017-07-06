`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:15:31 05/05/2016 
// Design Name: 
// Module Name:    seven_segment 
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
module seven_segment(minutes, seconds,sel,adj, clock, sevensegment, select
    );
input [6:0] minutes;
input [5:0] seconds;
input [1:0] adj;
input clock,sel;
reg [1:0] internal_counter = 2'b0;
reg [3:0] minuteTen = 4'b0;
reg [3:0] minuteOne = 4'b0;
reg [3:0] secondsTen = 4'b0;
reg [3:0] secondsOne = 4'b0;
reg [5:0] blinkInternalCount = 6'b0;
reg [1:0] selBlink = 2'b00;
output reg [7:0] sevensegment = 8'b0;
output reg [3:0] select = 4'b0;

always@(minutes or seconds)begin
	minuteTen = minutes / 10;
	minuteOne = minutes % 10;
	secondsTen = seconds / 10;
	secondsOne = seconds % 10;
end

always@(posedge clock)
begin
	if(adj != 2'b0)begin
		blinkInternalCount = blinkInternalCount + 1'b1;
		if(blinkInternalCount == 6'b0)begin
			if(sel == 1'b0)begin
				selBlink[0] = !selBlink[0];
				selBlink[1] = 1'b0;
			end else if(sel == 1'b1)begin
				selBlink[1] = !selBlink[1];
				selBlink[0] = 1'b0;
			end
		end
		
	end else begin
		selBlink = 2'b0;
	end

	if(internal_counter == 2'b11 && selBlink[0] == 1'b0)
	begin
		case(minuteTen)
			4'b0000: sevensegment = ~(8'b00111111);
			4'b0001: sevensegment = ~(8'b00000110);
			4'b0010: sevensegment = ~(8'b01011011);
			4'b0011: sevensegment = ~(8'b01001111);
			4'b0100: sevensegment = ~(8'b01100110);
			4'b0101: sevensegment = ~(8'b01101101);
			4'b0110: sevensegment = ~(8'b01111101);
			4'b0111: sevensegment = ~(8'b00000111);
			4'b1000: sevensegment = ~(8'b01111111);
			4'b1001: sevensegment = ~(8'b01101111);
		endcase
		select = ~(4'b1000);
	end else if(internal_counter == 2'b10 && selBlink[0] == 1'b0)
		begin
		case(minuteOne)
			4'b0000: sevensegment = ~(8'b00111111);
			4'b0001: sevensegment = ~(8'b00000110);
			4'b0010: sevensegment = ~(8'b01011011);
			4'b0011: sevensegment = ~(8'b01001111);
			4'b0100: sevensegment = ~(8'b01100110);
			4'b0101: sevensegment = ~(8'b01101101);
			4'b0110: sevensegment = ~(8'b01111101);
			4'b0111: sevensegment = ~(8'b00000111);
			4'b1000: sevensegment = ~(8'b01111111);
			4'b1001: sevensegment = ~(8'b01101111);
		endcase
		select = ~(4'b0100);
	end else if(internal_counter == 2'b01 && selBlink[1] == 1'b0)
		begin
		case(secondsTen)
			4'b0000: sevensegment = ~(8'b00111111);
			4'b0001: sevensegment = ~(8'b00000110);
			4'b0010: sevensegment = ~(8'b01011011);
			4'b0011: sevensegment = ~(8'b01001111);
			4'b0100: sevensegment = ~(8'b01100110);
			4'b0101: sevensegment = ~(8'b01101101);
			4'b0110: sevensegment = ~(8'b01111101);
			4'b0111: sevensegment = ~(8'b00000111);
			4'b1000: sevensegment = ~(8'b01111111);
			4'b1001: sevensegment = ~(8'b01101111);
		endcase
		select = ~(4'b0010);
	end else if(internal_counter == 2'b00 && selBlink[1] == 1'b0)	begin
		case(secondsOne)
			4'b0000: sevensegment = ~(8'b00111111);
			4'b0001: sevensegment = ~(8'b00000110);
			4'b0010: sevensegment = ~(8'b01011011);
			4'b0011: sevensegment = ~(8'b01001111);
			4'b0100: sevensegment = ~(8'b01100110);
			4'b0101: sevensegment = ~(8'b01101101);
			4'b0110: sevensegment = ~(8'b01111101);
			4'b0111: sevensegment = ~(8'b00000111);
			4'b1000: sevensegment = ~(8'b01111111);
			4'b1001: sevensegment = ~(8'b01101111);
		endcase
		select = ~(4'b0001);
	end
	
	if(internal_counter == 2'b00 && selBlink[1] == 1'b1)begin
		select = ~(4'b0100);
	end else if(internal_counter == 2'b01 && selBlink[1] == 1'b1)begin
		select = ~(4'b1000);
	end else if(internal_counter == 2'b10 && selBlink[0] == 1'b1)begin
		select = ~(4'b0001);
	end else if(internal_counter == 2'b11 && selBlink[0] == 1'b1)begin
		select = ~(4'b0010);
	end 
	
	internal_counter = internal_counter + 1'b1;
	
end



endmodule
