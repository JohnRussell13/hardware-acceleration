`ifndef CNN_DOUT_SIMPLE_SEQ_SV
`define CNN_DOUT_SIMPLE_SEQ_SV

class cnn_dout_simple_seq extends cnn_dout_base_seq;

   `uvm_object_utils (cnn_dout_simple_seq)

   function new(string name = "cnn_dout_simple_seq");
      super.new(name);
   endfunction

   virtual task body();
      // simple seq - just ask for res
      `uvm_do(req);
   endtask : body

endclass : cnn_dout_simple_seq

`endif