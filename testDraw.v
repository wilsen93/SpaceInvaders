`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:54:58 05/20/2016 
// Design Name: 
// Module Name:    testDraw 
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
module testDraw(masterclk,SW,RST,hsync,vsync,red,green,blue,MISO1,SS1,MOSI1,SCLK1,MISO2,SS2,MOSI2,SCLK2//,AN,SEG
    );
input wire masterclk;

wire clk;
wire clk_js;

output hsync;
output vsync;
output reg [2:0] red;
output reg [2:0] green;
output reg [1:0] blue;

wire [2:0] mapred;
wire [2:0] mapgreen;
wire [1:0] mapblue;

wire vgaclk;
reg clear = 0;
wire hs;
wire vs;
wire [10:0] pixelx;
wire [10:0] pixely;
wire draw;

assign hsync = ~hs;
assign vsync = ~vs;

//JOYSTICK STUFF
//WE NEED TO WIRE THE JOYSTICK INPUT OUTPUT TO UCF (THE MISO SOUP YO)
input [2:0] SW;
input RST;
input wire MISO1;					// Master In Slave Out, Pin 3, Port JA
output wire SS1;					// Slave Select, Pin 1, Port JA
output wire MOSI1;				// Master Out Slave In, Pin 2, Port JA
output wire SCLK1;				// Serial Clock, Pin 4, Port JA

input wire MISO2;					// Master In Slave Out, Pin 3, Port JA
output wire SS2;					// Slave Select, Pin 1, Port JA
output wire MOSI2;				// Master Out Slave In, Pin 2, Port JA
output wire SCLK2;				// Serial Clock, Pin 4, Port JA
//output [3:0] AN;			// Anodes for Seven Segment Display
//output [6:0] SEG;			// Cathodes for Seven Segment Display
			
//wire SS;						// Active low
//wire MOSI;					// Data transfer from master to slave
//wire SCLK;					// Serial clock that controls communication
//wire [3:0] AN;				// Anodes for Seven Segment Display
//wire [6:0] SEG;			// Cathodes for Seven Segment Display
wire [7:0] sndData;		// Holds data to be sent to PmodJSTK
// Signal to send/receive data to/from PmodJSTK
wire sndRec;
wire [39:0] jstkData1;
wire [9:0] posData;
wire [9:0] xPos1;
wire [9:0] yPos1;
wire fire1;

wire [39:0] jstkData2;
wire [9:0] xPos2;
wire [9:0] yPos2;
wire fire2;

wire [9:0] second;
wire resetclock;

// BELOW ARE THE MODULES USED FROM ONLINE SOURCES
// https://reference.digilentinc.com/pmod/pmod/jstk/example_code
// PmodJSTK USED FOR INTERACTING WITH JOYSTICK -- USES SPI INTERFACE
// ClkDiv_5Hz USED FOR TELLING THE JOYSTICK WHEN TO SEND DATA

//-----------------------------------------------
//  	  			PmodJSTK Interface
//-----------------------------------------------
PmodJSTK PmodJSTK_Int1(
.CLK(clk),
.sndRec(sndRec),
.DIN(sndData),
.MISO(MISO1),
.SS(SS1),
.SCLK(SCLK1),
.MOSI(MOSI1),
.DOUT(jstkData1)
);

PmodJSTK PmodJSTK_Int2(
.CLK(clk),
.sndRec(sndRec),
.DIN(sndData),
.MISO(MISO2),
.SS(SS2),
.SCLK(SCLK2),
.MOSI(MOSI2),
.DOUT(jstkData2)
);
//-----------------------------------------------
//  			 Send Receive Generator
//-----------------------------------------------
ClkDiv_5Hz genSndRec(
.CLK(clk),
.CLKOUT(sndRec)
);
//-----------------------------------------------
//  		Seven Segment Display Controller
//-----------------------------------------------
/*ssdCtrl DispCtrl(
.CLK(clk),
.DIN(posdata),
.AN(AN),
.SEG(SEG)
);*/

assign posData = (SW[0] == 1'b1) ? {jstkData1[9:8], jstkData1[23:16]} : {jstkData1[25:24], jstkData1[39:32]};

wire [2:0] direction1;
wire [2:0] direction2;

clk_divider clockdiv(.CLK_IN(masterclk),.CLK_OUT(vgaclk),.CLK_JOYSTICK(clk_js),.CLK_BOARD(clk));
vga_controller vga(.clk(vgaclk),.clear(clear),.hsync(hs),.vsync(vs),.pixelx(pixelx),.pixely(pixely),.draw(draw));
map drawMap(.reset(RST),.pixelx(pixelx), .pixely(pixely), .red(mapred), .green(mapgreen), .blue(mapblue),
 .clock(vgaclk),.direction1(direction1),.direction2(direction2),.fire1(fire1),.fire2(fire2),.resetclock(resetclock),.timer(second));
parseJoystick js1(.clk(vgaclk),.xPos(xPos1),.yPos(yPos1),.direction(direction1));
parseJoystick js2(.clk(vgaclk),.xPos(xPos2),.yPos(yPos2),.direction(direction2));
clock_divider seconds(.clk(clk),.second(second),.resetclock(resetclock));

always @(vgaclk)begin
	if(draw)begin
		red = mapred;
		green = mapgreen;
		blue = mapblue;
	end else begin
		red = 3'b0;
		green = 3'b0;
		blue = 2'b0;
	end
end

assign xPos1 = {jstkData1[25:24],jstkData1[39:32]};
assign yPos1 = {jstkData1[9:8],jstkData1[23:16]};
assign fire1 = jstkData1[1];

assign xPos2 = {jstkData2[25:24],jstkData2[39:32]};
assign yPos2 = {jstkData2[9:8],jstkData2[23:16]};
assign fire2 = jstkData2[1];

endmodule

