//---------------------------------------------------
// Macro definition
//---------------------------------------------------

//Short names
`define TB        tb.dut
`define MASTER    tb.dut.dec_test_inst.master
`define SLAVE     tb.dut.dec_test_inst.sem

//`define EXT_T       tb.dut.dec_test_inst_sem_export_bfm_conduit_train
//`define EXT_R       tb.dut.dec_test_inst_sem_export_red
//`define EXT_Y       tb.dut.dec_test_inst_sem_export_yellow
//`define EXT_G       tb.dut.dec_test_inst_sem_export_green

`define EXT           tb.dut.dec_test_inst_sem_export_bfm

`define RESET     tb.dut.dec_test_inst_reset_bfm_reset_reset
`define CLK       tb.dut.dec_test_inst_clk_bfm_clk_clk

// BFM related parameters
`define AV_ADDRESS_W  32
`define AV_SYMBOL_W   8
`define AV_NUMSYMBOLS 4

// derived parameters
`define AV_DATA_W (`AV_SYMBOL_W * `AV_NUMSYMBOLS)

module test_program ();

  import verbosity_pkg::*;
  import avalon_mm_pkg::*;

  event start_test;

  logic [`AV_DATA_W-1:0] divisor[3:0] = {
    {8'd10, 8'd70, 8'd50, 8'd20},
    {8'd10, 8'd30, 8'd40, 8'd30},
    {8'd10, 8'd30, 8'd10, 8'd100},
    {8'd10, 8'd60, 8'd80, 8'd50}
  };

  Request_t command_request, response_request;
  reg [`AV_ADDRESS_W-1:0] command_addr, response_addr;
  reg [`AV_DATA_W-1:0] command_data, response_data;
  reg [`AV_NUMSYMBOLS-1:0] byte_enable;
  reg [`AV_DATA_W-1:0] idle;  
  integer init_latency;
  integer set;
  reg red, yellow, green;
  reg [`AV_DATA_W-1:0] master_scoreboard [$];

  initial 
  begin
    set_verbosity(VERBOSITY_INFO);
    `MASTER.init();	
    `EXT.set_train(0);
    //wait for reset to de-assert and trigger start_test event
    wait(`RESET == 1);
    repeat (10) @(posedge `CLK);
    ->start_test;
  end

  initial
  begin
    @ start_test;    //wait start test signal
    byte_enable = '1;  //all byte lanes are used
    idle = 0;  //no idle cycle between each command of the master BFM
    init_latency = 0;  //the command is launched to Avalon bus with no delay
      
    //write memory
    command_addr = 0;
    for (int i = 0; i < 4; i++) 
    begin
      command_data = divisor[i];
      master_set_and_push_command(REQ_WRITE, command_addr, command_data, byte_enable, idle, init_latency);
	  command_addr = command_addr + 4;
    end   

    //write time set
    set = 0;
    command_data = set;
    command_addr = 32'h14;
    master_set_and_push_command(REQ_WRITE, command_addr, command_data, byte_enable, idle, init_latency);

    //write start
    command_data = 1;
    command_addr = 32'h10;
    master_set_and_push_command(REQ_WRITE, command_addr, command_data, byte_enable, idle, init_latency);

    //wait until pushed commands execute
    @`MASTER.signal_all_transactions_complete;

    //pass 4 trains with different dividers
    repeat (4)
    begin
        //pass train
        repeat (10) @(posedge `CLK);
        `EXT.set_train(1);
        repeat (10) @(posedge `CLK);
        `EXT.set_train(0);

        //wait for green
        do begin
            repeat (10) @(posedge `CLK);
            red = `EXT.get_red();
            yellow = `EXT.get_yellow();
            green = `EXT.get_green();
            $sformat(message, "At %0dns red: %0d, yellow: %0d, green: %0d", $time, red, yellow, green); 
            print(VERBOSITY_INFO, message);
        end while (!({red,yellow,green}==3'b001));

        //change time set
        if (set < 3)
        begin
            set = (set + 1);
            command_data = set;
            command_addr = 32'h14;
            master_set_and_push_command(REQ_WRITE, command_addr, command_data, byte_enable, idle, init_latency);
            //wait until pushed command executes
            @`MASTER.signal_all_transactions_complete;
        end
    end

	$sformat(message, "Test has completed");
	print(VERBOSITY_INFO, message);
	$stop;  
end

  //this task sets the command descriptor for master BFM and pushes it to the queue
  task master_set_and_push_command;
  input Request_t request;
  input [`AV_ADDRESS_W-1:0] addr;
  input [`AV_DATA_W-1:0] data;
  input [`AV_NUMSYMBOLS-1:0] byte_enable;
  input [`AV_DATA_W-1:0] idle;
  input [31:0] init_latency;
    
  begin
	`MASTER.set_command_request(request);
    `MASTER.set_command_address(addr);    
    `MASTER.set_command_byte_enable(byte_enable,0);
    `MASTER.set_command_idle(idle, 0);
	`MASTER.set_command_init_latency(init_latency);
    if (request == REQ_WRITE)
	begin
	   `MASTER.set_command_data(data,0);      
	end
    //run transaction
	`MASTER.push_command();
  end
  endtask

endmodule 
