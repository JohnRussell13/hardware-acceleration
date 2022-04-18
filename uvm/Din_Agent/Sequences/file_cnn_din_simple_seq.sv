`ifndef CNN_DIN_SIMPLE_SEQ_SV
`define CNN_DIN_SIMPLE_SEQ_SV

class cnn_din_simple_seq extends cnn_din_base_seq;

   `uvm_object_utils (cnn_din_simple_seq)

   function new(string name = "cnn_din_simple_seq");
      super.new(name);
   endfunction

   virtual task body();
      // simple seq - just send a picture
      for (int i = 0; i < 28*28; i++) begin
         `uvm_do(req);
      end
   endtask : body

endclass : cnn_din_simple_seq

`endif