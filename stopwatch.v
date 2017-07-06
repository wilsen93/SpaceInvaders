`include "clock_divider.v"
`include "debouncer.v"
`include "counter.v"
`include "seven_segment.v"
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:02:26 05/05/2016 
// Design Name: 
// Module Name:    stopwatch 
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
module stopwatch(clk,resetBtn,pauseBtn,selSwitch,adjSwitch,selBlock,sevenSegment
    );
	input resetBtn,pauseBtn,selSwitch,clk;
	input [1:0] adjSwitch;
	wire normal,twohz,debouncerclk,blink,display;
	wire resetWire,pauseWire;
	wire [6:0] minutes;
	wire [5:0] secondscount;
	output wire [7:0] sevenSegment;
	output wire [3:0] selBlock;
	 
	clock_divider clock(.clk(clk),.adj(twohz),.display(display),.debouncer(debouncerclk));
	//debouncer reset(.clk(debouncerclk),.button(resetBtn),.out(resetWire));
	//debouncer pause(.clk(debouncerclk),.button(pauseBtn),.out(pauseWire));
	//counter count(.clk_2hz(twohz),.adj(adjSwitch),.sel(selSwitch),.pause(pauseWire),.reset(resetWire),.minutes(minutes),.seconds(secondscount));
	seven_segment segDisplay(.minutes(minutes),.seconds(secondscount),.sel(selSwitch),.adj(adjSwitch),.clock(display),.sevensegment(sevenSegment),.select(selBlock));
endmodule
