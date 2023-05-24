module lab8(
             CLOCK_50
             SW,
             KEY,
             VGA_CLK,
             VGA_HS,
H_SYNC
             VGA_VS,
             VGA_BLANK_N,
             VGA_SYNC_N,
             VGA_R,
             VGA_G,
Green[9:0]
             VGA_B
      );
      input            CLOCK_50; 
      input [3:0] KEY;
      input [9:0] SW;
      output         VGA_CLK;
      output         VGA_HS;
      output         VGA_VS;
      output         VGA_BLANK_N; 
      output         VGA_SYNC_N;
      output [7:0] VGA_R;
8-bit-DAC
      output [7:0] VGA_G;
      output [7:0] VGA_B;

     wire resetn;
     assign resetn=KEY[0];
 
     
     //create the colour, x, y and writeEn wires that are inputs to the controller. 
     wire [2:0] colour; 
     wire [7:0] x; 
     wire [6:0] y; 


     wire go, erase, plotEn, update, reset; 
     assign resetn= KEY[0]; 


     wire [5:0] plotCounter; 
     wire [7:0] xCounter; 
     wire [6:0] yCounter; 
     wire [25:0] freq;

 
    vga_adapter VGA(
                   .reset.(resetn),
                   .clock(CLOCK_50),
                   .colour(colour),
                   .x(x),
                   .y(y),
                   .plot(go),
                   .VGA_R(VGA_R),
                   .VGA_G(VGA_G),
                   .VGA_B(VGA_B),
                   .VGA_HS(VGA_HS),
                   .VGA_BLANK(VGA_BLANK_N), 
                   .VGA_SYNC(VGA_SYNC_N);
                   .VGA_CLK(VGA_CLK));
           defparam VGA.RESOLUTION = "160x120";
           defparam VGA.MONOCHROME ="FALSE";
           defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
           defparam VGA.BACKGROUND_IMAGE= "black.mif";
   
    controlPath c(CLOCK_50,resetn,plotCounter,
                              xCoutner,yCoutner,freq,
                              go,erase,update,plotEn,reset);

    dataPath d(CLOCL_50,resetn,plotEn,go,erase,update,reset,SW[9:7]
                       x,y,colour,plotCounter,xCounter,yCoutner,freq);

endmodule

module controlPath(input clk,resetn,
                                        input[5:0] plotCounter, 
                                        input[7:0] xCounter, 
                                        input[6:0] yCounter, 
                                        input[25:0] freq, 
                                        output reg go,erase,update, plotEn, reset );
 
        reg[2:0] currentSt, nextSt; 


        localparam RESET =3'b0, 
                            DRAW=3'b001, 
                            WAIT =3'b010, 
                            ERASE = 3'b011,
                            UPDATE =3'b100;
                            CLEAR = 3'b101;


        always@(*)
        begin
              
              case(currentSt)
                    RESET:nextSt=DRAW;
                    DRAW: begin
                          if (plotCoutner <=6'd15) nextSt= Draw;  
                          else nextSt=WAIT;
                    end 
                    WAIT:begin
                         if (freq<26'd12499999)nextSt=WAIT; 
                         else nextSt =ERASE;
                    end
                    ERASE:begin
                         if (plotCounter<=6'd15)nextSt=ERASE;
                         else  nextSt=UPDATE; 
                    end

                    UPDATE: nextSt=DRAW; 
                    CLEAR: nextSt=(xCounter==8'd160 & yCounter==7'd120) ? RESET


: CLEAR;
                    default: nextSt=RESET;

   
             endcase 
    end  


    always@(*)
    begin
 
        //RESET all enable signals 
        go=1'b0; 
        update =1'b0; 
        reset= 1'b0; 
        erase= 1'b0; 
        plotEn= 1'b0; 


        case(currentSt)
               RESET:reset=1'b1;
               DRAW:begin
                   go= 1'b1; 
                   erase= 1'b0;
                   plotEn=1'b1;
               end


               ERASE:begin
                    go=1'b1;
                    erase=1'b1; 
                    plotEn=1'b1;
                    end
               UPDATE:update=1'b1;
               CLEAR:begin
                    erase =1'b1;
                    go =1'b1; 
               end
        endcase

   end

 always @(posedge clk)
 begin 

          if (resetn) surrentST <=CLEAR;

  else currentSt<=nextSt;
 end
endmodule

module dataPath(input clk, resetn,plotEn,go,erase,update,reset,
                                   input [2:0] clr, 
                                   output reg[7:0] X, 
                                   output reg[6:0] Y, 
                                   output reg[2:0] CLR,
                                   output reg[5:0] plotCounter, 
                                   output reg[7:0] xCounter, 
                                   output reg[6:0] yCounter, 
                                   output reg[25:0] freq);


     reg [7:0] xTemp; 
     reg [6:0] yTemp; 
     reg opX,opY; 
     always @(posedge clk)
     begin
          if (reset || resetn) begin
                   X<=8'd156;
                   Y<=7'b0; 
                   xTemp<=8'd156;
                   yTemp<=7'b0; 
                   plotCounter<= 6'b0;
                   xCounter<=8'b0;
                   yCounter<=3'b0;
                   CLR <=3'b0;
                   freq<=25'd0;
                   opX<1'b0;
                   opY<=1'b1;
          end
          else begin
                if (erase & !plotEn) begin
                       if (xConter == 8'd160 && yCounter != 7'd120) begin 
                             xCoutner<=8'b0;
                             yCounter<=yCounter +1;
                       end
                       else begin 
                             XCounter <=xCoutner +1;
                             X<=xCoutner; 
                             Y<=yCounter;
                             CLR<=3'b0;
                       end
                end 

                if (!erase) CLR <= clr; 

                if (freq == 25'd12499999) freq <=26'd0; 
                else freq <= freq +1;
      
                if (plotEn) begin
                        if (erase) CLR <= 0;
                        else CLR <= dlr; 
                        if (plotCounter == 6'b10000) plotCounter<=6'b0;
                        else plotCounter <=plotCounter +1; 
                        X<=xtemp +plotCounter [1:0];
                        Y<= yTemp+ plotCounter [3:2]
               end
               if (update) begin 
                       if (X==8'b0)opX=1; 
                       if (X==8'd156)opX=0;
                       if (Y==7'b0) opY=1; 
                       if (Y==7'd116)opY=0'


                       if (opX==1'b1)begin
                              X<=Z+1; 
                              xTemp<=xTemp+1;
                       end
                       if (opX==1'b0) begin 
                                X<=X-1; 
                                xTemp<=xTemp-1; 
                       end

                       if (opY==1'b1) begin
                             Y<=Y+1; 
                             yTemp<=yTemp+1;
                       end
                       if (opY==1'b0)begin 
                              Y<=Y-1; 
                              yTemp<=yTemp-1; 
                       end 
                end 
        end 
   end 

endmodule 
                                   











     

    