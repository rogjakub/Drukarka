/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Jakub Róg
 *
 * Modified by:
 * 2024 AGH University of Science and Technology
 * MTM UEC2
 * Jan Str�czek
 *
 * Description:
 * Generating pulses to control printer.
 *
 */

`timescale 1ns / 1ps


module printer_movement #(
parameter pWIDTH = 20)(
    input logic clk,
    input logic rst,
    input logic x_dir,
    input logic x_step,
    input logic y_dir,
    input logic y_step,
    input logic z_dir,
    input logic z_step,
    input logic MTM,
    output logic x_direction,
    output logic x_pulse,
    output logic y_direction,
    output logic y_pulse,
    output logic z_direction,
    output logic z_pulse
);

logic [pWIDTH-1:0] High_Count_Signal = 40000;
logic [pWIDTH-1:0] Full_Count_Signal = 80000;
logic [pWIDTH-1:0] x_counter = 0;
logic [pWIDTH-1:0] y_counter = 0;
logic [pWIDTH-1:0] z_counter = 0;

logic [pWIDTH-1:0] MTM_x_axis [20:0] = '{150,1000, 400, 400, 800,     150,800,400, 150,         800,150, 400, 150,  800, 150,        800, 150,         800, 400, 400, 800};
logic MTM_x_dir [20:0] = '{0,0, 1, 1, 0,      0, 0, 1, 0,      1, 0, 0, 0,      0, 0,      1, 0,    0, 1, 1, 0};
logic MTM_x_step [20:0] = '{0,0, 1, 1, 0,     0, 0, 1, 0,      1, 0, 1, 0,      0, 0,      1, 0,    0, 1, 1, 0};
logic [pWIDTH-1:0] x_pulse_counter = 0;
logic [18:0] x_i = 0;

logic [pWIDTH-1:0] MTM_y_axis [20:0] = '{150,1000, 400, 400, 800,     150,800,400, 150,         800,150, 400, 150,  800, 150,        800, 150,         800, 400, 400, 800};
logic MTM_y_dir [20:0] = '{0,1, 0, 1, 0,      0, 1, 0, 0,      0, 0, 0, 0,      0, 0,      0, 0,    1, 0, 1, 0};
logic MTM_y_step [20:0] = '{0,1, 1, 1, 1,     0, 1, 0, 0,      0, 0, 0, 0,      1, 0,      0, 0,    1, 1, 1, 1};
logic [pWIDTH-1:0] y_pulse_counter = 0;
logic [18:0] y_i = 0;

logic [pWIDTH-1:0] MTM_z_axis [20:0] = '{150,1000, 400, 400, 800,     150,800,400, 150,         800,150, 400, 150,  800, 150,        800, 150,         800, 400, 400, 800};
logic MTM_z_dir [20:0] = '{1,0, 0, 0, 0,      0, 0, 0, 1,      0, 0, 0, 1,      0, 0,      0, 1,    0, 0, 0, 0};
logic MTM_z_step [20:0] = '{1,0, 0, 0, 0,     1, 0, 0, 1,      0, 1, 0, 1,      0, 1,      0, 1,    0, 0, 0, 0};
logic [pWIDTH-1:0] z_pulse_counter = 0;
logic [18:0] z_i = 0;

always_ff @(posedge clk) begin
    if(rst) begin
        x_counter <= 0;
        y_counter <= 0;
        z_counter <= 0;
        x_direction <= 0;
        x_pulse <= 0;
        y_direction <= 0;
        y_pulse <= 0;
        z_direction <= 0;
        z_pulse <= 0;
    end else begin
        if(MTM) begin
            if(x_pulse_counter < MTM_x_axis[x_i] && x_i < 21) begin
                x_direction <= MTM_x_dir[x_i];
                
                x_counter <= x_counter + 1;
                 if(x_counter < High_Count_Signal) begin
                    x_pulse <= MTM_x_step[x_i];
                end else if(x_counter >= High_Count_Signal && x_counter < Full_Count_Signal) begin
                    x_pulse <= 0;
                end else begin
                    x_pulse <= MTM_x_step[x_i];
                    x_counter <= 0;
                    x_pulse_counter <= x_pulse_counter + 1;
                end
            end else begin
                x_pulse_counter <= 0;
                if(x_i < 21) begin
                    x_i <= x_i + 1;
                end else begin
                    x_direction <= 0;
                    x_pulse <= 1;
                end
            end
            
            if(y_pulse_counter < MTM_y_axis[y_i] && y_i < 21) begin
                y_direction <= MTM_y_dir[y_i];
                
                y_counter <= y_counter + 1;
                 if(y_counter < High_Count_Signal) begin
                    y_pulse <= MTM_y_step[y_i];
                end else if(y_counter >= High_Count_Signal && y_counter < Full_Count_Signal) begin
                    y_pulse <= 0;
                end else begin
                    y_pulse <= MTM_y_step[y_i];
                    y_counter <= 0;
                    y_pulse_counter <= y_pulse_counter + 1;
                end
            end else begin
                y_pulse_counter <= 0;
                if(y_i < 21) begin
                    y_i <= y_i + 1;
                end else begin
                    y_direction <= 0;
                    y_pulse <= 1;
                end
            end
            
            
            
            if(z_pulse_counter < MTM_z_axis[y_i] && z_i < 21) begin
                z_direction <= MTM_z_dir[z_i];
                
                z_counter <= z_counter + 1;
                 if(z_counter < High_Count_Signal) begin
                    z_pulse <= MTM_z_step[z_i];
                end else if(z_counter >= High_Count_Signal && z_counter < Full_Count_Signal) begin
                    z_pulse <= 0;
                end else begin
                    z_pulse <= MTM_z_step[z_i];
                    z_counter <= 0;
                    z_pulse_counter <= z_pulse_counter + 1;
                end
            end else begin
                z_pulse_counter <= 0;
                if(z_i < 21) begin
                    z_i <= z_i + 1;
                end else begin
                    z_direction <= 0;
                    z_pulse <= 1;
                end
            end
            
            
            
            
            
            
        end else begin
            if(x_step) begin
                x_direction <= x_dir;
                x_counter <= x_counter + 1;
                
                if(x_counter < High_Count_Signal) begin
                    x_pulse <= 1;
                end else if(x_counter >= High_Count_Signal && x_counter < Full_Count_Signal) begin
                    x_pulse <= 0;
                end else begin
                    x_pulse <= 1;
                    x_counter <= 0;
                end
            end 
            if(y_step) begin
                y_direction <= y_dir;
                y_counter <= y_counter + 1;

                
                if(y_counter < High_Count_Signal) begin
                    y_pulse <= 1;
                end else if(y_counter >= High_Count_Signal && y_counter < Full_Count_Signal) begin
                    y_pulse <= 0;
                end else begin
                    y_pulse <= 1;
                    y_counter <= 0;
                end
            end
            if(z_step) begin
                z_direction <= z_dir;
                z_counter <= z_counter + 1;

                
                if(z_counter < High_Count_Signal) begin
                    z_pulse <= 1;
                end else if(z_counter >= High_Count_Signal && z_counter < Full_Count_Signal) begin
                    z_pulse <= 0;
                end else begin
                    z_pulse <= 1;
                    z_counter <= 0;
                end
            end 
            if(x_step == 0 && y_step == 0 && z_step == 0) begin
                x_counter <= 0;
                y_counter <= 0;
                z_counter <= 0;
                x_direction <= 0;
                x_pulse <= 0;
                y_direction <= 0;
                y_pulse <= 0;
                z_direction <= 0;
                z_pulse <= 0;
            end
        end
    end
    
end


endmodule
