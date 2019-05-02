`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Damith Kawshan
// 
// Create Date:    21:45:03 04/30/2019 
// Design Name: 	
// Module Name:    cache_controller 
// Project Name:   Cache Memory Design
// Target Devices: 
// Tool versions: 
// Description: controll the operation of cache (according to mentioned specifications)
//					 carried out following functions
//              if read checks validity of cache line : if valid check tag
//					 if tag matches get the word from cache
//					 if not stalls the processor get word from cache
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module cache_controller(
	 input clk,
    input [6:0] tag, //tag field
    input [5:0] index,//cache line
    input wr_en, //write/read signal (1,0)
    input flush, //reset cache - set all valid bits to zero
    input ready, //data block ready sig from memory
    output stall, //stall the processor (1,0)
    output wr_en_mem,//write/read signal to memory (1,0)
    output update_cache,//update data array
	 output reg cache_hit //indicate cache hit/loss (1,0)
    );
	 
integer i; //used to flush and initialize tag and validity fields

reg [6:0] tag_field [63:0]; 
reg validity_field [63:0];


initial begin
	for (i=0;i<64;i=i+1) begin
		validity_field[i]=1'b0;
		tag_field[i]=1'b0;
	end
end

assign update_cache=ready; //whenever data block ready signal is reitrieved from memory alert data array
assign stall=~(cache_hit|wr_en); //stall the processor if cache loss or wr_en 
assign wr_en_mem=wr_en; //direct write signal to memory

always @(posedge clk) begin //work well with non-blocking

	if (validity_field[index]) cache_hit=(tag_field[index]==tag); //if cache line is valid check tag field for cache hits
	else cache_hit=0;

	if (~wr_en) begin
		if (ready) begin //if data block is ready updatecirresponding tag and validity bits
			validity_field[index]=1;
			tag_field[index]=tag;
		end
	end
	
	if (flush) begin //set all valid bits to zero
		for (i=0;i<64;i=i+1) begin
			validity_field[i]=1'b0;
		end
	end
	
end

endmodule
