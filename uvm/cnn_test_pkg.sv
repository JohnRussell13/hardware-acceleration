`ifndef CNN_TEST_PKG_SV
`define CNN_TEST_PKG_SV

package cnn_test_pkg;

  import uvm_pkg::*;      // import the UVM library   
 `include "uvm_macros.svh" // Include the UVM macros

  import cnn_din_agent_pkg::*;
  import cnn_dout_agent_pkg::*;
  import cnn_din_seq_pkg::*;
  import cnn_dout_seq_pkg::*;
  import configurations_pkg::*;   
  `include "file_cnn_env.sv"
  `include "file_cnn_scoreboard.sv"   
  `include "test_base.sv"
  `include "test_simple.sv"
  `include "test_simple_2.sv"


endpackage : cnn_test_pkg

 `include "cnn_if.sv"

`endif