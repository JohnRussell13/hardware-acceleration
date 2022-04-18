#include "bram_ctrl.hpp"

BramCtrl::BramCtrl(sc_core::sc_module_name name) : sc_module(name)
{
  sfso.register_b_transport(this, &BramCtrl::b_transport);
  SC_REPORT_INFO("BRAM Controller", "Constructed.");
}

BramCtrl::~BramCtrl()
{
  SC_REPORT_INFO("BRAM Controller", "Destructed.");
}

void BramCtrl::b_transport(pl_t &pl, sc_core::sc_time &offset)
{
    tlm::tlm_command cmd = pl.get_command();//get payload command
    sc_dt::uint64 addr = pl.get_address();//get payload address
    sc_dt::uint64 taddr = addr & 0x000FFFFF;//mask to get local address
    unsigned int len = pl.get_data_length();//get data length
    unsigned char *buf = pl.get_data_ptr();//get payload data

    pl_pt.set_command(cmd);//set payload command
    pl_pt.set_data_length(len);//set payload length
    pl_pt.set_data_ptr(buf);//set payload data
    pl_pt.set_response_status( tlm::TLM_INCOMPLETE_RESPONSE );

	if(addr >= VP_ADDR_IMG0_L && addr <= VP_ADDR_IMG0_H){//transport for first image
        pl_pt.set_address(taddr & 0x00000FFF);//set local address
        i0so->b_transport(pl_pt, offset);//transport
    }
    else if(addr >= VP_ADDR_IMG1_L && addr <= VP_ADDR_IMG1_H){//transport for second image
        pl_pt.set_address(taddr & 0x00000FFF);//set local address
        i1so->b_transport(pl_pt, offset);//transport
    }
    else if(addr >= VP_ADDR_IMG2_L && addr <= VP_ADDR_IMG2_H){//transport for second image
        pl_pt.set_address(taddr & 0x00000FFF);//set local address
        i2so->b_transport(pl_pt, offset);//transport
    }
    else if(addr >= VP_ADDR_IMG3_L && addr <= VP_ADDR_IMG3_H){//transport for second image
        pl_pt.set_address(taddr & 0x00000FFF);//set local address
        i3so->b_transport(pl_pt, offset);//transport
    }
    else if(addr >= VP_ADDR_IMG4_L && addr <= VP_ADDR_IMG4_H){//transport for second image
        pl_pt.set_address(taddr & 0x00000FFF);//set local address
        i4so->b_transport(pl_pt, offset);//transport
    }
    else if(addr >= VP_ADDR_IMG5_L && addr <= VP_ADDR_IMG5_H){//transport for second image
        pl_pt.set_address(taddr & 0x00000FFF);//set local address
        i5so->b_transport(pl_pt, offset);//transport
    }
    else if(addr >= VP_ADDR_IMG6_L && addr <= VP_ADDR_IMG6_H){//transport for second image
        pl_pt.set_address(taddr & 0x00000FFF);//set local address
        i6so->b_transport(pl_pt, offset);//transport
    }
    else if(addr >= VP_ADDR_IMG7_L && addr <= VP_ADDR_IMG7_H){//transport for second image
        pl_pt.set_address(taddr & 0x00000FFF);//set local address
        i7so->b_transport(pl_pt, offset);//transport
    }
    else if(addr >= VP_ADDR_IMG8_L && addr <= VP_ADDR_IMG8_H){//transport for second image
        pl_pt.set_address(taddr & 0x00000FFF);//set local address
        i8so->b_transport(pl_pt, offset);//transport
    }
    else if(addr >= VP_ADDR_IMG9_L && addr <= VP_ADDR_IMG9_H){//transport for second image
        pl_pt.set_address(taddr & 0x00000FFF);//set local address
        i9so->b_transport(pl_pt, offset);//transport
    }
    else if(addr >= VP_ADDR_IMGA_L && addr <= VP_ADDR_IMGA_H){//transport for second image
        pl_pt.set_address(taddr & 0x00000FFF);//set local address
        iaso->b_transport(pl_pt, offset);//transport
    }
    else if(addr >= VP_ADDR_IMGB_L && addr <= VP_ADDR_IMGB_H){//transport for second image
        pl_pt.set_address(taddr & 0x00000FFF);//set local address
        ibso->b_transport(pl_pt, offset);//transport
    }
    else if(addr >= VP_ADDR_IMGC_L && addr <= VP_ADDR_IMGC_H){//transport for second image
        pl_pt.set_address(taddr & 0x00000FFF);//set local address
        icso->b_transport(pl_pt, offset);//transport
    }
    else if(addr >= VP_ADDR_IMGD_L && addr <= VP_ADDR_IMGD_H){//transport for second image
        pl_pt.set_address(taddr & 0x00000FFF);//set local address
        idso->b_transport(pl_pt, offset);//transport
    }
    else if(addr >= VP_ADDR_IMGE_L && addr <= VP_ADDR_IMGE_H){//transport for second image
        pl_pt.set_address(taddr & 0x00000FFF);//set local address
        ieso->b_transport(pl_pt, offset);//transport
    }
    else if(addr >= VP_ADDR_IMGF_L && addr <= VP_ADDR_IMGF_H){//transport for second image
        pl_pt.set_address(taddr & 0x00000FFF);//set local address
        ifso->b_transport(pl_pt, offset);//transport
    }
    else if(addr >= VP_ADDR_CONV_L && addr <= VP_ADDR_CONV_H){//transport for convolution
        pl_pt.set_address(taddr);//set local address
        coso->b_transport(pl_pt, offset);//transport
    }
    else if(addr >= VP_ADDR_DEN0_L && addr <= VP_ADDR_DEN0_H){//transport for first dense
        pl_pt.set_address(taddr);//set local address
        d0so->b_transport(pl_pt, offset);//transport
    }
    else if(addr >= VP_ADDR_DEN1_L && addr <= VP_ADDR_DEN1_H){//transport for second dense
        pl_pt.set_address(taddr);//set local address
        d1so->b_transport(pl_pt, offset);//transport
    }
    else if(addr >= VP_ADDR_DEN2_L && addr <= VP_ADDR_DEN2_H){//transport for third dense
        pl_pt.set_address(taddr);//set local address
        d2so->b_transport(pl_pt, offset);//transport
    }
    else if(addr >= VP_ADDR_DEN3_L && addr <= VP_ADDR_DEN3_H){//transport for fourth dense
        pl_pt.set_address(taddr);//set local address
        d3so->b_transport(pl_pt, offset);//transport
    }
    else if(addr >= VP_ADDR_DEN4_L && addr <= VP_ADDR_DEN4_H){//transport for fifth dense
        pl_pt.set_address(taddr);//set local address
        d4so->b_transport(pl_pt, offset);//transport
    }
    else if(addr >= VP_ADDR_DEN5_L && addr <= VP_ADDR_DEN5_H){//transport for fifth dense
        pl_pt.set_address(taddr);//set local address
        d5so->b_transport(pl_pt, offset);//transport
    }
    else if(addr >= VP_ADDR_DEN6_L && addr <= VP_ADDR_DEN6_H){//transport for fifth dense
        pl_pt.set_address(taddr);//set local address
        d6so->b_transport(pl_pt, offset);//transport
    }
    else if(addr >= VP_ADDR_DEN7_L && addr <= VP_ADDR_DEN7_H){//transport for fifth dense
        pl_pt.set_address(taddr);//set local address
        d7so->b_transport(pl_pt, offset);//transport
    }
    else if(addr >= VP_ADDR_DEN8_L && addr <= VP_ADDR_DEN8_H){//transport for fifth dense
        pl_pt.set_address(taddr);//set local address
        d8so->b_transport(pl_pt, offset);//transport
    }
    else if(addr >= VP_ADDR_DEN9_L && addr <= VP_ADDR_DEN9_H){//transport for fifth dense
        pl_pt.set_address(taddr);//set local address
        d9so->b_transport(pl_pt, offset);//transport
    }
	else{//error
        SC_REPORT_ERROR("Interconnect", "Wrong address.");
        pl_pt.set_response_status ( tlm::TLM_ADDRESS_ERROR_RESPONSE );
    }
}
