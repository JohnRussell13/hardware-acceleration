`ifndef CNN_DOUT_DRIVER_SV
`define CNN_DOUT_DRIVER_SV

class cnn_dout_driver extends uvm_driver#(cnn_dout_seq_item);

   `uvm_component_utils(cnn_dout_driver)
   
   virtual interface cnn_if vif;

   function new(string name = "cnn_dout_driver", uvm_component parent = null);
      super.new(name,parent);
      if (!uvm_config_db#(virtual cnn_if)::get(this, "", "cnn_if", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set:",get_full_name(),".vif"})
   endfunction

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      if (!uvm_config_db#(virtual cnn_if)::get(this, "", "cnn_if", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
   endfunction : connect_phase
   
   task main_phase(uvm_phase phase);
      forever begin
         @(posedge vif.clk);
         if(vif.ready == 1) begin
            seq_item_port.get_next_item(req);
            `uvm_info(get_type_name(), $sformatf("Driver sendout...\n%s", req.sprint()), UVM_HIGH)
            seq_item_port.item_done();
         end
      end
   endtask : main_phase

endclass : cnn_dout_driver

`endif