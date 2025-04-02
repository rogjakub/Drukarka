`timescale 1 ns / 1 ps

module draw_mouse (
    input  logic clk,
    input  logic rst,
    vga_if.in vga_in,
    vga_if.out vga_out,
    input logic [11:0] xpos,
    input logic [11:0] ypos
);

import vga_pkg::*;

/**
 * Internal logic
 */
 logic [11:0] rgb_nxt;

always_ff @(posedge clk) begin
    vga_out.vcount <= vga_in.vcount;
    vga_out.vsync  <= vga_in.vsync;
    vga_out.vblnk  <= vga_in.vblnk;
    vga_out.hcount <= vga_in.hcount;
    vga_out.hsync  <= vga_in.hsync;
//    if((vga_in.hcount >= HOR_PANEL_START) && (vga_in.hcount <=HOR_PANEL_START + PANEL_WIDTH) && (vga_in.vcount >= VER_PANEL_START) && (vga_in.vcount <=VER_PANEL_START + PANEL_HEIGHT)) begin
//        vga_out.rgb <= rgb_nxt;
//    end else begin
//        vga_out.rgb <= vga_in.rgb;
//    end
end

MouseDisplay u_MouseDisplay(
    .pixel_clk(clk),
    .hcount(vga_in.hcount),
    .vcount(vga_in.vcount),
    .blank(vga_in.vblnk | vga_in.hblnk),
    .rgb_in(vga_in.rgb),
//    .rgb_out(rgb_nxt),
    .rgb_out(vga_out.rgb),
    .xpos,
    .ypos,
    .enable_mouse_display_out()
);

 endmodule