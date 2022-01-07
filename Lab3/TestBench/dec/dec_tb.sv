`timescale 1 ns/1 ns

module dec_tb();

	// Wires and variables to connect to UUT (unit under test)
	logic clk, clrn, train;
	logic r, y, g;
    logic [1:0] div;
	logic ctl_wr, ctl_rd;
	logic ctl_addr;
	logic [31:0] ctl_wrdata;
	logic [31:0] ctl_rddata;
	logic ram_wr;
	logic [1:0] ram_addr;
	logic [31:0] ram_wrdata;

    logic [31:0] divisor[3:0] = {
        {8'd10, 8'd70, 8'd50, 8'd20},
        {8'd10, 8'd30, 8'd40, 8'd30},
        {8'd10, 8'd30, 8'd10, 8'd100},
        {8'd10, 8'd60, 8'd80, 8'd50}
    };
	
	// Instantiate UUT
	dec my_sem(
        .clk(clk), .clrn(clrn),
        .ctl_wr(ctl_wr), .ctl_rd(ctl_rd), 
        .ctl_addr(ctl_addr), .ctl_wrdata(ctl_wrdata), .ctl_rddata(ctl_rddata),
        .ram_wr(ram_wr),
        .ram_addr(ram_addr), .ram_wrdata(ram_wrdata),
		.train(train), .red(r), .yellow(y), .green(g)
    );

	// Clock definition
	initial begin
		clk = 0;
		forever #10 clk = ~clk;
	end
	
	// Divisor and train definition
	initial begin
        //initial reset
        clrn = 0;
		div = 0;
		train = 0;
        //take reset off
        @(negedge clk) clrn = 1;
        //configure semaphore
        for (int i=0; i<4; i++) write_ram_transaction(i,divisor[i]);        //write divisor RAM
        write_reg_transaction(1,div);   //write initial divisor
        write_reg_transaction(0,1);     //enable semaphore
        //run trains
		repeat (4)
		begin
            repeat (10) @(posedge clk);
			train=1;
            repeat (4) @(posedge clk);
			train=0;
			wait ({r,y,g}==3'b001);
            repeat (10) @(posedge clk);
            write_reg_transaction(1,div);
            div=div+1;
		end
        //wait a little
		repeat (10) @(posedge clk); 
        $stop;
	end
	
	//Single register write transaction task
	task write_reg_transaction;
		//input signals
		input offs;
		input [31:0] val;
		//transaction implementation
		begin
			@(posedge clk);
			//assert signals for one clock cycle
			ctl_wr = 1;
			ctl_addr = offs;
			ctl_wrdata = val;
			@(posedge clk);
			//deassert signals
			ctl_wr = 0;
			ctl_addr = 'bx;
			ctl_wrdata = 'bx;
		end
	endtask

	//Single register read transaction task
	task read_reg_transaction;
		//input signals
		input [1:0] offs;
		output [31:0] val;
		//transaction implementation
		begin
			@(posedge clk);
			//assert signals for one clock cycle
			ctl_rd = 1;
			ctl_addr = offs;
			@(posedge clk);
            val = ctl_rddata;
			//deassert signals
			ctl_rd = 0;
			ctl_addr = 'bx;
		end
	endtask

	//RAM write transaction task
	task write_ram_transaction;
		//input signals
		input [1:0] offs;
		input [31:0] val;
		//transaction implementation
		begin
			@(posedge clk);
			//assert signals for one clock cycle
			ram_wr = 1;
			ram_addr = offs;
			ram_wrdata = val;
			@(posedge clk);
			//deassert signals
			ram_wr = 0;
			ram_addr = 'bx;
			ram_wrdata = 'bx;
		end
	endtask

endmodule
