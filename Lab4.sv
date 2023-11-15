module d_ff (
  input  wire clk, rst,
  input  wire d,
  output wire q
);

	always@(posedge clk) begin
		q = rst ? 1'b0 : d;
	end
endmodule

/*SWORD LOGIC*/

typedef enum {

	noSword,
	hasSword
	
} state_sw;

module sword (

  input  wire clk, rst,
  input  wire sw,
  output wire v
  
);

wire t_v;
state_sw curr, next;

d_ff dff_vorpal_sword (clk, rst, t_v , v); 

initial begin

	curr <= noSword;
	next <= noSword;
	t_v  <= 1'b0;
	
end

always@(posedge clk) begin

	if (rst) begin
	
		next <= noSword;
		curr <= noSword;
		t_v  <= 1'b0;
		
	end else begin
	
		curr <= next;
		
		case (curr)
			noSword: begin
			
				t_v <= 1'b0;
				
				if (sw) begin
				
					next <= hasSword;
					
				end else begin
				
					next <= curr;
					
				end
				
			end	hasSword: begin
			
				t_v  <= 1'b1;
				next <= curr;
				
			end	default: begin
			
				next <= noSword;
				
			end
			
		endcase
		
	end
	
end

endmodule

/*GAME LOGIC*/

typedef enum {

	cave_of_cacophony,
	twisty_tunnel,
	rapid_river,
	secret_sword_stash,
	dragons_den,
	victory_vault,
	grievous_graveyard
	
} state_rm;

module room (

  input  wire clk, rst,
  input  wire n, s, e, w,
  input  wire v,
  output wire sw,
  output reg  s0, s1, s2, s3, s4, s5, s6,
  output reg  win, d,
  output reg [0:6] seven_seg 
  
);

state_rm curr, next;
wire t_s0, t_s1, t_s2, t_s3, t_s4, t_s5, t_s6;

d_ff dff_cave_of_cacophony (clk, rst, t_s0 , s0); 
d_ff dff_twisty_tunnel (clk, rst, t_s1, s1); 
d_ff dff_rapid_river (clk, rst, t_s2, s2);
d_ff dff_secret_sword_stash (clk, rst, t_s3, s3);
d_ff dff_dragons_den (clk, rst, t_s4, s4);
d_ff dff_victory_vault (clk, rst, t_s5, s5);
d_ff dff_grievous_graveyard (clk, rst, t_s6, s6);
assign win = t_s5;
assign sw  = t_s3; 
assign d   = t_s6;

initial begin

		curr <= cave_of_cacophony;
		next <= cave_of_cacophony;
		t_s0 <= 1'b0; 
		t_s1 <= 1'b0; 
		t_s2 <= 1'b0; 
		t_s3 <= 1'b0; 
		t_s4 <= 1'b0; 
		t_s5 <= 1'b0; 
		t_s6 <= 1'b0; 
		
end

always@(posedge clk) begin

	if (rst) begin
	
		curr <= cave_of_cacophony;
		next <= cave_of_cacophony;
		t_s0 <= 1'b0; 
		t_s1 <= 1'b0; 
		t_s2 <= 1'b0; 
		t_s3 <= 1'b0; 
		t_s4 <= 1'b0; 
		t_s5 <= 1'b0; 
		t_s6 <= 1'b0; 
		
	end else begin
	
		curr = next;
		
		case (curr)
			cave_of_cacophony: begin 
			
				t_s0 = 1'b1;
				
				if (e && !(n || s || w)) begin
				
					next = twisty_tunnel;
					t_s0 = 1'b0;
					
				end else begin
				
					next = cave_of_cacophony;
					
				end
				
			end	twisty_tunnel: begin 
			
				t_s1 = 1'b1;
				
				if (s && !(n || e || w)) begin
				
					next = rapid_river;
					t_s1 = 1'b0;
					
				end else if (w && !(n || s || e)) begin 
				
					next = cave_of_cacophony;
					t_s1 = 1'b0;
					
				end else begin
				
					next = twisty_tunnel;
					
				end
			end	rapid_river: begin
			
				t_s2 = 1'b1;
				
				if (w && !(n || s || e)) begin
				
					next = secret_sword_stash;
					t_s2 = 1'b0;
					
				end else if ((s && e) && !(n || w)) begin
				
					next = dragons_den;
					t_s2 = 1'b0;
					
				end else if (n && !(s || e || w)) begin	
				
					next = twisty_tunnel;
					t_s2 = 1'b0;
					
				end else begin
				
					next = rapid_river;
					
				end
			end	secret_sword_stash: begin 
			
				t_s3 = 1'b1;
				
				if (e && !(n || s || w)) begin
				
					next = rapid_river;
					t_s3 = 1'b0;
					
				end else begin
				
					next = secret_sword_stash;
					
				end
				
			end dragons_den: begin 
			
				t_s4 = 1'b1;
				if (v) begin
					next = victory_vault;
				end else begin
					next = grievous_graveyard;
				end
				
			end	victory_vault: begin 
			
				t_s4 = 1'b0;
				t_s5 = 1'b1;
				
			end	grievous_graveyard: begin 
			
				t_s4 = 1'b0;
				t_s6 = 1'b1;
				
			end	default: begin
			
				next <= cave_of_cacophony;
				
			end
		endcase
		case ({t_s0,t_s1,t_s2,t_s3,t_s4,t_s5,t_s6})
			7'b1000000: seven_seg = 7'b0000001; // s0
			7'b0100000: seven_seg = 7'b1001111; // s1
			7'b0010000: seven_seg = 7'b0010010; // s2
			7'b0001000: seven_seg = 7'b0000110; // s3
			7'b0000100: seven_seg = 7'b1001100; // s4
			7'b0000010: seven_seg = 7'b0100100; // s5
			7'b0000001: seven_seg = 7'b0100000; // s6
		endcase

		
	end
	
end
endmodule

module Lab4 (
  input  wire clk, rst,
  input  wire n, s, e, w,
  output reg s0, s1, s2, s3, s4, s5, s6,
  output sw, v,
  output reg  win, d,
  output wire [0:6] seven_seg
);  

wire t_sw, t_v;

assign sw = t_sw;
assign v  = t_v;

room room_t(clk, rst, n, s, e, w, t_v, t_sw, s0, s1, s2, s3, s4, s5, s6, win, d, seven_seg);
sword sword_t(clk, rst, t_sw, t_v);

endmodule
