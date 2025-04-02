/**
 * San Jose State University
 * EE178 Lab #4
 * Author: prof. Eric Crabilla
 *
 * Modified by:
 * 2023  AGH University of Science and Technology
 * MTM UEC2
 * Piotr Kaczmarczyk
 *
 * Modified by:
 * 2024 AGH University of Science and Technology
 * MTM UEC2
 * Jakub Róg
 *
 * Modified by:
 * 2024 AGH University of Science and Technology
 * MTM UEC2
 * Jan Str¹czek
 *
 * Description:
 * Top level synthesizable module including the project top and all the FPGA-referred modules.
 */

`timescale 1 ns / 1 ps

module top_vga_basys3 (
    input  wire clk,
    input  wire sw0,
    input  wire sw1,
    input  wire sw15,
    input  wire btnU,
    input  wire btnD,
    input  wire btnL,
    input  wire btnR,
    input  wire x_calib,
    input  wire y_calib,
    input  wire z_calib,
    input  wire calib,
    input  wire MTM,
    output wire Vsync,
    output wire Hsync,
    output wire [3:0] vgaRed,
    output wire [3:0] vgaGreen,
    output wire [3:0] vgaBlue,
    output wire JA1,
    output wire JB1,
    output wire JB2,
    output wire JB3,
    output wire JB4,
    output wire JB5,
    output wire JB6,
    output wire x_sup,
    output wire y_sup,
    output wire z_sup
);


/**
 * Local variables and signals
 */

wire clk_100;
wire clk_40;
wire locked;
wire pclk_mirror;


/**
 * Signals assignments
 */

assign JA1 = pclk_mirror;

ODDR pclk_oddr (
    .Q(pclk_mirror),
    .C(pclk),
    .CE(1'b1),
    .D1(1'b1),
    .D2(1'b0),
    .R(1'b0),
    .S(1'b0)
);


clk_wiz_0 u_clk_wiz_0 (
    .clk(clk),
    .locked(locked),
    .clk100MHz(clk_100),
    .clk40MHz(clk_40)
);


/**
 *  Project functional top module
 */

top_vga u_top_vga (
    .clk_40,
    .rst(sw15),
    .r(vgaRed),
    .g(vgaGreen),
    .b(vgaBlue),
    .hs(Hsync),
    .vs(Vsync),
    .sw1(sw1),
    .btnU(btnU),
    .btnD(btnD),
    .btnL(btnL),
    .btnR(btnR)
);

top_printer u_top_printer (
    .clk_40,
    .rst(sw15),
    .sw0(sw0),
    .sw1(sw1),
    .btnU(btnU),
    .btnD(btnD),
    .btnL(btnL),
    .btnR(btnR),
    .JB1(JB1),
    .JB2(JB2),
    .JB3(JB3),
    .JB4(JB4),
    .JB5(JB5),
    .JB6(JB6),
    .x_sup(x_sup),
    .y_sup(y_sup),
    .z_sup(z_sup),
    .x_calib(x_calib),
    .y_calib(y_calib),
    .z_calib(z_calib),
    .calib(calib),
    .MTM(MTM)
);

endmodule
