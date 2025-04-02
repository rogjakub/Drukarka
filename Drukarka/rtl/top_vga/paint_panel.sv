/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Jakub Róg
 *
 * Description:
 * Display white panel with Paint functionalities.
 *
 */

`timescale 1ns / 1ps

module paint_panel(
    input logic clk,
    input logic rst,
    input logic [11:0] xpos,
    input logic [11:0] ypos,
    input logic mouse_left,
    vga_if.in vga_in,
    vga_if.out vga_out
);

import vga_pkg::*;
 
logic [11:0] rgb_nxt;
logic pos_mem[PANEL_WIDTH-1:0][PANEL_HEIGHT-1:0];
logic [11:0] xpos_black;
logic [11:0] ypos_black;


always_ff @(posedge clk) begin
    if (rst) begin
        vga_out.vcount <= '0;
        vga_out.vsync  <= '0;
        vga_out.vblnk  <= '0;
        vga_out.hcount <= '0;
        vga_out.hsync  <= '0;
        vga_out.hblnk  <= '0;
        vga_out.rgb    <= '0;
      
        
        for( int i = 0 ; i < PANEL_WIDTH ; i++) begin
            for ( int j = 0 ; j < PANEL_HEIGHT ; j++) begin
                pos_mem[i][j] <= 1'b0;
            end
        end
    end else begin
        vga_out.vcount <= vga_in.vcount;
        vga_out.vsync  <= vga_in.vsync;
        vga_out.vblnk  <= vga_in.vblnk;
        vga_out.hcount <= vga_in.hcount;
        vga_out.hsync  <= vga_in.hsync;
        vga_out.hblnk  <= vga_in.hblnk;
        vga_out.rgb    <= rgb_nxt;
      
        
        if((xpos >= HOR_PANEL_START) && (xpos <=HOR_PANEL_START + PANEL_WIDTH) && (ypos >= VER_PANEL_START) && (ypos <=VER_PANEL_START + PANEL_HEIGHT) && mouse_left) begin
              pos_mem[xpos - HOR_PANEL_START][ypos - VER_PANEL_START] <= 1'b1;
        end 
    end
end


always_comb begin
    if((vga_in.hcount >= HOR_PANEL_START) && (vga_in.hcount <=HOR_PANEL_START + PANEL_WIDTH) && (vga_in.vcount >= VER_PANEL_START) && (vga_in.vcount <=VER_PANEL_START + PANEL_HEIGHT)) begin  
         if (pos_mem[vga_in.hcount - HOR_PANEL_START][vga_in.vcount - VER_PANEL_START]) begin
            rgb_nxt = 12'h0_0_0;  // Czarny piksel, jeœli jest zaznaczenie
            
        end else begin
            rgb_nxt = 12'hf_f_f;  // Bia³y piksel, jeœli nie ma zaznaczenia
        end
       
    end else begin
        rgb_nxt = vga_in.rgb;
    end
end

endmodule
