`ifndef CNN_DIN_SEQ_ITEM_SV
`define CNN_DIN_SEQ_ITEM_SV

parameter DATA_WIDTH = 32;

class cnn_din_seq_item extends uvm_sequence_item;

   // REFMOD!
   rand bit [DATA_WIDTH - 1 : 0]  img_val;
   int pos;
   // REFMOD!
   constraint img_val_data_constraint { img_val < 2047; } //19-bit val = 524287 or 11-bit val for scaled = 2047

   `uvm_object_utils_begin(cnn_din_seq_item) // REFMOD!
      `uvm_field_int(img_val, UVM_DEFAULT)
   `uvm_object_utils_end

   function new (string name = "cnn_din_seq_item");
      super.new(name);
   endfunction // new

endclass : cnn_din_seq_item

`endif