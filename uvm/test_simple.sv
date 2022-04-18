`ifndef TEST_SIMPLE_SV
`define TEST_SIMPLE_SV

class test_simple extends test_base;

   `uvm_component_utils(test_simple)

   cnn_din_simple_seq din_simple_seq;
   cnn_dout_simple_seq dout_simple_seq;

   function new(string name = "test_simple", uvm_component parent = null);
      super.new(name,parent);
   endfunction : new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      din_simple_seq = cnn_din_simple_seq::type_id::create("din_simple_seq");
      dout_simple_seq = cnn_dout_simple_seq::type_id::create("dout_simple_seq");
   endfunction : build_phase

   task main_phase(uvm_phase phase);
      phase.raise_objection(this);
      din_simple_seq.start(env.din_agent.seqr);
      dout_simple_seq.start(env.dout_agent.seqr);
      phase.drop_objection(this);
   endtask : main_phase

endclass

`endif