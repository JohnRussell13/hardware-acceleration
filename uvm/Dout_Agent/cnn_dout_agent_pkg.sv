`ifndef CNN_DOUT_AGENT_PKG
`define CNN_DOUT_AGENT_PKG

package cnn_dout_agent_pkg;
 
   import uvm_pkg::*;
   `include "uvm_macros.svh"

   //////////////////////////////////////////////////////////
   // include Agent components : driver,monitor,sequencer
   /////////////////////////////////////////////////////////
   import configurations_pkg::*;   
   
   `include "file_cnn_dout_seq_item.sv"
   `include "file_cnn_dout_sequencer.sv"
   `include "file_cnn_dout_driver.sv"
   `include "file_cnn_dout_monitor.sv"
   `include "file_cnn_dout_agent.sv"

endpackage

`endif



