`ifndef CNN_VERIF_TOP_SV
`define CNN_VERIF_TOP_SV

module cnn_verif_top;

   import uvm_pkg::*;     // import the UVM library
`include "uvm_macros.svh" // Include the UVM macros

   import cnn_test_pkg::*;

   logic clk;

   // interface
   cnn_if cnn_vif(clk);

   // DUT
   cnn DUT(
                .clk          ( clk ),
                .start        ( cnn_vif.start ),
                .ready        ( cnn_vif.ready ),
                .addra        ( cnn_vif.addra ),
                .dina         ( cnn_vif.dina ),
                .wea          ( cnn_vif.wea ),
                .r_o_0          ( cnn_vif.r_0 ),
                .r_o_1          ( cnn_vif.r_1 ),
                .r_o_2          ( cnn_vif.r_2 ),
                .r_o_3          ( cnn_vif.r_3 ),
                .r_o_4          ( cnn_vif.r_4 ),
                .r_o_5          ( cnn_vif.r_5 ),
                .r_o_6          ( cnn_vif.r_6 ),
                .r_o_7          ( cnn_vif.r_7 ),
                .r_o_8          ( cnn_vif.r_8 ),
                .r_o_9          ( cnn_vif.r_9 )
                );

   // run test
   initial begin      
      uvm_config_db#(virtual cnn_if)::set(null, "uvm_test_top.env", "cnn_if", cnn_vif);
      run_test();
   end

   // clock and start init.
   initial begin
      cnn_vif.start = 0;
      clk <= 1;
   end

   // clock generation
   always #50 clk = ~clk;

endmodule : cnn_verif_top

`endif