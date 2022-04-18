#ifndef INTERCONNECT_HPP_
#define INTERCONNECT_HPP_

#include <systemc>
#include <tlm_utils/simple_initiator_socket.h>
#include <tlm_utils/simple_target_socket.h>
#include "typedefs.hpp"
#include "utils.hpp"

class Interconnect : public sc_core::sc_module{
public:
    Interconnect(sc_core::sc_module_name name);
    ~Interconnect();

    tlm_utils::simple_initiator_socket<Interconnect> brso;//bram socket
    tlm_utils::simple_initiator_socket<Interconnect> hrso;//hardware socket
    tlm_utils::simple_target_socket<Interconnect> sfso;//software socket
protected:
    pl_t pl;//payload
    sc_core::sc_time offset;//time
    void b_transport(pl_t &pl, sc_core::sc_time &offset);//transport function
};

#endif // INTERCONNECT_HPP_
