module MovingAverageFilter (
		input clk,
		input [7:0] din,
		output [7:0] y
	);
	
	reg [7:0] d_pipe [0:3];
	integer i;
	
	always @(posedge clk) begin
		d_pipe[0] <= din;
		
		for (i=1;i<4;i=i+1) begin
			d_pipe[i] <= d_pipe[i-1];
		end
	end
	
	reg [8:0] partsum [0:1];
	
	always @(posedge clk) begin
		partsum[0] <= d_pipe[0] + d_pipe[1];
		partsum[1] <= d_pipe[2] + d_pipe[3];
	end
	
	reg [9:0] sum;
	
	always @(posedge clk) begin
		sum <= partsum[0] + partsum[1];
	end
	
	assign y = sum[9:2];
	
endmodule