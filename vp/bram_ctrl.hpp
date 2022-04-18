#ifndef BRAM_CTRL_HPP_
#define BRAM_CTRL_HPP_

#include <systemc>
#include <tlm>
#include <tlm_utils/simple_target_socket.h>
#include <tlm_utils/simple_initiator_socket.h>
#include "typedefs.hpp"

class BramCtrl: public sc_core::sc_module{
public:
    BramCtrl (sc_core::sc_module_name name);
    ~BramCtrl ();

    tlm_utils::simple_target_socket<BramCtrl> sfso;//software socket
    tlm_utils::simple_initiator_socket<BramCtrl> i0so, i1so, i2so, i3so, i4so, i5so, i6so, i7so, i8so, i9so, iaso, ibso, icso, idso, ieso, ifso;
    tlm_utils::simple_initiator_socket<BramCtrl> coso, d0so, d1so, d2so, d3so, d4so, d5so, d6so, d7so, d8so, d9so;

protected:
    void b_transport (pl_t &, sc_core::sc_time &);
    pl_t pl_pt;
};

#endif // BRAM_CTRL_HPP_
