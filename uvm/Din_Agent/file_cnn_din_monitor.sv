`ifndef CNN_DIN_MONITOR_SV
`define CNN_DIN_MONITOR_SV

class cnn_din_monitor extends uvm_monitor;

   // control fileds
   bit checks_enable = 1;
   bit coverage_enable = 1;

   uvm_analysis_port #(cnn_din_seq_item) item_collected_port_input;
   
   //typedef enum {wait_for_img, wait_for_resp} monitoring_stages;
   //monitoring_stages cnn_din_monitoring_stages = wait_for_img;
    
   `uvm_component_utils_begin(cnn_din_monitor)
      `uvm_field_int(checks_enable, UVM_DEFAULT)
      `uvm_field_int(coverage_enable, UVM_DEFAULT)
   `uvm_component_utils_end

   // The virtual interface used to drive and view HDL signals.
   virtual interface cnn_if vif;

   // current transaction
   cnn_din_seq_item curr_it;

   // coverage can go here
   covergroup img_check;       
      option.per_instance = 1;
      inp: coverpoint vif.dina {
	      bins sml = {[0:127]};
	      bins big = {[128:255]};
      }
   endgroup

   function new(string name = "cnn_din_monitor", uvm_component parent = null);
      super.new(name,parent);      
      item_collected_port_input = new("item_collected_port_input", this);
      img_check = new();
   endfunction

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      if (!uvm_config_db#(virtual cnn_if)::get(this, "", "cnn_if", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set:",get_full_name(),".vif"})
   endfunction : connect_phase

   logic [31 : 0] flag = 2048; //so it won't block if on the first lap
   int temp;

   function int check_pos(logic [2*DATA_WIDTH - 1 : 0]  wea);
      temp = 0;
      while(1) begin
         wea = wea >> 1;
         if(wea == 0) break;
         temp++;
      end
      return temp;
   endfunction

   task main_phase(uvm_phase phase);
      `uvm_info(get_type_name(), "Started monitoring din\n", UVM_LOW);
      forever begin
         curr_it = cnn_din_seq_item::type_id::create("curr_it", this);
         @(posedge vif.clk);
         if (vif.wea < 2**16) begin //sending IMG pixel
            curr_it.img_val = vif.dina;
            curr_it.pos = check_pos(vif.wea);
            item_collected_port_input.write(curr_it); // send to scoreboard
            img_check.sample();
            flag = vif.dina;
         end
      end
   endtask : main_phase

endclass : cnn_din_monitor

`endif