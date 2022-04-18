`ifndef CNN_DIN_SEQ_PKG_SV
`define CNN_DIN_SEQ_PKG_SV

package cnn_din_seq_pkg;
  import uvm_pkg::*;      // import the UVM library
  `include "uvm_macros.svh" // Include the UVM macros
  import cnn_din_agent_pkg::cnn_din_seq_item;
  import cnn_din_agent_pkg::cnn_din_sequencer;
  `include "file_cnn_din_base_seq.sv"
  `include "file_cnn_din_simple_seq.sv"
endpackage 

`endif