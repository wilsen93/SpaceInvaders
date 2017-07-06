`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:07:04 05/23/2016 
// Design Name: 
// Module Name:    map 
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
module map(reset, pixelx, pixely, red, green, blue, clock, direction1, direction2, fire1, fire2,resetclock, timer
    );

input [10:0] pixelx;
input [10:0] pixely;
input clock;
input [2:0] direction1;
input [2:0] direction2;
input reset;
input fire1;
input fire2;
input [9:0] timer;

output reg [2:0] red;
output reg [2:0] green;
output reg [1:0] blue;
output reg resetclock = 1'b0;

reg[3:0] seconds = 4'd0;
reg[3:0] tenSeconds = 4'd0;

reg [10:0] leftX = 11'd100;
reg [10:0] rightX = 11'd700;
reg [10:0] topY = 11'd100; 
reg [10:0] bottomY = 11'd500;

reg[10:0] upleftX = 11'd10;
reg[10:0] uprightX = 11'd90;
reg[10:0] uptopY = 11'd100;
reg[10:0] upbottomY = 11'd300;

reg[10:0] hpleftX = 11'd710;
reg[10:0] hprightX = 11'd790;
reg[10:0] hptopY = 11'd100;
reg[10:0] hpbottomY = 11'd300;

reg[10:0] timeleftX = 11'd710;
reg[10:0] timerightX = 11'd790;
reg[10:0] timetopY = 11'd350;
reg[10:0] timebottomY = 11'd380;

reg[10:0] timerleftX = 11'd710;
reg[10:0] timerrightX = 11'd790;
reg[10:0] timertopY = 11'd385;
reg[10:0] timerbottomY = 11'd485;

reg[10:0] player1leftX = 11'd375;
reg[10:0] player1rightX = 11'd425;
reg[10:0] player1topY = 11'd100;
reg[10:0] player1bottomY = 11'd150;

reg[10:0] player2leftX = 11'd375;
reg[10:0] player2rightX = 11'd425;
reg[10:0] player2topY = 11'd450;
reg[10:0] player2bottomY = 11'd500;

wire[43:0] player1c = {player1bottomY,player1topY,player1rightX,player1leftX};
wire[43:0] player2c = {player2bottomY,player2topY,player2rightX,player2leftX};

//[3] bottomy, [2] topy, [1] rightx, [0] leftx
reg[10:0] player1bullets[3:0] = {11'd0,11'd0,11'd0,11'd0};
reg fire1bool = 1'b0;

reg[10:0] player2bullets[3:0] = {11'd0,11'd0,11'd0,11'd0};
reg fire2bool = 1'b0;

reg[10:0] wall2[3:0] = {11'd345,11'd255,11'd201,11'd189};
reg[10:0] wall1[3:0] = {11'd345,11'd255,11'd611,11'd599};

reg[10:0] wall3[3:0] = {11'd201,11'd151,11'd202,11'd152};
reg[10:0] wall5[3:0] = {11'd201,11'd151,11'd648,11'd598};

reg[10:0] wall6[3:0] = {11'd449,11'd399,11'd202,11'd152};
reg[10:0] wall4[3:0] = {11'd449,11'd399,11'd648,11'd598};

reg[10:0] wall7[3:0] = {11'd306,11'd294,11'd525,11'd275};

reg[10:0] powerhealth[3:0] = {11'd308,11'd292,11'd570,11'd555};
reg[10:0] powerghost[3:0] = {11'd308,11'd292,11'd245,11'd230};
reg[10:0] powerspeed[3:0] = {11'd308,11'd292,11'd165,11'd150};

reg [1:0] p1health = 2'd1;
reg [1:0] p2health = 2'd1;
reg updatePlayer = 1'b0;

reg [2:0]face1 = 3'b010;
reg [2:0]face2 = 3'b001;
reg [2:0]bulletdir1 = 3'b0;
reg [2:0]bulletdir2 = 3'b0;
reg [10:0]p1bulletspeed = 11'd2;
reg [10:0]p2bulletspeed = 11'd2;

reg [10:0] halflength = 11'd25;
reg [10:0] legs = 11'd12;

wire [43:0] bullet1 = {player1bullets[3],player1bullets[2],player1bullets[1],player1bullets[0]};
wire [43:0] bullet2 = {player2bullets[3],player2bullets[2],player2bullets[1],player2bullets[0]};

wire collidep1g;
wire collidep2g;
wire collidep1h;
wire collidep2h;
wire collidep1s;
wire collidep2s;
reg[2:0] ghostpicked = 3'b001;

wire collidep1w1;
wire collidep1w2;
wire collidep1w3;
wire collidep1w4;
wire collidep1w5;
wire collidep1w6;
wire collidep1w7;

wire collidep2w1;
wire collidep2w2;
wire collidep2w3;
wire collidep2w4;
wire collidep2w5;
wire collidep2w6;
wire collidep2w7;

wire collide1;
wire collide2;

wire collideb1w1;
wire collideb1w2;
wire collideb1w3;
wire collideb1w4;
wire collideb1w5;
wire collideb1w6;
wire collideb1w7;

wire collideb2w1;
wire collideb2w2;
wire collideb2w3;
wire collideb2w4;
wire collideb2w5;
wire collideb2w6;
wire collideb2w7;

wire collidep1p2;

reg swap = 1'b0;
reg hasSwap = 1'b0;

//WALL COLLISION CHECK MODULES
//COLLIDE ON EACH OTHER
bulletcollision cp1p2(.topy(player2topY),.bottomy(player2bottomY),.leftx(player2leftX),.rightx(player2rightX),
	.bullet(player1c),.collide(collidep1p2));

//POWERUPS ON PLAYER
bulletcollision p1g(.topy(powerghost[2]),.bottomy(powerghost[3]),.leftx(powerghost[0]),.rightx(powerghost[1]),
	.bullet(player1c),.collide(collidep1g));
bulletcollision p2g(.topy(powerghost[2]),.bottomy(powerghost[3]),.leftx(powerghost[0]),.rightx(powerghost[1]),
	.bullet(player2c),.collide(collidep2g));

bulletcollision p1h(.topy(powerhealth[2]),.bottomy(powerhealth[3]),.leftx(powerhealth[0]),.rightx(powerhealth[1]),
	.bullet(player1c),.collide(collidep1h));
bulletcollision p2h(.topy(powerhealth[2]),.bottomy(powerhealth[3]),.leftx(powerhealth[0]),.rightx(powerhealth[1]),
	.bullet(player2c),.collide(collidep2h));
	
bulletcollision p1s(.topy(powerspeed[2]),.bottomy(powerspeed[3]),.leftx(powerspeed[0]),.rightx(powerspeed[1]),
	.bullet(player1c),.collide(collidep1s));
bulletcollision p2s(.topy(powerspeed[2]),.bottomy(powerhealth[3]),.leftx(powerspeed[0]),.rightx(powerspeed[1]),
	.bullet(player2c),.collide(collidep2s));
//PLAYER ON WALLS
bulletcollision p1w1(.topy(wall1[2]),.bottomy(wall1[3]),.leftx(wall1[0]),.rightx(wall1[1]),
	.bullet(player1c),.collide(collidep1w1));
bulletcollision p1w2(.topy(wall2[2]),.bottomy(wall2[3]),.leftx(wall2[0]),.rightx(wall2[1]),
	.bullet(player1c),.collide(collidep1w2));
bulletcollision p1w3(.topy(wall3[2]),.bottomy(wall3[3]),.leftx(wall3[0]),.rightx(wall3[1]),
	.bullet(player1c),.collide(collidep1w3));
bulletcollision p1w4(.topy(wall4[2]),.bottomy(wall4[3]),.leftx(wall4[0]),.rightx(wall4[1]),
	.bullet(player1c),.collide(collidep1w4));
bulletcollision p1w5(.topy(wall5[2]),.bottomy(wall5[3]),.leftx(wall5[0]),.rightx(wall5[1]),
	.bullet(player1c),.collide(collidep1w5));
bulletcollision p1w6(.topy(wall6[2]),.bottomy(wall6[3]),.leftx(wall6[0]),.rightx(wall6[1]),
	.bullet(player1c),.collide(collidep1w6));
bulletcollision p1w7(.topy(wall7[2]),.bottomy(wall7[3]),.leftx(wall7[0]),.rightx(wall7[1]),
	.bullet(player1c),.collide(collidep1w7));
	
bulletcollision p2w1(.topy(wall1[2]),.bottomy(wall1[3]),.leftx(wall1[0]),.rightx(wall1[1]),
	.bullet(player2c),.collide(collidep2w1));
bulletcollision p2w2(.topy(wall2[2]),.bottomy(wall2[3]),.leftx(wall2[0]),.rightx(wall2[1]),
	.bullet(player2c),.collide(collidep2w2));
bulletcollision p2w3(.topy(wall3[2]),.bottomy(wall3[3]),.leftx(wall3[0]),.rightx(wall3[1]),
	.bullet(player2c),.collide(collidep2w3));
bulletcollision p2w4(.topy(wall4[2]),.bottomy(wall4[3]),.leftx(wall4[0]),.rightx(wall4[1]),
	.bullet(player2c),.collide(collidep2w4));
bulletcollision p2w5(.topy(wall5[2]),.bottomy(wall5[3]),.leftx(wall5[0]),.rightx(wall5[1]),
	.bullet(player2c),.collide(collidep2w5));
bulletcollision p2w6(.topy(wall6[2]),.bottomy(wall6[3]),.leftx(wall6[0]),.rightx(wall6[1]),
	.bullet(player2c),.collide(collidep2w6));
bulletcollision p2w7(.topy(wall7[2]),.bottomy(wall7[3]),.leftx(wall7[0]),.rightx(wall7[1]),
	.bullet(player2c),.collide(collidep2w7));

//BULLETS ON WALLS
bulletcollision b1w1(.topy(wall1[2]), .bottomy(wall1[3]), .leftx(wall1[0]), .rightx(wall1[1]), 
	.bullet(bullet1), .collide(collideb1w1) );
bulletcollision b1w2(.topy(wall2[2]), .bottomy(wall2[3]), .leftx(wall2[0]), .rightx(wall2[1]), 
	.bullet(bullet1), .collide(collideb1w2) );
bulletcollision b1w3(.topy(wall3[2]), .bottomy(wall3[3]), .leftx(wall3[0]), .rightx(wall3[1]), 
	.bullet(bullet1), .collide(collideb1w3) );
bulletcollision b1w4(.topy(wall4[2]), .bottomy(wall4[3]), .leftx(wall4[0]), .rightx(wall4[1]), 
	.bullet(bullet1), .collide(collideb1w4) );
bulletcollision b1w5(.topy(wall5[2]), .bottomy(wall5[3]), .leftx(wall5[0]), .rightx(wall5[1]), 
	.bullet(bullet1), .collide(collideb1w5) );
bulletcollision b1w6(.topy(wall6[2]), .bottomy(wall6[3]), .leftx(wall6[0]), .rightx(wall6[1]), 
	.bullet(bullet1), .collide(collideb1w6) );
bulletcollision b1w7(.topy(wall7[2]), .bottomy(wall7[3]), .leftx(wall7[0]), .rightx(wall7[1]), 
	.bullet(bullet1), .collide(collideb1w7) );

bulletcollision b2w1(.topy(wall1[2]), .bottomy(wall1[3]), .leftx(wall1[0]), .rightx(wall1[1]), 
	.bullet(bullet2), .collide(collideb2w1) );
bulletcollision b2w2(.topy(wall2[2]), .bottomy(wall2[3]), .leftx(wall2[0]), .rightx(wall2[1]), 
	.bullet(bullet2), .collide(collideb2w2) );
bulletcollision b2w3(.topy(wall3[2]), .bottomy(wall3[3]), .leftx(wall3[0]), .rightx(wall3[1]), 
	.bullet(bullet2), .collide(collideb2w3) );
bulletcollision b2w4(.topy(wall4[2]), .bottomy(wall4[3]), .leftx(wall4[0]), .rightx(wall4[1]), 
	.bullet(bullet2), .collide(collideb2w4) );
bulletcollision b2w5(.topy(wall5[2]), .bottomy(wall5[3]), .leftx(wall5[0]), .rightx(wall5[1]), 
	.bullet(bullet2), .collide(collideb2w5) );
bulletcollision b2w6(.topy(wall6[2]), .bottomy(wall6[3]), .leftx(wall6[0]), .rightx(wall6[1]), 
	.bullet(bullet2), .collide(collideb2w6) );
bulletcollision b2w7(.topy(wall7[2]), .bottomy(wall7[3]), .leftx(wall7[0]), .rightx(wall7[1]), 
	.bullet(bullet2), .collide(collideb2w7) );

//BULLETS ON PLAYER
bulletcollision p1b2(.topy(player1topY), .bottomy(player1bottomY), .leftx(player1leftX), .rightx(player1rightX), 
	.bullet(bullet2), .collide(collide1) );
bulletcollision p2b1(.topy(player2topY), .bottomy(player2bottomY), .leftx(player2leftX), .rightx(player2rightX), 
	.bullet(bullet1), .collide(collide2) );
	
always @(timer)begin
	if(timer == 11'd0)begin
		swap = 1'b1;
	end else begin
		swap = 1'b0;
	end
end

always @(posedge clock)begin

	if(timer != 11'd0)begin
		hasSwap <= 1'b0;
	end
	
	resetclock <= 1'b0;
	if(pixelx >= leftX && pixelx <= rightX 
		&& pixely >= topY && pixely <= bottomY)begin
		
		if(pixelx == 400 && pixely == 300)begin
			updatePlayer <= 1'b1;
		end else begin
			updatePlayer <= 1'b0;
		end
		
		//FIRE BULLET1
		if(fire1 && !fire1bool)begin
			fire1bool <= 1'b1;
			if(face1 == 3'b001)begin
				player1bullets[3] <= player1topY - 1;
				player1bullets[2] <= player1topY - legs - 1;
				player1bullets[1] <= player1rightX - (11'd3 * legs)/11'd2;
				player1bullets[0] <= player1leftX + (11'd3 * legs)/11'd2;
				bulletdir1 <= face1;
			end else if(face1 == 3'b010)begin
				player1bullets[3] <= player1bottomY + legs + 1;
				player1bullets[2] <= player1bottomY + 1;
				player1bullets[1] <= player1rightX - (11'd3 * legs)/11'd2;
				player1bullets[0] <= player1leftX + (11'd3 * legs)/11'd2;
				bulletdir1 <= face1;
			end else if(face1 == 3'b011)begin
				player1bullets[3] <= player1bottomY - (11'd3 * legs)/11'd2;
				player1bullets[2] <= player1topY + (11'd3 * legs)/11'd2;
				player1bullets[1] <= player1rightX + legs + 1;
				player1bullets[0] <= player1rightX + 1;
				bulletdir1 <= face1;
			end else if(face1 == 3'b100)begin
				player1bullets[3] <= player1bottomY - (11'd3 * legs)/11'd2;
				player1bullets[2] <= player1topY + (11'd3 * legs)/11'd2;
				player1bullets[1] <= player1leftX - 1;
				player1bullets[0] <= player1leftX - legs - 1;
				bulletdir1 <= face1;
			end
		end
		
		//FIRE BULLET2
		if(fire2 && !fire2bool)begin
			fire2bool <= 1'b1;
			if(face2 == 3'b001)begin
				player2bullets[3] <= player2topY - 1;
				player2bullets[2] <= player2topY - legs - 1;
				player2bullets[1] <= player2rightX - (11'd3 * legs)/11'd2;
				player2bullets[0] <= player2leftX + (11'd3 * legs)/11'd2;
				bulletdir2 <= face2;
			end else if(face2 == 3'b010)begin
				player2bullets[3] <= player2bottomY + legs + 1;
				player2bullets[2] <= player2bottomY + 1;
				player2bullets[1] <= player2rightX - (11'd3 * legs)/11'd2;
				player2bullets[0] <= player2leftX + (11'd3 * legs)/11'd2;
				bulletdir2 <= face2;
			end else if(face2 == 3'b011)begin
				player2bullets[3] <= player2bottomY - (11'd3 * legs)/11'd2;
				player2bullets[2] <= player2topY + (11'd3 * legs)/11'd2;
				player2bullets[1] <= player2rightX + legs + 1;
				player2bullets[0] <= player2rightX + 1;
				bulletdir2 <= face2;
			end else if(face2 == 3'b100)begin
				player2bullets[3] <= player2bottomY - (11'd3 * legs)/11'd2;
				player2bullets[2] <= player2topY + (11'd3 * legs)/11'd2;
				player2bullets[1] <= player2leftX - 1;
				player2bullets[0] <= player2leftX - legs - 1;
				bulletdir2 <= face2;
			end
		end
		
		if(collide1)begin
			p1health <= p1health - 2'd1;
			fire2bool <= 1'b0;
			player2bullets[3] <= 11'd0;
			player2bullets[2] <= 11'd0;
			player2bullets[1] <= 11'd0;
			player2bullets[0] <= 11'd0;
		end else if(collide2)begin
			p2health <= p2health - 2'd1;
			fire1bool <= 1'b0;
			player1bullets[3] <= 11'd0;
			player1bullets[2] <= 11'd0;
			player1bullets[1] <= 11'd0;
			player1bullets[0] <= 11'd0;
		end
		
		//RESET
		if(p1health == 2'd0 || p2health == 2'd0) begin
			player1leftX <= 11'd375;
			player1rightX <= 11'd425;
			player1topY <= 11'd100;
			player1bottomY <= 11'd150;
			face1 <= 3'b010;
			
			player2leftX <= 11'd375;
			player2rightX <= 11'd425;
			player2topY <= 11'd450;
			player2bottomY <= 11'd500;
			face2 <= 3'b001;
			
			fire1bool <= 1'b0;
			player1bullets[3] <= 11'd0;
			player1bullets[2] <= 11'd0;
			player1bullets[1] <= 11'd0;
			player1bullets[0] <= 11'd0;
			
			fire2bool <= 1'b0;
			player2bullets[3] <= 11'd0;
			player2bullets[2] <= 11'd0;
			player2bullets[1] <= 11'd0;
			player2bullets[0] <= 11'd0;
			
			resetclock <= 1'b1;
			ghostpicked <= 3'b001;
			powerghost[3] <= 11'd308;
			powerghost[2] <= 11'd292;
			powerghost[1] <= 11'd245;
			powerghost[0] <= 11'd230;
			
			powerhealth[3] <= 11'd308;
			powerhealth[2] <= 11'd292;
			powerhealth[1] <= 11'd570;
			powerhealth[0] <= 11'd555;
			p1health <= 2'd1;
			p2health <= 2'd1;
			
			powerspeed[3] <= 11'd308;
			powerspeed[2] <= 11'd292;
			powerspeed[1] <= 11'd165;
			powerspeed[0] <= 11'd150;
			p1bulletspeed <= 11'd2;
			p2bulletspeed <= 11'd2;
		end
		
		if((collideb1w1 || collideb1w2 || collideb1w3 || collideb1w4
			|| collideb1w5 || collideb1w6 || collideb1w7) && ghostpicked != 3'b010)begin
				fire1bool <= 1'b0;
				player1bullets[3] <= 11'd0;
				player1bullets[2] <= 11'd0;
				player1bullets[1] <= 11'd0;
				player1bullets[0] <= 11'd0;
			end
			
		if((collideb2w1 || collideb2w2 || collideb2w3 || collideb2w4
			|| collideb2w5 || collideb2w6 || collideb2w7) && ghostpicked != 3'b100)begin
				fire2bool <= 1'b0;
				player2bullets[3] <= 11'd0;
				player2bullets[2] <= 11'd0;
				player2bullets[1] <= 11'd0;
				player2bullets[0] <= 11'd0;
			end
		
		if(reset || collidep1p2)begin
			player1leftX <= 11'd375;
			player1rightX <= 11'd425;
			player1topY <= 11'd100;
			player1bottomY <= 11'd150;
			face1 <= 3'b010;
			
			player2leftX <= 11'd375;
			player2rightX <= 11'd425;
			player2topY <= 11'd450;
			player2bottomY <= 11'd500;
			face2 <= 3'b001;
			
			fire1bool <= 1'b0;
			player1bullets[3] <= 11'd0;
			player1bullets[2] <= 11'd0;
			player1bullets[1] <= 11'd0;
			player1bullets[0] <= 11'd0;
			
			fire2bool <= 1'b0;
			player2bullets[3] <= 11'd0;
			player2bullets[2] <= 11'd0;
			player2bullets[1] <= 11'd0;
			player2bullets[0] <= 11'd0;
			
			resetclock <= 1'b1;
			ghostpicked <= 3'b001;
			powerghost[3] <= 11'd308;
			powerghost[2] <= 11'd292;
			powerghost[1] <= 11'd245;
			powerghost[0] <= 11'd230;
			
			powerhealth[3] <= 11'd308;
			powerhealth[2] <= 11'd292;
			powerhealth[1] <= 11'd570;
			powerhealth[0] <= 11'd555;
			p1health <= 2'd1;
			p2health <= 2'd1;
			
			powerspeed[3] <= 11'd308;
			powerspeed[2] <= 11'd292;
			powerspeed[1] <= 11'd165;
			powerspeed[0] <= 11'd150;
			p1bulletspeed <= 11'd2;
			p2bulletspeed <= 11'd2;
		end
		
		if(swap && hasSwap == 1'b0)begin
			player1leftX <= player2leftX;
			player1rightX <= player2rightX;
			player1topY <= player2topY;
			player1bottomY <= player2bottomY;
			
			player2leftX <= player1leftX;
			player2rightX <= player1rightX;
			player2topY <= player1topY;
			player2bottomY <= player1bottomY;
			
			hasSwap <= 1'b1;
		end
		
		//POWER UPS
		if(collidep1g || collidep2g)begin
			if(collidep1g)begin
				ghostpicked <= 3'b010;
			end else if(collidep2g)begin
				ghostpicked <= 3'b100;
			end
			
			powerghost[3] <= 11'd0;
			powerghost[2] <= 11'd0;
			powerghost[1] <= 11'd0;
			powerghost[0] <= 11'd0;
		end
		
		
		if(collidep1h || collidep2h)begin
			if(collidep1h)begin
				p1health <= p1health + 2'd1;
			end else if(collidep2h)begin
				p2health <= p2health + 2'd1;
			end
			
			powerhealth[3] <= 11'd0;
			powerhealth[2] <= 11'd0;
			powerhealth[1] <= 11'd0;
			powerhealth[0] <= 11'd0;
		end
		
		if(collidep1s || collidep2s)begin
			if(collidep1s)begin
				p1bulletspeed <= 3'd4;
			end else if(collidep2s)begin
				p2bulletspeed <= 3'd4;
			end
			
			powerspeed[3] <= 11'd0;
			powerspeed[2] <= 11'd0;
			powerspeed[1] <= 11'd0;
			powerspeed[0] <= 11'd0;
			
		end
		
		//PLAYER MOVEMENT
		if(!collidep1w1 && !collidep1w2 && !collidep1w3 && !collidep1w4 && !collidep1w5 && 
			!collidep1w6 && !collidep1w7)begin
			if(direction1 == 3'b0 && updatePlayer == 1'b1)begin
			end else if(direction1 == 3'b001 && updatePlayer == 1'b1)begin
				if(player1topY > 100)begin
					player1topY <= player1topY - 11'd1;
					player1bottomY <= player1bottomY - 11'd1;
					face1 <= direction1;
				end

			end else if(direction1 == 3'b010 && updatePlayer == 1'b1)begin
				if(player1bottomY < 500)begin
					player1topY <= player1topY + 11'd1;
					player1bottomY <= player1bottomY + 11'd1;
					face1 <= direction1;
				end
			end else if(direction1 == 3'b011 && updatePlayer == 1'b1)begin
				if(player1rightX < 700)begin
					player1leftX <= player1leftX + 11'd1;
					player1rightX <= player1rightX + 11'd1;
					face1 <= direction1;

				end
			end else if(direction1 == 3'b100 && updatePlayer == 1'b1)begin
				if(player1leftX > 100)begin
					player1leftX <= player1leftX - 11'd1;
					player1rightX <= player1rightX - 11'd1;
					face1 <= direction1;
				end
			end 
		end else begin
			if(face1 == 3'b001 && updatePlayer == 1'b1)begin
				player1topY <= player1topY + 11'd1;
				player1bottomY  <= player1bottomY + 11'd1;
			end else if(face1 == 3'b010 && updatePlayer == 1'b1)begin
				player1topY <= player1topY - 11'd1;
				player1bottomY <= player1bottomY - 11'd1;
			end else if(face1 == 3'b011 && updatePlayer == 1'b1)begin
				player1rightX <= player1rightX - 11'd1;
				player1leftX <= player1leftX - 11'd1;
			end else if(face1 == 3'b100 && updatePlayer == 1'b1)begin
				player1rightX <= player1rightX + 11'd1;
				player1leftX <= player1leftX + 11'd1;
			end
		end
		
		if(!collidep2w1 && !collidep2w2 && !collidep2w3 && !collidep2w4 && !collidep2w5 && 
			!collidep2w6 && !collidep2w7)begin
			if(direction2 == 3'b0 && updatePlayer == 1'b1)begin
			end else if(direction2 == 3'b001 && updatePlayer == 1'b1)begin
				if(player2topY > 100)begin
					player2topY <= player2topY - 11'd1;
					player2bottomY <= player2bottomY - 11'd1;
					face2 <= direction2;
				end

			end else if(direction2 == 3'b010 && updatePlayer == 1'b1)begin
				if(player2bottomY < 500)begin
					player2topY <= player2topY + 11'd1;
					player2bottomY <= player2bottomY + 11'd1;
					face2 <= direction2;
				end
			end else if(direction2 == 3'b011 && updatePlayer == 1'b1)begin
				if(player2rightX < 700)begin
					player2leftX <= player2leftX + 11'd1;
					player2rightX <= player2rightX + 11'd1;
					face2 <= direction2;
				end
			end else if(direction2 == 3'b100 && updatePlayer == 1'b1)begin
				if(player2leftX > 100)begin
					player2leftX <= player2leftX - 11'd1;
					player2rightX <= player2rightX - 11'd1;
					face2 <= direction2;
				end
			end 
		end else begin
			if(face2 == 3'b001 && updatePlayer == 1'b1)begin
				player2topY <= player2topY + 11'd1;
				player2bottomY  <= player2bottomY + 11'd1;
			end else if(face2 == 3'b010 && updatePlayer == 1'b1)begin
				player2topY <= player2topY - 11'd1;
				player2bottomY <= player2bottomY - 11'd1;
			end else if(face2 == 3'b011 && updatePlayer == 1'b1)begin
				player2rightX <= player2rightX - 11'd1;
				player2leftX <= player2leftX - 11'd1;
			end else if(face2 == 3'b100 && updatePlayer == 1'b1)begin
				player2rightX <= player2rightX + 11'd1;
				player2leftX <= player2leftX + 11'd1;
			end
		end
		//BULLET MOVEMENT
		if(bulletdir1 == 3'b001 && updatePlayer == 1'b1 && fire1bool)begin
			if(player1bullets[2] > 11'd100)begin
				player1bullets[2] <= player1bullets[2] - p1bulletspeed;
				player1bullets[3] <= player1bullets[3] - p1bulletspeed;
			end else begin
				fire1bool <= 1'b0;
				player1bullets[3] <= 11'd0;
				player1bullets[2] <= 11'd0;
				player1bullets[1] <= 11'd0;
				player1bullets[0] <= 11'd0;
			end
		end else if(bulletdir1 == 3'b010 && updatePlayer == 1'b1 && fire1bool)begin
			if(player1bullets[3] < 11'd500)begin
				player1bullets[2] <= player1bullets[2] + p1bulletspeed;
				player1bullets[3] <= player1bullets[3] + p1bulletspeed;
			end else begin
				fire1bool <= 1'b0;
				player1bullets[3] <= 11'd0;
				player1bullets[2] <= 11'd0;
				player1bullets[1] <= 11'd0;
				player1bullets[0] <= 11'd0;
			end
		end if(bulletdir1 == 3'b011 && updatePlayer == 1'b1 && fire1bool)begin
			if(player1bullets[1] < 11'd700)begin
				player1bullets[1] <= player1bullets[1] + p1bulletspeed;
				player1bullets[0] <= player1bullets[0] + p1bulletspeed;
			end else begin
				fire1bool <= 1'b0;
				player1bullets[3] <= 11'd0;
				player1bullets[2] <= 11'd0;
				player1bullets[1] <= 11'd0;
				player1bullets[0] <= 11'd0;
			end
		end if(bulletdir1 == 3'b100 && updatePlayer == 1'b1 && fire1bool)begin
			if(player1bullets[0] > 11'd100)begin
				player1bullets[1] <= player1bullets[1] - p1bulletspeed;
				player1bullets[0] <= player1bullets[0] - p1bulletspeed;
			end else begin
				fire1bool <= 1'b0;
				player1bullets[3] <= 11'd0;
				player1bullets[2] <= 11'd0;
				player1bullets[1] <= 11'd0;
				player1bullets[0] <= 11'd0;
			end
		end 
		
		if(bulletdir2 == 3'b001 && updatePlayer == 1'b1 && fire2bool)begin
			if(player2bullets[2] > 11'd100)begin
				player2bullets[2] <= player2bullets[2] - p2bulletspeed;
				player2bullets[3] <= player2bullets[3] - p2bulletspeed;
			end else begin
				fire2bool <= 1'b0;
				player2bullets[3] <= 11'd0;
				player2bullets[2] <= 11'd0;
				player2bullets[1] <= 11'd0;
				player2bullets[0] <= 11'd0;
			end
		end else if(bulletdir2 == 3'b010 && updatePlayer == 1'b1 && fire2bool)begin
			if(player2bullets[3] < 11'd500)begin
				player2bullets[2] <= player2bullets[2] + p2bulletspeed;
				player2bullets[3] <= player2bullets[3] + p2bulletspeed;
			end else begin
				fire2bool <= 1'b0;
				player2bullets[3] <= 11'd0;
				player2bullets[2] <= 11'd0;
				player2bullets[1] <= 11'd0;
				player2bullets[0] <= 11'd0;
			end
		end if(bulletdir2 == 3'b011 && updatePlayer == 1'b1 && fire2bool)begin
			if(player2bullets[1] < 11'd700)begin
				player2bullets[1] <= player2bullets[1] + p2bulletspeed;
				player2bullets[0] <= player2bullets[0] + p2bulletspeed;
			end else begin
				fire2bool <= 1'b0;
				player2bullets[3] <= 11'd0;
				player2bullets[2] <= 11'd0;
				player2bullets[1] <= 11'd0;
				player2bullets[0] <= 11'd0;
			end
		end if(bulletdir2 == 3'b100 && updatePlayer == 1'b1 && fire2bool)begin
			if(player2bullets[0] > 11'd100)begin
				player2bullets[1] <= player2bullets[1] - p2bulletspeed;
				player2bullets[0] <= player2bullets[0] - p2bulletspeed;
			end else begin
				fire2bool <= 1'b0;
				player2bullets[3] <= 11'd0;
				player2bullets[2] <= 11'd0;
				player2bullets[1] <= 11'd0;
				player2bullets[0] <= 11'd0;
			end
		end
		
		//WALL POSITIONING AND COLOR FOR LOCATION OF OBJECTS
		if(pixelx >= powerspeed[0] && pixelx <= powerspeed[1]
			&& pixely >= powerspeed[2] && pixely <= powerspeed[3])begin
			
			red <= 3'b111;
			green <= 3'b0;
			blue <= 2'b11;
		
		end else if(pixelx >= powerhealth[0] && pixelx <= powerhealth[1]
			&& pixely >= powerhealth[2] && pixely <= powerhealth[3])begin
			
			red <= 3'b010;
			green <= 3'b100;
			blue <= 2'b10;
			
			
		end else
		if(pixelx >= powerghost[0] && pixelx <= powerghost[1]
			&& pixely >= powerghost[2] && pixely <= powerghost[3])begin
			
			red <= 3'b100;
			green <= 3'b010;
			blue <= 2'b01;
			
			
		end else
		if(pixelx >= wall7[0] && pixelx <= wall7[1]
			&& pixely >= wall7[2] && pixely <= wall7[3])begin

			red <= 3'b0;
			green <= 3'b0;
			blue <= 2'b0;
			
		end else
		if(pixelx >= wall6[0] && pixelx <= wall6[1]
			&& pixely >= wall6[2] && pixely <= wall6[3])begin

			red <= 3'b0;
			green <= 3'b0;
			blue <= 2'b0;
			
		end else
		if(pixelx >= wall5[0] && pixelx <= wall5[1]
			&& pixely >= wall5[2] && pixely <= wall5[3])begin

			red <= 3'b0;
			green <= 3'b0;
			blue <= 2'b0;
			
		end else
		if(pixelx >= wall4[0] && pixelx <= wall4[1]
			&& pixely >= wall4[2] && pixely <= wall4[3])begin

			red <= 3'b0;
			green <= 3'b0;
			blue <= 2'b0;
			
		end else
		if(pixelx >= wall3[0] && pixelx <= wall3[1]
			&& pixely >= wall3[2] && pixely <= wall3[3])begin

			red <= 3'b0;
			green <= 3'b0;
			blue <= 2'b0;
			
		end else
		if(pixelx >= wall2[0] && pixelx <= wall2[1]
			&& pixely >= wall2[2] && pixely <= wall2[3])begin

			red <= 3'b0;
			green <= 3'b0;
			blue <= 2'b0;
			
		end else
		if(pixelx >= wall1[0] && pixelx <= wall1[1]
			&& pixely >= wall1[2] && pixely <= wall1[3])begin

			red <= 3'b0;
			green <= 3'b0;
			blue <= 2'b0;
			
		end else
		if(pixelx >= player2bullets[0] && pixelx <= player2bullets[1]
			&& pixely >= player2bullets[2] && pixely <= player2bullets[3])begin

			red <= 3'b111;
			green <= 3'b0;
			blue <= 2'b0;
			
		end else
		if(pixelx >= player1bullets[0] && pixelx <= player1bullets[1]
			&& pixely >= player1bullets[2] && pixely <= player1bullets[3])begin

			red <= 3'b0;
			green <= 3'b0;
			blue <= 2'b11;
			
		end else
		if(pixelx >= player1leftX && pixelx <= player1rightX 
			&& pixely >= player1topY && pixely <= player1bottomY)begin

			red <= 3'b0;
			green <= 3'b0;
			blue <= 2'b11;
			
			if(face1 == 3'b001 && (pixelx >= player1leftX+legs && pixelx <= player1rightX-legs 
			&& pixely >= player1topY && pixely <= player1bottomY-halflength))
			begin
				red <= 3'b111;
				green <= 3'b111;
				blue <= 2'b11;
			end
			else if(face1 == 3'b010 && (pixelx >= player1leftX+legs && pixelx <= player1rightX-legs 
			&& pixely >= player1topY+halflength && pixely <= player1bottomY))
			begin
				red <= 3'b111;
				green <= 3'b111;
				blue <= 2'b11;
			end
			else if(face1 == 3'b011 && (pixelx >= player1leftX+halflength && pixelx <= player1rightX 
			&& pixely >= player1topY+legs && pixely <= player1bottomY-legs))
			begin
				red <= 3'b111;
				green <= 3'b111;
				blue <= 2'b11;
			end else if(face1 == 3'b100 && (pixelx >= player1leftX && pixelx <= player1rightX - halflength
			&& pixely >= player1topY+legs && pixely <= player1bottomY-legs))
			begin
				red <= 3'b111;
				green <= 3'b111;
				blue <= 2'b11;
			end
			
		end else if(pixelx >= player2leftX && pixelx <= player2rightX 
			&& pixely >= player2topY && pixely <= player2bottomY)begin
			red <= 3'b111;
			green <= 3'b0;
			blue <= 2'b0;
			
			
			if(face2 == 3'b001 && (pixelx >= player2leftX+legs && pixelx <= player2rightX-legs 
			&& pixely >= player2topY && pixely <= player2bottomY-halflength))
			begin
				red <= 3'b111;
				green <= 3'b111;
				blue <= 2'b11;
			end
			else if(face2 == 3'b010 && (pixelx >= player2leftX+legs && pixelx <= player2rightX-legs 
			&& pixely >= player2topY+halflength && pixely <= player2bottomY))
			begin
				red <= 3'b111;
				green <= 3'b111;
				blue <= 2'b11;
			end
			else if(face2 == 3'b011 && (pixelx >= player2leftX+halflength && pixelx <= player2rightX 
			&& pixely >= player2topY+legs && pixely <= player2bottomY-legs))
			begin
				red <= 3'b111;
				green <= 3'b111;
				blue <= 2'b11;
			end else if(face2 == 3'b100 && (pixelx >= player2leftX && pixelx <= player2rightX - halflength
			&& pixely >= player2topY+legs && pixely <= player2bottomY-legs))
			begin
				red <= 3'b111;
				green <= 3'b111;
				blue <= 2'b11;
			end
			
			
		end else begin
			red <= 3'b111;
			green <= 3'b111;
			blue <= 2'b11;
		end
		
	end else begin
		red <= 3'b0;
		green <= 3'b0;
		blue <= 2'b0;
	end
	//POWER UPGRADE DISPLAY
		if(pixelx >= upleftX && pixelx <= uprightX 
		&& pixely >= uptopY && pixely <= upbottomY)begin
			
			if(pixelx >= upleftX + 11'd10 && pixelx <= uprightX - 11'd60
				&& pixely <= uptopY + 11'd80)begin
				red <= 3'b0;
				green <= 3'b0;
				blue <= 2'b0;
			end else if(pixelx >= upleftX + 11'd30 && pixelx <= upleftX + 11'd40)begin
				red <= 3'b0;
				green <= 3'b0;
				blue <= 2'b0;
			end else if(pixelx >= upleftX + 11'd50 && (pixelx <= uprightX - 11'd10 || pixely >= upbottomY - 11'd150)
				&& ((pixely >= uptopY + 11'd10 && pixely <= uptopY + 11'd40) || (pixely >= upbottomY - 11'd150 && pixely <= upbottomY - 11'd110)))begin
				red <= 3'b0;
				green <= 3'b0;
				blue <= 2'b0;
			end else if(pixely >= upbottomY - 11'd110)begin
				red <= 3'b0;
				green <= 3'b0;
				blue <= 2'b0;
			end else begin
				red <= 3'b111;
				green <= 3'b111;
				blue <= 2'b11;
			end
			
			if(pixelx <= upleftX + 11'd30 && pixely >= uptopY + 11'd100 && pixely <= upbottomY - 11'd70)begin
				if(pixelx >= upleftX + 11'd5 && pixelx <= upleftX + 11'd25 && pixely <= uptopY + 11'd115)begin
					red <= 3'b111;
					green <= 3'b111;
					blue <= 2'b11;
				end else begin
					red <= 3'b0;
					green <= 3'b0;
					blue <= 2'b11;
				end
			end
			
			if(p1bulletspeed == 11'd4)begin
				if(pixelx >= upleftX + 11'd35 && pixelx <= upleftX + 11'd40 && pixely >= uptopY + 11'd100 && pixely <= upbottomY - 11'd70)begin
					red <= 3'b111;
					green <= 3'b0;
					blue <= 3'b11;
				end
			end
			
			if(p1health == 3'd2)begin
				if(pixelx >= upleftX + 11'd45 && pixelx <= upleftX + 11'd50 && pixely >= uptopY + 11'd100 && pixely <= upbottomY - 11'd70)begin
					red <= 3'b010;
				green <= 3'b100;
				blue <= 2'b10;
				end
			end
			
			if(ghostpicked == 3'b010)begin
				if(pixelx >= upleftX + 11'd55 && pixelx <= upleftX + 11'd60 && pixely >= uptopY + 11'd100 && pixely <= upbottomY - 11'd70)begin
					red <= 3'b100;
				green <= 3'b010;
				blue <= 2'b01;
				end
			end
			
			if(pixelx <= upleftX + 11'd30 && pixely >= uptopY + 11'd140 && pixely <= upbottomY - 11'd30)begin
				if(pixelx >= upleftX + 11'd5 && pixelx <= upleftX + 11'd25 && pixely <= uptopY + 11'd155)begin
					red <= 3'b111;
					green <= 3'b111;
					blue <= 2'b11;
				end else begin
					red <= 3'b111;
					green <= 3'b0;
					blue <= 2'b0;
				end
			end
			
			if(p2bulletspeed == 11'd4)begin
				if(pixelx >= upleftX + 11'd35 && pixelx <= upleftX + 11'd40 && pixely >= uptopY + 11'd140 && pixely <= upbottomY - 11'd30)begin
					red <= 3'b111;
					green <= 3'b0;
					blue <= 3'b11;
				end
			end
			
			if(p2health == 3'd2)begin
				if(pixelx >= upleftX + 11'd45 && pixelx <= upleftX + 11'd50 && pixely >= uptopY + 11'd140 && pixely <= upbottomY - 11'd30)begin
					red <= 3'b010;
				green <= 3'b100;
				blue <= 2'b10;
				end
			end
			
			if(ghostpicked == 3'b100)begin
				if(pixelx >= upleftX + 11'd55 && pixelx <= upleftX + 11'd60 && pixely >= uptopY + 11'd140 && pixely <= upbottomY - 11'd30)begin
					red <= 3'b100;
				green <= 3'b010;
				blue <= 2'b01;
				end
			end
			
		end
	
	
	//TEXT HP DISPLAY
	if(pixelx >= hpleftX && pixelx <= hprightX 
		&& pixely >= hptopY && pixely <= hpbottomY)begin
			
			if(pixelx >= hpleftX + 11'd10 && pixelx <= hprightX - 11'd60
				&& (pixely <= hptopY + 11'd40 || (pixely >= hpbottomY - 11'd150 && pixely <= hpbottomY - 11'd110)))begin
				red <= 3'b0;
				green <= 3'b0;
				blue <= 2'b0;
			end else if(pixelx >= hpleftX + 11'd30 && pixelx <= hpleftX + 11'd40)begin
				red <= 3'b0;
				green <= 3'b0;
				blue <= 2'b0;
			end else if(pixelx >= hpleftX + 11'd50 && (pixelx <= hprightX - 11'd10 || pixely >= hpbottomY - 11'd150)
				&& ((pixely >= hptopY + 11'd10 && pixely <= hptopY + 11'd40) || (pixely >= hpbottomY - 11'd150 && pixely <= hpbottomY - 11'd110)))begin
				red <= 3'b0;
				green <= 3'b0;
				blue <= 2'b0;
			end else if(pixely >= hpbottomY - 11'd110)begin
				red <= 3'b0;
				green <= 3'b0;
				blue <= 2'b0;
			end else begin
				red <= 3'b111;
				green <= 3'b111;
				blue <= 2'b11;
			end
			
			if(pixelx <= hpleftX + 11'd30 && pixely >= hptopY + 11'd100 && pixely <= hpbottomY - 11'd70)begin
				if(pixelx >= hpleftX + 11'd5 && pixelx <= hpleftX + 11'd25 && pixely <= hptopY + 11'd115)begin
					red <= 3'b111;
					green <= 3'b111;
					blue <= 2'b11;
				end else begin
					red <= 3'b0;
					green <= 3'b0;
					blue <= 2'b11;
				end
			end
			
			if(p1health == 2'd2)begin
				if(pixelx <= hprightX - 11'd10 && pixelx >= hprightX - 11'd40 && pixely >= hptopY + 11'd100 && pixely <= hpbottomY - 11'd70)begin
					if(pixelx >= hprightX - 11'd35 && pixelx <= hprightX - 11'd15 && pixely <= hptopY + 11'd115)begin
						red <= 3'b111;
						green <= 3'b111;
						blue <= 2'b11;
					end else begin
						red <= 3'b0;
						green <= 3'b0;
						blue <= 2'b11;
					end
				end
			end
			
			if(pixelx <= hpleftX + 11'd30 && pixely >= hptopY + 11'd140 && pixely <= hpbottomY - 11'd30)begin
				if(pixelx >= hpleftX + 11'd5 && pixelx <= hpleftX + 11'd25 && pixely <= hptopY + 11'd155)begin
					red <= 3'b111;
					green <= 3'b111;
					blue <= 2'b11;
				end else begin
					red <= 3'b111;
					green <= 3'b0;
					blue <= 2'b0;
				end
			end
			
			if(p2health == 2'd2)begin
				if(pixelx <= hprightX - 11'd10 && pixelx >= hprightX - 11'd40 && pixely >= hptopY + 11'd140 && pixely <= hpbottomY - 11'd30)begin
					if(pixelx >= hprightX - 11'd35 && pixelx <= hprightX - 11'd15 && pixely <= hptopY + 11'd155)begin
						red <= 3'b111;
						green <= 3'b111;
						blue <= 2'b11;
					end else begin
						red <= 3'b111;
						green <= 3'b0;
						blue <= 2'b00;
					end
				end
			end
			
	end
	
	//TIME TEXT
	seconds <= timer % 4'd10;
	tenSeconds <= timer / 4'd10;
	
	if(pixelx >= timeleftX && pixelx <= timerightX 
		&& pixely >= timetopY && pixely <= timebottomY)begin
		
		if((pixely >= timetopY + 11'd5 && (pixelx <= timeleftX + 11'd5 || (pixelx >= timeleftX + 11'd10 && pixelx <= timeleftX +11'd15)))
			||(pixelx >= timeleftX + 11'd15 && pixelx <= timeleftX + 11'd20))begin
			red <= 3'b0;
			green <= 3'b0;
			blue <= 2'b0;
		end else if((pixelx >= timeleftX + 11'd20 && pixelx <= timeleftX + 11'd25 && pixely >= timetopY + 11'd5 && pixely <= timetopY + 11'd10)
			|| (pixelx >= timeleftX + 11'd25 && pixelx <= timeleftX + 11'd30))begin
			red <= 3'b0;
			green <= 3'b0;
			blue <= 2'b0;
		end else if((pixelx >= timeleftX + 11'd35 && pixelx <= timeleftX + 11'd40 && pixely >= timetopY + 11'd5)
			|| (pixelx >= timeleftX + 11'd45 && pixelx <= timeleftX + 11'd50 && pixely >= timetopY + 11'd5))begin
			red <= 3'b0;
			green <= 3'b0;
			blue <= 2'b0;
		end else if(pixelx >= timeleftX + 11'd55 && pixelx <= timeleftX + 11'd60)begin 
			red <= 3'b0;
			green <= 3'b0;
			blue <= 2'b0;
		end else if((pixelx >= timeleftX + 11'd65 && pixelx <= timeleftX + 11'd75 && pixely >= timetopY + 11'd5 && pixely <= timetopY + 11'd10)
			|| (pixely >= timetopY + 11'd15 && pixely <= timetopY + 11'd25 && pixelx >= timeleftX + 11'd65))begin 
			red <= 3'b0;
			green <= 3'b0;
			blue <= 2'b0;
		end else begin
			red <= 3'b111;
			green <= 3'b111;
			blue <= 2'b11;
		end
	end
	
	if(pixelx >= timerleftX && pixelx <= timerrightX 
		&& pixely >= timertopY && pixely <= timerbottomY)begin
		if(tenSeconds == 4'd5)begin
			if((pixelx >= timeleftX + 11'd10 && pixelx <= timerleftX + 11'd35 && pixely <= timertopY + 11'd5)
				|| (pixelx >= timeleftX + 11'd10 && pixelx <= timerleftX + 11'd15 && pixely >= timertopY + 11'd5 && pixely <= timertopY + 11'd22)
				|| (pixelx >= timeleftX + 11'd30 && pixelx <= timerleftX + 11'd35 && pixely >= timertopY + 11'd17 && pixely <= timertopY + 11'd40)
				|| (pixelx >= timeleftX + 11'd10 && pixelx <= timerleftX + 11'd35 && pixely >= timertopY + 11'd17 && pixely <= timertopY + 11'd22)
				|| (pixelx >= timeleftX + 11'd10 && pixelx <= timerleftX + 11'd35 && pixely >= timertopY + 11'd35 && pixely <= timertopY + 11'd40))begin
				red <= 3'b111;
				green <= 3'b111;
				blue <= 2'b11;
			end
		end else if(tenSeconds == 4'd4)begin
			if((pixelx >= timeleftX + 11'd10 && pixelx <= timerleftX + 11'd15 && pixely >= timertopY && pixely <= timertopY + 11'd15)
				|| (pixelx >= timeleftX + 11'd30 && pixelx <= timerleftX + 11'd35 && pixely >= timertopY && pixely <= timertopY + 11'd15)
				|| (pixelx >= timeleftX + 11'd10 && pixelx <= timerleftX + 11'd35 && pixely >= timertopY + 11'd15 && pixely <= timertopY + 11'd20)
				|| (pixelx >= timeleftX + 11'd30 && pixelx <= timerleftX + 11'd35 && pixely >= timertopY + 11'd20 && pixely <= timertopY + 11'd40))begin
				red <= 3'b111;
				green <= 3'b111;
				blue <= 2'b11;
			end 
		end else if(tenSeconds == 4'd3)begin
			if((pixelx >= timeleftX + 11'd10 && pixelx <= timerleftX + 11'd35 && pixely <= timertopY + 11'd5)
				|| (pixelx >= timeleftX + 11'd30 && pixelx <= timerleftX + 11'd35 && pixely >= timertopY + 11'd5 && pixely <= timertopY + 11'd40)
				|| (pixelx >= timeleftX + 11'd10 && pixelx <= timerleftX + 11'd35 && pixely >= timertopY + 11'd17 && pixely <= timertopY + 11'd22)
				|| (pixelx >= timeleftX + 11'd10 && pixelx <= timerleftX + 11'd35 && pixely >= timertopY + 11'd35 && pixely <= timertopY + 11'd40))begin
				red <= 3'b111;
				green <= 3'b111;
				blue <= 2'b11;
			end
		end else if(tenSeconds == 4'd2)begin
			if((pixelx >= timeleftX + 11'd10 && pixelx <= timerleftX + 11'd35 && pixely <= timertopY + 11'd5)
				|| (pixelx >= timeleftX + 11'd10 && pixelx <= timerleftX + 11'd15 && pixely >= timertopY + 11'd22 && pixely <= timertopY + 11'd40)
				|| (pixelx >= timeleftX + 11'd30 && pixelx <= timerleftX + 11'd35 && pixely >= timertopY + 11'd5 && pixely <= timertopY + 11'd17)
				|| (pixelx >= timeleftX + 11'd10 && pixelx <= timerleftX + 11'd35 && pixely >= timertopY + 11'd17 && pixely <= timertopY + 11'd22)
				|| (pixelx >= timeleftX + 11'd10 && pixelx <= timerleftX + 11'd35 && pixely >= timertopY + 11'd35 && pixely <= timertopY + 11'd40))begin
				red <= 3'b111;
				green <= 3'b111;
				blue <= 2'b11;
			end
		end else if(tenSeconds == 4'd1)begin
			if(pixelx >= timeleftX + 11'd30 && pixelx <= timerleftX + 11'd35 && pixely >= timertopY && pixely <= timertopY + 11'd40)begin
				red <= 3'b111;
				green <= 3'b111;
				blue <= 2'b11;
			end
		end else if(tenSeconds == 4'd0)begin
			if((pixelx >= timeleftX + 11'd10 && pixelx <= timerleftX + 11'd35 && pixely <= timertopY + 11'd5)
				|| (pixelx >= timeleftX + 11'd10 && pixelx <= timerleftX + 11'd15 && pixely >= timertopY + 11'd5 && pixely <= timertopY + 11'd40)
				|| (pixelx >= timeleftX + 11'd30 && pixelx <= timerleftX + 11'd35 && pixely >= timertopY + 11'd5 && pixely <= timertopY + 11'd40)
				|| (pixelx >= timeleftX + 11'd10 && pixelx <= timerleftX + 11'd35 && pixely >= timertopY + 11'd35 && pixely <= timertopY + 11'd40))begin
				red <= 3'b111;
				green <= 3'b111;
				blue <= 2'b11;
			end
		end
		
		if(seconds == 4'd9)begin
			if((pixelx >= timeleftX + 11'd40 && pixelx <= timerleftX + 11'd65 && pixely <= timertopY + 11'd5)
				|| (pixelx >= timeleftX + 11'd40 && pixelx <= timerleftX + 11'd45 && pixely >= timertopY + 11'd5 && pixely <= timertopY + 11'd15)
				|| (pixelx >= timeleftX + 11'd60 && pixelx <= timerleftX + 11'd65 && pixely >= timertopY + 11'd5 && pixely <= timertopY + 11'd15)
				|| (pixelx >= timeleftX + 11'd40 && pixelx <= timerleftX + 11'd65 && pixely >= timertopY + 11'd15 && pixely <= timertopY + 11'd20)
				|| (pixelx >= timeleftX + 11'd60 && pixelx <= timerleftX + 11'd65 && pixely >= timertopY + 11'd20 && pixely <= timertopY + 11'd40))begin
				red <= 3'b111;
				green <= 3'b111;
				blue <= 2'b11;
			end 
		end else if(seconds == 4'd8)begin
			if((pixelx >= timeleftX + 11'd40 && pixelx <= timerleftX + 11'd65 && pixely <= timertopY + 11'd5)
				|| (pixelx >= timeleftX + 11'd40 && pixelx <= timerleftX + 11'd45 && pixely >= timertopY + 11'd5 && pixely <= timertopY + 11'd40)
				|| (pixelx >= timeleftX + 11'd60 && pixelx <= timerleftX + 11'd65 && pixely >= timertopY + 11'd5 && pixely <= timertopY + 11'd40)
				|| (pixelx >= timeleftX + 11'd40 && pixelx <= timerleftX + 11'd65 && pixely >= timertopY + 11'd17 && pixely <= timertopY + 11'd22)
				|| (pixelx >= timeleftX + 11'd40 && pixelx <= timerleftX + 11'd65 && pixely >= timertopY + 11'd35 && pixely <= timertopY + 11'd40))begin
				red <= 3'b111;
				green <= 3'b111;
				blue <= 2'b11;
			end
		end else if(seconds == 4'd7)begin
			if((pixelx >= timeleftX + 11'd40 && pixelx <= timerleftX + 11'd65 && pixely <= timertopY + 11'd5)
				||(pixelx >= timeleftX + 11'd60 && pixelx <= timerleftX + 11'd65 && pixely >= timertopY + 11'd5 && pixely <= timertopY + 11'd40))begin
				red <= 3'b111;
				green <= 3'b111;
				blue <= 2'b11;
			end
		end else if(seconds == 4'd6)begin
			if((pixelx >= timeleftX + 11'd40 && pixelx <= timerleftX + 11'd65 && pixely <= timertopY + 11'd5)
				|| (pixelx >= timeleftX + 11'd40 && pixelx <= timerleftX + 11'd45 && pixely >= timertopY + 11'd5 && pixely <= timertopY + 11'd40)
				|| (pixelx >= timeleftX + 11'd60 && pixelx <= timerleftX + 11'd65 && pixely >= timertopY + 11'd17 && pixely <= timertopY + 11'd40)
				|| (pixelx >= timeleftX + 11'd40 && pixelx <= timerleftX + 11'd65 && pixely >= timertopY + 11'd17 && pixely <= timertopY + 11'd22)
				|| (pixelx >= timeleftX + 11'd40 && pixelx <= timerleftX + 11'd65 && pixely >= timertopY + 11'd35 && pixely <= timertopY + 11'd40))begin
				red <= 3'b111;
				green <= 3'b111;
				blue <= 2'b11;
			end
		end else if(seconds == 4'd5)begin
			if((pixelx >= timeleftX + 11'd40 && pixelx <= timerleftX + 11'd65 && pixely <= timertopY + 11'd5)
				|| (pixelx >= timeleftX + 11'd40 && pixelx <= timerleftX + 11'd45 && pixely >= timertopY + 11'd5 && pixely <= timertopY + 11'd22)
				|| (pixelx >= timeleftX + 11'd60 && pixelx <= timerleftX + 11'd65 && pixely >= timertopY + 11'd17 && pixely <= timertopY + 11'd40)
				|| (pixelx >= timeleftX + 11'd40 && pixelx <= timerleftX + 11'd65 && pixely >= timertopY + 11'd17 && pixely <= timertopY + 11'd22)
				|| (pixelx >= timeleftX + 11'd40 && pixelx <= timerleftX + 11'd65 && pixely >= timertopY + 11'd35 && pixely <= timertopY + 11'd40))begin
				red <= 3'b111;
				green <= 3'b111;
				blue <= 2'b11;
			end
		end else if(seconds == 4'd4)begin
			if((pixelx >= timeleftX + 11'd40 && pixelx <= timerleftX + 11'd45 && pixely >= timertopY && pixely <= timertopY + 11'd15)
				|| (pixelx >= timeleftX + 11'd60 && pixelx <= timerleftX + 11'd65 && pixely >= timertopY && pixely <= timertopY + 11'd15)
				|| (pixelx >= timeleftX + 11'd40 && pixelx <= timerleftX + 11'd65 && pixely >= timertopY + 11'd15 && pixely <= timertopY + 11'd20)
				|| (pixelx >= timeleftX + 11'd60 && pixelx <= timerleftX + 11'd65 && pixely >= timertopY + 11'd20 && pixely <= timertopY + 11'd40))begin
				red <= 3'b111;
				green <= 3'b111;
				blue <= 2'b11;
			end 
		end else if(seconds == 4'd3)begin
			if((pixelx >= timeleftX + 11'd40 && pixelx <= timerleftX + 11'd65 && pixely <= timertopY + 11'd5)
				|| (pixelx >= timeleftX + 11'd60 && pixelx <= timerleftX + 11'd65 && pixely >= timertopY + 11'd5 && pixely <= timertopY + 11'd40)
				|| (pixelx >= timeleftX + 11'd40 && pixelx <= timerleftX + 11'd65 && pixely >= timertopY + 11'd17 && pixely <= timertopY + 11'd22)
				|| (pixelx >= timeleftX + 11'd40 && pixelx <= timerleftX + 11'd65 && pixely >= timertopY + 11'd35 && pixely <= timertopY + 11'd40))begin
				red <= 3'b111;
				green <= 3'b111;
				blue <= 2'b11;
			end
		end else if(seconds == 4'd2)begin
			if((pixelx >= timeleftX + 11'd40 && pixelx <= timerleftX + 11'd65 && pixely <= timertopY + 11'd5)
				|| (pixelx >= timeleftX + 11'd40 && pixelx <= timerleftX + 11'd45 && pixely >= timertopY + 11'd22 && pixely <= timertopY + 11'd40)
				|| (pixelx >= timeleftX + 11'd60 && pixelx <= timerleftX + 11'd65 && pixely >= timertopY + 11'd5 && pixely <= timertopY + 11'd17)
				|| (pixelx >= timeleftX + 11'd40 && pixelx <= timerleftX + 11'd65 && pixely >= timertopY + 11'd17 && pixely <= timertopY + 11'd22)
				|| (pixelx >= timeleftX + 11'd40 && pixelx <= timerleftX + 11'd65 && pixely >= timertopY + 11'd35 && pixely <= timertopY + 11'd40))begin
				red <= 3'b111;
				green <= 3'b111;
				blue <= 2'b11;
			end
		end else if(seconds == 4'd1)begin
			if(pixelx >= timeleftX + 11'd60 && pixelx <= timerleftX + 11'd65 && pixely >= timertopY && pixely <= timertopY + 11'd40)begin
				red <= 3'b111;
				green <= 3'b111;
				blue <= 2'b11;
			end
		end else if(seconds == 4'd0)begin
			if((pixelx >= timeleftX + 11'd40 && pixelx <= timerleftX + 11'd65 && pixely <= timertopY + 11'd5)
				|| (pixelx >= timeleftX + 11'd40 && pixelx <= timerleftX + 11'd45 && pixely >= timertopY + 11'd5 && pixely <= timertopY + 11'd40)
				|| (pixelx >= timeleftX + 11'd60 && pixelx <= timerleftX + 11'd65 && pixely >= timertopY + 11'd5 && pixely <= timertopY + 11'd40)
				|| (pixelx >= timeleftX + 11'd40 && pixelx <= timerleftX + 11'd65 && pixely >= timertopY + 11'd35 && pixely <= timertopY + 11'd40))begin
				red <= 3'b111;
				green <= 3'b111;
				blue <= 2'b11;
			end
		end
		
		
	end
	
end


endmodule
