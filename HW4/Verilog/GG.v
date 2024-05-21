module GG #(
	parameter R_LEN  = 12,
	parameter R_FRAC = 2
)(
	input 								nop,
	input        signed [R_LEN-1:0]		xi,
	input        signed [R_LEN-1:0]		yi,
	input				[3:0]			iter,
		
	output				[1:0]			d1,
	output				[1:0]			d2,
	output				[1:0]			d3,
	output				[1:0]			d4,
	output								neg,
	output  reg  signed [R_LEN-1:0]     xo,
	output  reg  signed [R_LEN-1:0]     yo
);

reg   signed [R_LEN-1:0]                   xi_0;
reg   signed [R_LEN-1:0]                   yi_0;

reg   signed [R_LEN-1:0]                   xo_0;
reg   signed [R_LEN-1:0]                   yo_0;

reg   signed [R_LEN-1:0]                   xo_1;
reg   signed [R_LEN-1:0]                   yo_1;

reg   signed [R_LEN-1:0]                   xo_2;
reg   signed [R_LEN-1:0]                   yo_2;

// check whether xi is positive or negative
assign neg = xi[R_LEN-1];

// decide the rotation direction: 1 means counterclockwise(+), 0 means clockwise(-)
assign d1 = (yi_0==0) ? 2: xi_0[R_LEN-1] ^ yi_0[R_LEN-1];
assign d2 = (yo_0==0) ? 2: xo_0[R_LEN-1] ^ yo_0[R_LEN-1];
assign d3 = (yo_1==0) ? 2: xo_1[R_LEN-1] ^ yo_1[R_LEN-1];
assign d4 = (yo_2==0) ? 2: xo_2[R_LEN-1] ^ yo_2[R_LEN-1];

always @(*) begin
	if (neg) begin
		xi_0 = -xi;
		yi_0 = -yi;
	end
	else begin
		xi_0 = xi;
		yi_0 = yi;
	end
end

always @(*) begin
    if(d1==2) begin
        xo_0 = xi_0;
		yo_0 = yi_0;
    end
	else if(d1==1) begin
		xo_0 = xi_0 - (yi_0 >>> iter);
		yo_0 = yi_0 + (xi_0 >>> iter);
	end
	else begin
		xo_0 = xi_0 + (yi_0 >>> iter);
		yo_0 = yi_0 - (xi_0 >>> iter);
	end
end

always @(*) begin
	if(nop) begin
		xo_1 = xi;
		yo_1 = yi;
	end
	else if(d2==2) begin
        xo_1 = xo_0;
		yo_1 = yo_0;
    end
	else if(d2==1) begin
		xo_1 = xo_0 - (yo_0 >>> (iter + 1));
		yo_1 = yo_0 + (xo_0 >>> (iter + 1));
	end
	else begin
		xo_1 = xo_0 + (yo_0 >>> (iter + 1));
		yo_1 = yo_0 - (xo_0 >>> (iter + 1));
	end
end

always @(*) begin
	if(nop) begin
		xo_2 = xo_1;
		yo_2 = yo_1;
	end
	else if(d3==2) begin
        xo_2 = xo_1;
		yo_2 = yo_1;
    end
	else if(d3==1) begin
		xo_2 = xo_1 - (yo_1 >>> (iter + 2));
		yo_2 = yo_1 + (xo_1 >>> (iter + 2));
	end
	else begin
		xo_2 = xo_1 + (yo_1 >>> (iter + 2));
		yo_2 = yo_1 - (xo_1 >>> (iter + 2));
	end
end

always @(*) begin
	if(nop) begin
		xo = xo_2;
		yo = yo_2;
	end
	else if(d4==2) begin
        xo = xo_2;
		yo = yo_2;
    end
	else if(d4==1) begin
		xo = xo_2 - (yo_2 >>> (iter + 3));
		yo = yo_2 + (xo_2 >>> (iter + 3));
	end
	else begin
		xo = xo_2 + (yo_2 >>> (iter + 3));
		yo = yo_2 - (xo_2 >>> (iter + 3));
	end
end

endmodule
