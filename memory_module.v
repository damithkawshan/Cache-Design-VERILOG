`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Damith Kawshan
// 
// Create Date:    21:45:03 04/30/2019 
// Design Name: 	
// Module Name:    memory_controller 
// Project Name:   Cache Memory Design
// Target Devices: 
// Tool versions: 
// Description: This module contains dram and controller
//					 dram			 = block RAM of 8*65536 bits (64kB)
//					 controller	 =  get 8B from dram and create data block
//
//					 assert ready = 1 when data block is ready
//
// Dependencies: 
//
// Revision: 2.0
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module memory_module(
    input [7:0] data_in, //data from processor
    output [63:0] block_out,// output data-block initially xxxxxx.....
    input clk,
    input wr_en,//1=>write data to dram 0=>read data block form dram
    output ready, //indicate block is ready
    input [15:0] addr //address from processor
    );
	 
//identify the completion of data-block
reg prev;
reg [15:0] prev_addr;
reg [15:0] curr_addr;

//wires for dram
wire [7:0] mem_out;//data from dram
wire [15:0] loc;// addr to dram
wire [15:0] loc_read;

//wires for counter
reg reset;
wire start;
wire done;
wire [3:0] offset;

//data stack which stores data from dram
reg [7:0] data_block [8:0];

//initiate dram module
dram main_memory(
    .clka(clk),
    .wea(wr_en),
    .addra(loc),
    .dina(data_in),
    .douta(mem_out));

//counter counts from 0-7 and if counter=8 return done=1	 
counter counter(
	 .clk(clk),
	 .reset(reset),
	 .done(done),
	 .out_val(offset),
	 .start(start)
		);

assign start=~wr_en&~done;//start counter if wr_en set to zero or counter computation is not done

assign loc_read={addr[15:3],offset[2:0]};//data pointer 
assign loc=(wr_en)?addr:loc_read;//if data should be stored in dram (i.e wr_en=1) addr to dram => use addr from processor else used generated addr

assign block_out={data_block[8],data_block[7],data_block[6],data_block[5],data_block[4],data_block[3],data_block[2],data_block[1]};

//if data_block ready set ready to one
assign ready=({offset[2:0],(done|prev)}==0001 & ~wr_en); 

// at the positive edges of the clock
always @(posedge clk) begin
	data_block[offset]<=mem_out; //store datafrom dram in stack
	prev<=done;
	curr_addr<=addr;
	prev_addr<=curr_addr;
		
	if (prev_addr==addr|wr_en) reset<=0; //if change in addr detected set counter to zero
	else reset<=1;
end

endmodule
