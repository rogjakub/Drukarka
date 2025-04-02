///**
// * San Jose State University
// * EE178 Lab #4
// * Author: prof. Eric Crabilla
// *
// * Modified by:
// * 2023  AGH University of Science and Technology
// * MTM UEC2
// * Piotr Kaczmarczyk
// *
// * Modified by:
// * 2024  AGH University of Science and Technology
// * MTM UEC2
// * Jan Str¹czek
// *
// * Modified by:
// * 2024  AGH University of Science and Technology
// * MTM UEC2
// * Jakub Róg
// *
// * Description:
// * The project top module.
// */

`timescale 1 ns / 1 ps

module top_vga (
    input  logic clk_40,
    input  logic rst,
    input  logic sw1,
    input  logic btnU,
    input  logic btnD,
    input  logic btnL,
    input  logic btnR,
    output logic vs,
    output logic hs,
    output logic [3:0] r,
    output logic [3:0] g,
    output logic [3:0] b
);


/**
 * Local variables and signals
 */

// VGA signals from timing
vga_if vga_tim();
vga_if vga_bg();
vga_if vga_char();
vga_if vga_panel();
vga_if vga_mouse();


//wire mouse_left;
wire pos_x;
wire pos_y;
wire x_blk;
wire y_blk;
wire left_blk;
wire x_out;
wire y_out;
wire left_out;

logic  [11:0] xpos_buf_in;
logic  [11:0] ypos_buf_in;
logic  [11:0] xpos_buf_out;
logic  [11:0] ypos_buf_out;


logic  [7:0] char_pixels;
logic  [7:0] char_xy;
logic  [10:0] char_addr;
logic  [6:0] char_code;
logic  [3:0] char_line;


/**
 * Signals assignments
 */

assign vs = vga_mouse.vsync;
assign hs = vga_mouse.hsync;
assign {r,g,b} = vga_mouse.rgb;
assign xpos = x_out;
assign ypos = y_out;
assign mouse_left = left_out;


/**
 * Submodules instances
 */

vga_timing u_vga_timing (
    .clk(clk_40),
    .rst,
    .vga_out(vga_tim)
);

draw_bg u_draw_bg (
    .clk(clk_40),
    .rst,
    .vga_in(vga_tim),
    .vga_out(vga_bg)
);

draw_rect_char u_draw_rect_char(
    .clk(clk_40),
    .rst,
    .vga_in(vga_bg),
    .vga_out(vga_char),
    .char_pixels(char_pixels),
    .char_xy(char_xy),
    .char_line(char_line)
);
always_comb begin
    char_addr = {char_code,char_line};
end
char_rom u_char_rom(
    .clk(clk_40),
    .char_xy(char_xy),
    .char_code(char_code)
);
font_rom u_font_rom(
    .clk(clk_40),
    .addr(char_addr),
    .char_line_pixels(char_pixels)
);

paint_panel u_paint_panel(
    .clk(clk_40),
    .rst,
    .vga_in(vga_char),
    .vga_out(vga_panel),
    .xpos(xpos_buf_out),
    .ypos(ypos_buf_out),
    .mouse_left(mouse_left)
);

    
always_ff @(posedge clk_40) begin
    xpos_buf_out <= xpos_buf_in;
    ypos_buf_out <= ypos_buf_in;
end

draw_mouse u_draw_mouse(
    .clk(clk_40),
    .rst,
    .vga_in(vga_panel),
    .vga_out(vga_mouse),
    .xpos(xpos_buf_out),
    .ypos(ypos_buf_out)
);

BtnCtl u_BtnCtl (
    .clk(clk_40),
    .rst,
    .sw1(sw1),
    .btnU(btnU),
    .btnD(btnD),
    .btnL(btnL),
    .btnR(btnR),
    .xpos(xpos_buf_in),
    .ypos(ypos_buf_in),
    .mouse_left(mouse_left)
);

endmodule
