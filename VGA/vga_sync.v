`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Catlin Ashenfelter
// 
// Create Date: 12/03/2022 06:16:09 AM
// Design Name: 
// Module Name: vga_sync
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: VGA driver, 640x480 60Hz
// 
// Dependencies: 
// 
// Revision:
// Revision 0.03 - File remade from scratch
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module vga_sync(
    input clk, // 100 MHz
    input reset,
    output hsync,
    output vsync,
    output display_on,
    output p_tick,
    output [9:0] x,
    output [9:0] y
    );
    
    localparam VISWIDTH = 639; // 0 to 639
    localparam HS_ON = 656; // first xpos of hsync
    localparam HS_OFF = 751; // 16 FP, 96 pulse width, 48 BP
    localparam WIDTH = 799;
    
    localparam VISHEIGHT = 479;
    localparam VS_ON = 490; // first ypos of vsync
    localparam VS_OFF = 491; // 10 FP, 2 pulse width, 33 BP
    localparam HEIGHT = 524;
    
    
    reg [1:0] clkdiv;
    reg [9:0] xpos, ypos;
    
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            clkdiv <= 0;
            xpos <= 0;
            ypos <= 0;
        end
        else begin
            clkdiv <= clkdiv + 1;
            if (clkdiv == 0) begin
                if (xpos == WIDTH) begin
                    if (ypos == HEIGHT) begin
                        ypos <= 0;
                    end
                    else begin
                        ypos <= ypos + 1;
                    end
                    xpos <= 0;
                end
                else begin
                    xpos <= xpos + 1;
                end
            end
        end
    end
    
    assign hsync = ((xpos >= HS_ON) && (xpos <= HS_OFF)) ? 0 : 1 ; // active low
    assign vsync = ((ypos >= VS_ON) && (ypos <= VS_OFF)) ? 0 : 1 ; // active low
    assign display_on = ((xpos > VISWIDTH) || (ypos > VISHEIGHT)) ? 0 : 1;
    assign p_tick = (clkdiv == 0) ? 1 : 0;
    assign x = xpos;
    assign y = ypos;
    
endmodule
