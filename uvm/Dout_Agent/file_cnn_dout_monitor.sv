`ifndef CNN_DOUT_MONITOR_SV
`define CNN_DOUT_MONITOR_SV

class cnn_dout_monitor extends uvm_monitor;

   // control fileds
   bit checks_enable = 1;
   bit coverage_enable = 1;

   uvm_analysis_port #(cnn_dout_seq_item) item_collected_port_output;
   
   //typedef enum {wait_for_img, wait_for_resp} monitoring_stages;
   //monitoring_stages cnn_dout_monitoring_stages = wait_for_img;
    
   `uvm_component_utils_begin(cnn_dout_monitor)
      `uvm_field_int(checks_enable, UVM_DEFAULT)
      `uvm_field_int(coverage_enable, UVM_DEFAULT)
   `uvm_component_utils_end

   // The virtual interface used to drive and view HDL signals.
   virtual interface cnn_if vif;

   // current transaction
   cnn_dout_seq_item curr_it;

   // coverage can go here
   covergroup res_check;       
      option.per_instance = 1;
      res: coverpoint vif.r_0 {
	      bins sml = {[32'b00000000000000000000000000000000:32'b10000000000000000000000000000000]};
	      bins big = {[32'b10000000000000000000000000000001:32'b11111111111111111111111111111111]};
      }
   endgroup

   function new(string name = "cnn_dout_monitor", uvm_component parent = null);
      super.new(name,parent);      
      item_collected_port_output = new("item_collected_port_output", this);
      res_check = new();
   endfunction

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      if (!uvm_config_db#(virtual cnn_if)::get(this, "", "cnn_if", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set:",get_full_name(),".vif"})
   endfunction : connect_phase

   int counter = 0;
   //int fp;
   //string output_path = "../data/output.txt";

   task main_phase(uvm_phase phase);
      `uvm_info(get_type_name(), "Started monitoring dout\n", UVM_LOW);

      //fp = $fopen(output_path,"w");
      //if (fp) begin
      //    `uvm_info(get_type_name(), $sformatf("File opened successfuly: %d\n", fp), UVM_LOW)
      //end
      //else begin 
      //    `uvm_info(get_type_name(), $sformatf("Failed to open file: %d\n", fp), UVM_LOW)
      //end

      forever begin
         @(posedge vif.clk);
         if (vif.ready == 1 && counter == 0) begin
            curr_it = cnn_dout_seq_item::type_id::create("curr_it", this);
            curr_it.r_0 = vif.r_0;
            curr_it.r_1 = vif.r_1;
            curr_it.r_2 = vif.r_2;
            curr_it.r_3 = vif.r_3;
            curr_it.r_4 = vif.r_4;
            curr_it.r_5 = vif.r_5;
            curr_it.r_6 = vif.r_6;
            curr_it.r_7 = vif.r_7;
            curr_it.r_8 = vif.r_8;
            curr_it.r_9 = vif.r_9;
            res_check.sample();
            item_collected_port_output.write(curr_it); // send to scoreboard
            //$fwrite(fp, "%d ", vif.r_0);
            //$fwrite(fp, "%d ", vif.r_1);
            //$fwrite(fp, "%d ", vif.r_2);
            //$fwrite(fp, "%d ", vif.r_3);
            //$fwrite(fp, "%d ", vif.r_4);
            //$fwrite(fp, "%d ", vif.r_5);
            //$fwrite(fp, "%d ", vif.r_6);
            //$fwrite(fp, "%d ", vif.r_7);
            //$fwrite(fp, "%d ", vif.r_8);
            //$fwrite(fp, "%d ", vif.r_9);
            //$fclose(fp);
            counter++;
            `uvm_info(get_type_name(), "Finished monitoring dout\n", UVM_LOW);
         end
      end
   endtask : main_phase

endclass : cnn_dout_monitor

`endif
