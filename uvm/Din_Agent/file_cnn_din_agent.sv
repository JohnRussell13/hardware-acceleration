`ifndef CNN_DIN_AGENT_SV
`define CNN_DIN_AGENT_SV

class cnn_din_agent extends uvm_agent;

   // components
   cnn_din_driver drv;
   cnn_din_sequencer seqr;
   cnn_din_monitor mon;
   virtual interface cnn_if vif;
   // configuration
   cnn_config cfg;
   int value;   
   `uvm_component_utils_begin (cnn_din_agent)
      `uvm_field_object(cfg, UVM_DEFAULT)
   `uvm_component_utils_end

   function new(string name = "cnn_din_agent", uvm_component parent = null);
      super.new(name,parent);
   endfunction

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      /************Geting from configuration database*******************/
      if (!uvm_config_db#(virtual cnn_if)::get(this, "", "cnn_if", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set:",get_full_name(),".vif"})
      
      if(!uvm_config_db#(cnn_config)::get(this, "", "cnn_config", cfg))
        `uvm_fatal("NOCONFIG",{"Config object must be set for: ",get_full_name(),".cfg"})
      /*****************************************************************/
      
      /************Setting to configuration database********************/
            uvm_config_db#(virtual cnn_if)::set(this, "*", "cnn_if", vif);
      /*****************************************************************/
      
      mon = cnn_din_monitor::type_id::create("mon", this);
      if(1) begin//if(cfg.din_active == UVM_ACTIVE) begin
         drv = cnn_din_driver::type_id::create("drv", this);
         seqr = cnn_din_sequencer::type_id::create("seqr", this);
      end
   endfunction : build_phase

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      if(1) begin//if(cfg.din_active == UVM_ACTIVE) begin
         drv.seq_item_port.connect(seqr.seq_item_export);
      end
   endfunction : connect_phase

endclass : cnn_din_agent

`endif