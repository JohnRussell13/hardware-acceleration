`ifndef CNN_ENV_SV
`define CNN_ENV_SV

`include "file_cnn_scoreboard.sv"   

class cnn_env extends uvm_env;

   cnn_din_agent din_agent;
   cnn_dout_agent dout_agent;
   cnn_scoreboard sb;
   cnn_config cfg;
   virtual interface cnn_if vif;
   `uvm_component_utils (cnn_env)

   function new(string name = "cnn_env", uvm_component parent = null);
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
      uvm_config_db#(cnn_config)::set(this, "din_agent", "cnn_config", cfg);
      uvm_config_db#(virtual cnn_if)::set(this, "din_agent", "cnn_if", vif);
       
      uvm_config_db#(cnn_config)::set(this, "sb", "cnn_config", cfg);
      uvm_config_db#(virtual cnn_if)::set(this, "cnn_scoreboard", "cnn_if", vif);

      uvm_config_db#(cnn_config)::set(this, "dout_agent", "cnn_config", cfg);
      uvm_config_db#(virtual cnn_if)::set(this, "dout_agent", "cnn_if", vif);
      /*****************************************************************/
      din_agent = cnn_din_agent::type_id::create("din_agent", this);
      dout_agent = cnn_dout_agent::type_id::create("dout_agent", this);
      sb = cnn_scoreboard::type_id::create("cnn_scoreboard", this);
      
   endfunction : build_phase
   
   function void connect_phase(uvm_phase phase);
       super.connect_phase(phase);
       din_agent.mon.item_collected_port_input.connect(sb.port_input);
       dout_agent.mon.item_collected_port_output.connect(sb.port_output);
   endfunction : connect_phase

endclass : cnn_env

`endif