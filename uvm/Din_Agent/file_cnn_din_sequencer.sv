`ifndef CNN_DIN_SEQUENCER_SV
`define CNN_DIN_SEQUENCER_SV

class cnn_din_sequencer extends uvm_sequencer#(cnn_din_seq_item);

   `uvm_component_utils(cnn_din_sequencer)

   function new(string name = "cnn_din_sequencer", uvm_component parent = null);
      super.new(name,parent);
   endfunction

endclass : cnn_din_sequencer

`endif