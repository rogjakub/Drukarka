/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Jakub Róg
 *
 * Description:
 * Change position on x and y axies controled by buttons.
 *
 */

`timescale 1ns / 1ps

module BtnCtl(
    input logic clk,
    input logic rst,
    input logic sw1,
    input logic btnU,
    input logic btnD,
    input logic btnL,
    input logic btnR,
    output logic [11:0] xpos,
    output logic [11:0] ypos,
    output logic mouse_left
);

import vga_pkg::*;

logic [11:0] xpos_nxt = HOR_PANEL_START;
logic [11:0] ypos_nxt = VER_PANEL_START;
logic left_nxt = 0; 
logic [19:0] Full_Count = 80000;
logic [19:0] counter = 0;


always_ff @(posedge clk) begin
    if(rst) begin
        xpos <= 0;
        ypos <= 0;
        mouse_left <= 0;
    end else begin
        if(btnR) begin
            if(counter == Full_Count) begin
                xpos_nxt <= xpos_nxt + 1;
                counter <= 0;
            end
            counter <= counter + 1;
        end
        if(btnL) begin
            if(counter == Full_Count) begin
                xpos_nxt <= xpos_nxt - 1;
                counter <= 0;
            end
            counter <= counter + 1;
        end
        
        
        
        if(btnD) begin
            if(counter == Full_Count) begin
                ypos_nxt <= ypos_nxt + 1;
                counter <= 0;
            end
            counter <= counter + 1;
        end
        if(btnU) begin
            if(counter == Full_Count) begin
                ypos_nxt <= ypos_nxt - 1;
                counter <= 0;
            end
            counter <= counter + 1;
        end
        
        if(sw1) begin
            if(counter == Full_Count) begin
                left_nxt <= 1;
                counter <= 0;
            end
            counter <= counter + 1;
        end else begin
            left_nxt <= 0;
        end
        
        
        xpos <= xpos_nxt;
        ypos <= ypos_nxt;
        mouse_left <= left_nxt;
    end
    
end


endmodule
