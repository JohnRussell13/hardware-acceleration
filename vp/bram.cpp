#include "bram.hpp"

Bram::Bram(sc_core::sc_module_name name): sc_module(name){
  bsoa.register_b_transport(this, &Bram::b_transport);
  bsob.register_b_transport(this, &Bram::b_transport);
  mem.reserve(MEM_SIZE);

  SC_REPORT_INFO("BRAM", "Constructed.");
}

Bram::~Bram(){
  SC_REPORT_INFO("BRAM", "Destructed.");
}

void Bram::b_transport(pl_t &pl, sc_core::sc_time &offset){
    tlm::tlm_command cmd = pl.get_command();//get payload command
    sc_dt::uint64 addr = pl.get_address();//get payload address
    unsigned int len = pl.get_data_length();//get payload length
    unsigned char *buf = pl.get_data_ptr();//get payload data

    if(cmd == tlm::TLM_WRITE_COMMAND){
        for(unsigned int i = 0; i < len; ++i){
            mem[addr++] = buf[i];//write into memory
        }
        pl.set_response_status( tlm::TLM_OK_RESPONSE );//message
    }
    else if(cmd == tlm::TLM_READ_COMMAND){
        for(unsigned int i = 0; i < len; ++i){
            buf[i] = mem[addr++];//read from memory
        }
        pl.set_response_status( tlm::TLM_OK_RESPONSE );//message
    }
    else{
        pl.set_response_status( tlm::TLM_COMMAND_ERROR_RESPONSE );//error
    }

    offset += sc_core::sc_time(10, sc_core::SC_NS);//increment time
}
