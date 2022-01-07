// (C) 2001-2018 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// $Id: //acds/main/ip/sopc/components/verification/altera_tristate_conduit_bfm/altera_tristate_conduit_bfm.sv.terp#7 $
// $Revision: #7 $
// $Date: 2010/08/05 $
// $Author: klong $
//-----------------------------------------------------------------------------
// =head1 NAME
// altera_conduit_bfm
// =head1 SYNOPSIS
// Bus Functional Model (BFM) for a Standard Conduit BFM
//-----------------------------------------------------------------------------
// =head1 DESCRIPTION
// This is a Bus Functional Model (BFM) for a Standard Conduit Master.
// This BFM sampled the input/bidirection port value or driving user's value to 
// output ports when user call the API.  
// This BFM's HDL is been generated through terp file in Qsys/SOPC Builder.
// Generation parameters:
// output_name:                                       altera_conduit_bfm
// role:width:direction:                              green:1:input,red:1:input,train:1:output,yellow:1:input
// 0
//-----------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module altera_conduit_bfm
(
   sig_green,
   sig_red,
   sig_train,
   sig_yellow
);

   //--------------------------------------------------------------------------
   // =head1 PINS 
   // =head2 User defined interface
   //--------------------------------------------------------------------------
   input sig_green;
   input sig_red;
   output sig_train;
   input sig_yellow;

   // synthesis translate_off
   import verbosity_pkg::*;
   
   typedef logic ROLE_green_t;
   typedef logic ROLE_red_t;
   typedef logic ROLE_train_t;
   typedef logic ROLE_yellow_t;

   logic [0 : 0] sig_green_in;
   logic [0 : 0] sig_green_local;
   logic [0 : 0] sig_red_in;
   logic [0 : 0] sig_red_local;
   reg sig_train_temp;
   reg sig_train_out;
   logic [0 : 0] sig_yellow_in;
   logic [0 : 0] sig_yellow_local;

   //--------------------------------------------------------------------------
   // =head1 Public Methods API
   // =pod
   // This section describes the public methods in the application programming
   // interface (API). The application program interface provides methods for 
   // a testbench which instantiates, controls and queries state in this BFM 
   // component. Test programs must only use these public access methods and 
   // events to communicate with this BFM component. The API and module pins
   // are the only interfaces of this component that are guaranteed to be
   // stable. The API will be maintained for the life of the product. 
   // While we cannot prevent a test program from directly accessing internal
   // tasks, functions, or data private to the BFM, there is no guarantee that
   // these will be present in the future. In fact, it is best for the user
   // to assume that the underlying implementation of this component can 
   // and will change.
   // =cut
   //--------------------------------------------------------------------------
   
   event signal_input_green_change;
   event signal_input_red_change;
   event signal_input_yellow_change;
   
   function automatic string get_version();  // public
      // Return BFM version string. For example, version 9.1 sp1 is "9.1sp1" 
      string ret_version = "18.1";
      return ret_version;
   endfunction

   // -------------------------------------------------------
   // green
   // -------------------------------------------------------
   function automatic ROLE_green_t get_green();
   
      // Gets the green input value.
      $sformat(message, "%m: called get_green");
      print(VERBOSITY_DEBUG, message);
      return sig_green_in;
      
   endfunction

   // -------------------------------------------------------
   // red
   // -------------------------------------------------------
   function automatic ROLE_red_t get_red();
   
      // Gets the red input value.
      $sformat(message, "%m: called get_red");
      print(VERBOSITY_DEBUG, message);
      return sig_red_in;
      
   endfunction

   // -------------------------------------------------------
   // train
   // -------------------------------------------------------

   function automatic void set_train (
      ROLE_train_t new_value
   );
      // Drive the new value to train.
      
      $sformat(message, "%m: method called arg0 %0d", new_value); 
      print(VERBOSITY_DEBUG, message);
      
      sig_train_temp = new_value;
   endfunction

   // -------------------------------------------------------
   // yellow
   // -------------------------------------------------------
   function automatic ROLE_yellow_t get_yellow();
   
      // Gets the yellow input value.
      $sformat(message, "%m: called get_yellow");
      print(VERBOSITY_DEBUG, message);
      return sig_yellow_in;
      
   endfunction

   assign sig_green_in = sig_green;
   assign sig_red_in = sig_red;
   assign sig_train = sig_train_temp;
   assign sig_yellow_in = sig_yellow;


   always @(sig_green_in) begin
      if (sig_green_local != sig_green_in)
         -> signal_input_green_change;
      sig_green_local = sig_green_in;
   end
   
   always @(sig_red_in) begin
      if (sig_red_local != sig_red_in)
         -> signal_input_red_change;
      sig_red_local = sig_red_in;
   end
   
   always @(sig_yellow_in) begin
      if (sig_yellow_local != sig_yellow_in)
         -> signal_input_yellow_change;
      sig_yellow_local = sig_yellow_in;
   end
   


// synthesis translate_on

endmodule

