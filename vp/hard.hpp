#ifndef HARD_HPP_
#define HARD_HPP_

#include <systemc>
#include <iostream>
#include <fstream>
#include <math.h>
#include <tlm_utils/simple_initiator_socket.h>
#include <tlm_utils/simple_target_socket.h>
#include "typedefs.hpp"
#include "utils.hpp"

class Hard : public sc_core::sc_module{
public:
    Hard(sc_core::sc_module_name name, char* txt);
    ~Hard();

    tlm_utils::simple_initiator_socket<Hard> i0so, i1so, i2so, i3so, i4so, i5so, i6so, i7so, i8so, i9so, iaso, ibso, icso, idso, ieso, ifso;
    tlm_utils::simple_initiator_socket<Hard> coso, d0so, d1so, d2so, d3so, d4so, d5so, d6so, d7so, d8so, d9so;
    tlm_utils::simple_target_socket<Hard> sfso;
protected:
    pl_t pl;
    sc_core::sc_time offset;

    std::ifstream weights;//file input

    num_t image[4][4];
	num_t conv_ker[9];
	num_t conv_res[4];
	num_t pool_res;
	num_t result[OUT_SIZE];

    void network();
    num_t start, done;
    num_t start_i, done_i;
    void b_transport(pl_t &pl, sc_core::sc_time &offset);
    num_t read_bram(int addr, unsigned char type);
    void write_bram(int addr, num_t val, unsigned char type);
    void init_bram();
};

#endif // HARD_HPP_
