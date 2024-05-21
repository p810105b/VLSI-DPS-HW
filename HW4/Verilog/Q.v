module Q #(
	parameter Q_LEN  = 12,
	parameter R_FRAC = 2
)(	
	input						nop,
	input	signed 	[Q_LEN-1:0] xi,
	input	signed 	[Q_LEN-1:0] yi,
	input			[3:0] 		iter,
	input			[1:0] 		d1,
	input			[1:0] 		d2,
	input			[1:0] 		d3,
	input			[1:0] 		d4,
	input						neg,
	
	output	signed 	[Q_LEN-1:0]	xo,
	output	signed 	[Q_LEN-1:0]	yo
);

wire signed [Q_LEN-1:0]	xi_0 = neg ? -xi : xi;
wire signed [Q_LEN-1:0]	yi_0 = neg ? -yi : yi;
	 
wire signed [Q_LEN-1:0]	xo_1;
wire signed [Q_LEN-1:0]	yo_1;

wire signed [Q_LEN-1:0]	xo_2;
wire signed [Q_LEN-1:0]	yo_2;
					
wire signed [Q_LEN-1:0]	xo_3;
wire signed [Q_LEN-1:0]	yo_3;

wire signed [Q_LEN-1:0]	xo_4;
wire signed [Q_LEN-1:0]	yo_4;

wire [3:0] iter_1 = iter;
wire [3:0] iter_2 = iter + 1;
wire [3:0] iter_3 = iter + 2;
wire [3:0] iter_4 = iter + 3;

assign xo = nop ? xi : xo_4;
assign yo = nop ? yi : yo_4;

Q_one_iter Q_one_iter_inst_1(	
	.xi		(xi_0	),
	.yi  	(yi_0	),
	.iter	(iter_1	),
	.d   	(d1		),
	.xo  	(xo_1	),
	.yo  	(yo_1	)
);

Q_one_iter Q_one_iter_inst_2(	
	.xi		(xo_1	),
	.yi  	(yo_1	),
	.iter	(iter_2	),
	.d   	(d2		),
	.xo  	(xo_2	),
	.yo  	(yo_2	)
);

Q_one_iter Q_one_iter_inst_3(	
	.xi		(xo_2	),
	.yi  	(yo_2	),
	.iter	(iter_3	),
	.d   	(d3		),
	.xo  	(xo_3	),
	.yo  	(yo_3	)
);

Q_one_iter Q_one_iter_inst_4(	
	.xi		(xo_3	),
	.yi  	(yo_3	),
	.iter	(iter_4	),
	.d   	(d4		),
	.xo  	(xo_4	),
	.yo  	(yo_4	)
);


endmodule


module Q_one_iter #(
	parameter Q_LEN  = 12,
	parameter R_FRAC = 2
)
(	input        signed [Q_LEN-1:0] 	xi,
	input        signed [Q_LEN-1:0] 	yi,
	input				[3:0] 			iter,
	input				[1:0] 			d,
	output  reg  signed [Q_LEN-1:0]		xo,
	output  reg  signed [Q_LEN-1:0]		yo
);

always @(*) begin
	if(d == 2) begin
        xo = xi;
		yo = yi;
    end
	else if(d == 1) begin
		xo = xi - (yi >>> iter);
		yo = yi + (xi >>> iter);
	end
	else begin
		xo = xi + (yi >>> iter);
		yo = yi - (xi >>> iter);
	end
end

endmodule
