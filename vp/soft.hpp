#ifndef SOFT_HPP_
#define SOFT_HPP_

#include <iostream>
#include <fstream>
#include <systemc>
#include <tlm_utils/simple_initiator_socket.h>
#include "typedefs.hpp"
#include "utils.hpp"

class Soft : public sc_core::sc_module{
public:
    Soft(sc_core::sc_module_name name, char *txt);
    ~Soft();

    tlm_utils::simple_initiator_socket<Soft> icso;//initiator socket
protected:
    void pass();//main software function
    std::ifstream image;//file input

    pl_t pl;//payload
    sc_core::sc_time offset;//time

    num_t read_bram(sc_dt::uint64 addr, unsigned char type);//read from bram
    void write_bram(sc_dt::uint64 addr, num_t val, unsigned char type);//write in bram

    num_t read_hard(sc_dt::uint64 addr);//read from hardware
    void write_hard(sc_dt::uint64 addr, int val);//write in hardware
};

#endif // SOFT_HPP_
