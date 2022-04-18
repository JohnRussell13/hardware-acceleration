`ifndef CNN_DOUT_SEQ_ITEM_SV
`define CNN_DOUT_SEQ_ITEM_SV

parameter DATA_WIDTH = 32;

class cnn_dout_seq_item extends uvm_sequence_item;

   // REFMOD!
   rand bit [DATA_WIDTH - 1 : 0]  r_0;
   rand bit [DATA_WIDTH - 1 : 0]  r_1;
   rand bit [DATA_WIDTH - 1 : 0]  r_2;
   rand bit [DATA_WIDTH - 1 : 0]  r_3;
   rand bit [DATA_WIDTH - 1 : 0]  r_4;
   rand bit [DATA_WIDTH - 1 : 0]  r_5;
   rand bit [DATA_WIDTH - 1 : 0]  r_6;
   rand bit [DATA_WIDTH - 1 : 0]  r_7;
   rand bit [DATA_WIDTH - 1 : 0]  r_8;
   rand bit [DATA_WIDTH - 1 : 0]  r_9;
   // REFMOD!
   //constraint img_val_data_constraint { img_val < 524287; } //19-bit val

   `uvm_object_utils_begin(cnn_dout_seq_item) // REFMOD!
      `uvm_field_int(r_0, UVM_DEFAULT)
      `uvm_field_int(r_1, UVM_DEFAULT)
      `uvm_field_int(r_2, UVM_DEFAULT)
      `uvm_field_int(r_3, UVM_DEFAULT)
      `uvm_field_int(r_4, UVM_DEFAULT)
      `uvm_field_int(r_5, UVM_DEFAULT)
      `uvm_field_int(r_6, UVM_DEFAULT)
      `uvm_field_int(r_7, UVM_DEFAULT)
      `uvm_field_int(r_8, UVM_DEFAULT)
      `uvm_field_int(r_9, UVM_DEFAULT)
   `uvm_object_utils_end

   function new (string name = "cnn_dout_seq_item");
      super.new(name);
   endfunction // new

endclass : cnn_dout_seq_item

`endif