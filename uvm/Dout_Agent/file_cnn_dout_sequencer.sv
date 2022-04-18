`ifndef CNN_DOUT_SEQUENCER_SV
`define CNN_DOUT_SEQUENCER_SV

class cnn_dout_sequencer extends uvm_sequencer#(cnn_dout_seq_item);

   `uvm_component_utils(cnn_dout_sequencer)

   function new(string name = "cnn_dout_sequencer", uvm_component parent = null);
      super.new(name,parent);
   endfunction

endclass : cnn_dout_sequencer

`endif

