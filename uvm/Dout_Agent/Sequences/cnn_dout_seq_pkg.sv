`ifndef CNN_DOUT_SEQ_PKG_SV
`define CNN_DOUT_SEQ_PKG_SV

package cnn_dout_seq_pkg;
  import uvm_pkg::*;      // import the UVM library
  `include "uvm_macros.svh" // Include the UVM macros
  import cnn_dout_agent_pkg::cnn_dout_seq_item;
  import cnn_dout_agent_pkg::cnn_dout_sequencer;
  `include "file_cnn_dout_base_seq.sv"
  `include "file_cnn_dout_simple_seq.sv"
endpackage 

`endif