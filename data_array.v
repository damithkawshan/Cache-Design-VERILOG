`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Damith Kawshan
// 
// Create Date:    21:45:03 04/30/2019 
// Design Name: 	
// Module Name:    data array
// Project Name:   Cache Memory Design
// Target Devices: 
// Tool versions:  
// Description: stores data blocks (cache memory)
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module data_array(
    input [63:0] data_block, //data block from memory (contains 8 words)
	 input [7:0] wdata, //data from processor
    output [7:0] rdata,//data to processor
	 input wr_en,//read/write signal
    input update,//update cache with data block
    input [5:0] index,//cache line
    input [2:0] offset,//location of the word
    input clk //clock
    );
	 
reg [63:0] cache [63:0]; //initialize_data_memory

function [7:0] read_mux(input [2:0] word_no,input [63:0] cache_line); //get the correct word from cache line
    case(word_no)
        1:read_mux=cache_line[15:8];
        2:read_mux=cache_line[23:16];
        3:read_mux=cache_line[31:24];
        4:read_mux=cache_line[39:32];
        5:read_mux=cache_line[47:40];
        6:read_mux=cache_line[55:48];
        7:read_mux=cache_line[63:56];
        default:read_mux=cache_line[7:0];
    endcase
endfunction

function [63:0] write_mux(input [2:0] word_no,input [63:0] cache_line,input [7:0] data_in);//write data_word to correct position at cache line
    case(word_no)
        1:write_mux={cache_line[63:16],data_in,cache_line[7:0]};
        2:write_mux={cache_line[63:24],data_in,cache_line[15:0]};
        3:write_mux={cache_line[63:32],data_in,cache_line[23:0]};
        4:write_mux={cache_line[63:40],data_in,cache_line[31:0]};
        5:write_mux={cache_line[63:48],data_in,cache_line[39:0]};
        6:write_mux={cache_line[63:56],data_in,cache_line[47:0]};
        7:write_mux={data_in,cache_line[55:0]};
        default:write_mux={cache_line[63:8],data_in};
    endcase
endfunction

assign rdata=read_mux(offset,cache[index]);

always @(posedge clk) begin
	if(update) begin
        cache[index]<=data_block; //if cache controller indicates data is ready then update cache
    end
	 
	 if (wr_en) cache[index]<=write_mux(offset,cache[index],wdata); //if write store word from processor
end

endmodule
