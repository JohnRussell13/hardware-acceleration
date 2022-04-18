`ifndef CNN_DIN_AGENT_PKG
`define CNN_DIN_AGENT_PKG

package cnn_din_agent_pkg;
 
   import uvm_pkg::*;
   `include "uvm_macros.svh"

   //////////////////////////////////////////////////////////
   // include Agent components : driver,monitor,sequencer
   /////////////////////////////////////////////////////////
   import configurations_pkg::*;   
   
   `include "file_cnn_din_seq_item.sv"
   `include "file_cnn_din_sequencer.sv"
   `include "file_cnn_din_driver.sv"
   `include "file_cnn_din_monitor.sv"
   `include "file_cnn_din_agent.sv"

endpackage

`endif