`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:56:11 05/01/2019 
// Design Name: 
// Module Name:    data_mem_subsystem 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module data_mem_subsystem(
    input flush, //reset cache - set all valid bits to zero (1,0) 
    input clk,
    input wr_en, //write/read signal (1,0)
    input [15:0] addr, //mem address from processor
    input [7:0] rdata, //data from processor
    output [7:0] wdata,//data to processor
    output stall, //stall the processor (1,0)
	 output cache_hit//indicates cache hit/loss (1,0)
    );

wire [6:0] tag;
wire [5:0] index;
wire [2:0] offset;

//divide address into tag,index,offset
assign {tag,index,offset}=addr;

wire ready;//mem_block_creation-done
wire wr_en_mem;//write data to mem
wire update;//update cache

cache_controller cache_controller(
            .clk(clk),
            .tag(tag),
            .index(index),
            .wr_en(wr_en),
            .flush(flush),
            .ready(ready),
            .stall(stall),
            .wr_en_mem(wr_en_mem),
            .update_cache(update),
				.cache_hit(cache_hit)
            );

wire [63:0] data_block;//data from mem

data_array data_array(
            .data_block(data_block),
            .rdata(wdata),
            .update(update),
            .index(index),
            .offset(offset),
				.clk(clk),
				.wdata(rdata),
				.wr_en(wr_en)
            );

memory_module memory_module(
            .clk(clk),
            .data_in(rdata),
            .block_out(data_block),
            .wr_en(wr_en_mem),
            .ready(ready),
            .addr(addr)
            );

endmodule
