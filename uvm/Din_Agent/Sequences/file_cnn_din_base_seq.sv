`ifndef CNN_DIN_BASE_SEQ_SV
`define CNN_DIN_BASE_SEQ_SV

class cnn_din_base_seq extends uvm_sequence#(cnn_din_seq_item);

   `uvm_object_utils(cnn_din_base_seq)
   `uvm_declare_p_sequencer(cnn_din_sequencer)

   function new(string name = "cnn_din_base_seq");
      super.new(name);
   endfunction

   // objections are raised in pre_body
   virtual task pre_body();
      uvm_phase phase = get_starting_phase();
      if (phase != null)
        phase.raise_objection(this, {"Running sequence '", get_full_name(), "'"});
   endtask : pre_body

   // objections are dropped in post_body
   virtual task post_body();
      uvm_phase phase = get_starting_phase();
      if (phase != null)
        phase.drop_objection(this, {"Completed sequence '", get_full_name(), "'"});
   endtask : post_body

endclass : cnn_din_base_seq

`endif