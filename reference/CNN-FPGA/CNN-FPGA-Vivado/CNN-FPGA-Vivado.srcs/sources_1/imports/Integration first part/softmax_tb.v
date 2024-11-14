`timescale 1ps/1ps
module softmax_tb();
localparam DATA_WIDTH=32;
localparam inputNum=10;
reg [DATA_WIDTH*inputNum-1:0] inputs;
reg clk;
reg enable;
wire [DATA_WIDTH*inputNum-1:0] outputs;
wire ackSoft;
softmax1 #(.DATA_WIDTH(DATA_WIDTH)) soft(inputs,clk,enable,outputs,ackSoft);

localparam PERIOD = 100;
integer count;
always 
	#(PERIOD/2) clk = ~clk;

initial begin
	clk=1'b1;
	inputs=320'b00111110010011001100110011001101_10111110010011001100110011001101_00111111100110011001100110011010_00111111101001100110011001100110_10111111011001100110011001100110_00111110100110011001100110011010_01000000010001100110011001100110_10111100101000111101011100001010_00111111100011100001010001111011_00111110101001010110000001000010;
	//inputs are 0.2 -0.2 1.2 1.3 -0.9 0.3 3.1 -0.02 1.11 0.323
	count=1;
	enable=1'b0;
	#(PERIOD);
	enable=1'b1;
	
	while(ackSoft!=1'b1) begin
		count=count+1;
		#(PERIOD);		
	end
	//outputs are 0.03255, 0.02182, 0.08847, 0.09776, 0.0108, 0.0359, 0.5687,  0.02612, 0.0808, 0.03681

	inputs=320'b00111111001100001010001111010111_10111110010011001100110011001101_00111111100110011001100110011010_00111111101001100110011001100110_10111111011001100110011001100110_00111110100110011001100110011010_01000000010001100110011001100110_10111100101000111101011100001010_00111111100011100001010001111011_00111110101001010110000001000010;
	//inputs are 0.69 -0.2 1.2 1.3 -0.9 0.3 3.1 -0.02 1.11 0.323
	count=1;
	enable=1'b0;
	#(PERIOD);
	enable=1'b1;
	while(ackSoft!=1'b1) begin
		count=count+1;
		#(PERIOD);

	end
	//outputs are 0.05207118 0.0213835  0.0866926  0.09579553 0.01062096 0.03525543 0.5572659  0.0256007  0.07923851 0.0360757
 										
end

endmodule