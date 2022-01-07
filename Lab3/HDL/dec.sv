module dec 
#(m = 8) 
(
	//clock and reset
    input logic clk, clrn, 
    //control slave
    input logic ctl_wr, ctl_rd, 
	input logic ctl_addr,
	input logic [31:0] ctl_wrdata,
	output logic [31:0] ctl_rddata,
	//memory slave
	input logic ram_wr,
	input logic [1:0] ram_addr,
	input logic [31:0] ram_wrdata,
	//external ports
	input logic train,
   output logic red, yellow, green
);

	logic run;
   logic [1:0] divider;
	
   logic [m-1:0] divisor = 'bz;
	logic [m-1:0] cntdiv;
	logic [1:0] contr;
	logic [2:0] colors;
	logic enacnt;

	//control slave logic	
	always_ff @(posedge clk or negedge clrn)
	begin
		if (!clrn) 
		begin
			run <= 0;
			divider <= 0;
		end
		else
		begin			
			if (ctl_wr)
			begin
				case (ctl_addr)
					1'b0: run <= ctl_wrdata[0];
					1'b1: divider <= ctl_wrdata[1:0];
				endcase
			end			
		end
	end	
	
	always_comb
	begin
		case (ctl_addr)
			1'b0: ctl_rddata = {31'b0 <= run};
			1'b1: ctl_rddata = {30'b0 <=divider};
			default: ctl_rddata = 'bx;
		endcase	
		
	end	


	//semaphore logic		
	always_ff @(posedge clk or negedge clrn) 
	begin
		if (!clrn) cntdiv<=0;
		else
		begin
			if (train | !run) cntdiv<=0;
			else
			begin
				if (cntdiv==divisor) cntdiv <= 0;
				else cntdiv<=cntdiv+1;
			end
		end
	end
	
	always_comb
	begin
		enacnt=(cntdiv==divisor);
	end
	
	always_ff @(posedge clk or negedge clrn)
	begin
		if (!clrn) 
		begin
			colors <= 3'b100;
		end
		else
		begin
			if (train | ~run)
			begin
				colors <= 3'b100;
			end
			else
			begin
				if (enacnt)
				begin
					case (colors)
					3'b100: colors <= 3'b010;
					3'b010: colors <= 3'b011;
					3'b011: colors <= 3'b001;
					3'b001: colors <= 3'b001;
					default: colors <= 3'b100;
					endcase
				end
			end
		end
	end
	
	
	
	always_comb
	begin
		case (colors)
		3'b100: contr = 2'b00;
		3'b010: contr = 2'b01;
		3'b011: contr = 2'b10;
		3'b001: contr = 2'b11;
		default: contr = 2'b00;
		endcase	
	end	
	
	
	assign red = colors[2];
	assign yellow = colors[1];
	assign green = colors[0];

	periodram	b2v_inst3(
			.clock(clk),
			.data(ram_wrdata),
			.wraddress(ram_addr),
			.wren(ram_wr),
			.rdaddress({divider,contr}),
			.q(divisor)
	);


	endmodule
