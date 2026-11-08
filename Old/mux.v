`timescale 1ns / 1ps

module mux #(parameter SIZE = 4) (
    input [2**SIZE - 1:0] i,
    input [SIZE - 1:0] s,
    output o
    );
    assign o = i[s];
endmodule
