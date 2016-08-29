module HighwayLights(Car,Reset,Clk,HG,HY,HR,FG,FY,FR);
	input Car,Reset,Clk;
	output HG,HY,HR,FG,FY,FR;
	reg [1:0] state;
	reg HG=1,HY=0,HR=0,FG=0,FY=0,FR=1;
	reg [3:0] counter;
	parameter S0=2'b00, S1=2'b01, S2=2'b10, S3=2'b11;
	always @(posedge Clk)
	begin
		if(Reset)//Reset check
		begin
			HG=1;HY=0;HR=0;FG=0;FY=0;FR=1;
			state<=S0;
			counter=0;
		end
		else
		begin
		counter = counter+1'b1;
			case (state)			
				S0: begin
						HG=1;HY=0;HR=0;FG=0;FY=0;FR=1;     ////Highway=GREEN, Farm=RED
						if (Car && counter>4'b0100)        //Car=1 and 4 cycles
						begin 	
							state <= S1;
							HG=0;HY=1;HR=0;FG=0;FY=0;FR=1;
							counter=1;
						end
						else	state <= state;
					end
					
				S1: begin
					    HG=0;HY=1;HR=0;FG=0;FY=0;FR=1;      //Highway=YELLOW, Farm=RED	
						if (counter==4'b0010)               //1 cycle
						begin
							state <= S2;
							HG=0;HY=0;HR=1;FG=1;FY=0;FR=0;
							counter=1;
						end
						else	state <= state;
					end
					
				S2: begin
					    HG=0;HY=0;HR=1;FG=1;FY=0;FR=0;		//Highway=RED, Farm=GREEN					
						if (counter>=4'b0100||!Car)         //Car=0 or 3 cycles
						begin
							state <= S3;
							HG=0;HY=0;HR=1;FG=0;FY=1;FR=0;
							counter=1;
						end
						else	state <= state;	
					end
							
				S3: begin
					    HG=0;HY=0;HR=1;FG=0;FY=1;FR=0;		  //Highway=RED, Farm=YELLOW			
						if (counter==4'b0010)       	      //1 cycle
						begin
							state <= S0;
							HG=1;HY=0;HR=0;FG=0;FY=0;FR=1;
							counter=1;
						end
						else	state <= state;
					end					
			endcase
		end
	end
endmodule



