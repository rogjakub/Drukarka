/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Jakub Róg
 *
 * Modified by:
 * 2024 AGH University of Science and Technology
 * MTM UEC2
 * Jan Str¹czek
 *
 * Description:
 * Top moudle used to generate and control printer.
 *
 */

`timescale 1ns / 1ps


module top_printer(
    input logic clk_40,
    input logic rst,
    input logic sw0,
    input logic sw1,
    input logic btnU,
    input logic btnD,
    input logic btnL,
    input logic btnR,
    input logic x_calib,
    input logic y_calib,
    input logic z_calib,
    input logic calib,
    input logic MTM,
    output logic JB1,
    output logic JB2,
    output logic JB3,
    output logic JB4,
    output logic JB5,
    output logic JB6,
    output logic x_sup,
    output logic y_sup,
    output logic z_sup
);

wire x_dir;
wire x_step;
wire y_dir;
wire y_step;
wire z_dir;
wire z_step;


always_ff @(posedge clk_40) begin
    if(rst) begin
        x_sup <= 0;
        y_sup <= 0;
        z_sup <= 0;
    end else begin
        x_sup <= 1;
        y_sup <= 1;
        z_sup <= 1;    
    end
end


printer_controller u_printer_controller (
    .clk(clk_40),
    .rst,
    .sw_up(sw1),
    .btn_up(btnU),
    .btn_down(btnD),
    .btn_left(btnL),
    .btn_right(btnR),
    .btn_center(sw0),
    .x_direction(x_dir),
    .x_stepper(x_step),
    .y_direction(y_dir),
    .y_stepper(y_step),
    .z_direction(z_dir),
    .z_stepper(z_step),
    .x_calib(x_calib),
    .y_calib(y_calib),
    .z_calib(z_calib),
    .calib(calib)
);

printer_movement u_printer_movement (
    .clk(clk_40),
    .rst,
    .x_dir(x_dir),
    .x_step(x_step),
    .y_dir(y_dir),
    .y_step(y_step),
    .z_dir(z_dir),
    .z_step(z_step),
    .x_direction(JB1),
    .x_pulse(JB2),
    .y_direction(JB3),
    .y_pulse(JB4),
    .z_direction(JB5),
    .z_pulse(JB6),
    .MTM(MTM)
);
endmodule
