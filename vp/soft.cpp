#include "soft.hpp"

SC_HAS_PROCESS(Soft);

Soft::Soft(sc_core::sc_module_name name, char *txt): sc_module(name){
    image.open(txt);//open file
    if(!image.is_open()){//check if file is ok
        SC_REPORT_ERROR("Soft", "Cannot open file.");//error
    }

    SC_THREAD(pass);//set function convolve() as thread
    SC_REPORT_INFO("Soft", "Constructed.");//message
}

Soft::~Soft(){
    image.close();//close file
    SC_REPORT_INFO("Soft", "Destructed.");//message
}

void Soft::pass(){
    double temp;
    unsigned char a, b;
    unsigned char p[16] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    
    delay += sc_core::sc_time(50*9.5, sc_core::SC_NS);
    
    for (int i = 0; i < IMG_SIZE; ++i){//write matrix A into bram
        for (int j = 0; j < IMG_SIZE; ++j){
            image >> temp;//read from file
            temp = temp / (1 << CHAR_LEN);//scaling
            delay += sc_core::sc_time(9.5, sc_core::SC_NS);
            a = i & 1;
            b = j & 1;
            if(a == 0){
                if(b == 0){
                    if(i != IMG_SIZE - 2 && j != IMG_SIZE - 2){
                        write_bram(p[0]++, (num_t) temp, 0);//write into bram
                    }
                   
                    if(i != IMG_SIZE - 2 && j != 0){
                        write_bram(p[2]++, (num_t) temp, 2);//write into bram
                    }
                 
                    if(i != 0 && j != IMG_SIZE - 2){
                        write_bram(p[8]++, (num_t) temp, 8);//write into bram
                    }  
                    if(i != 0 && j != 0){
                        write_bram(p[10]++, (num_t) temp, 10);//write into bram
                    }
                }
                else{
                    if(i != IMG_SIZE - 2 && j != IMG_SIZE - 1){
                        write_bram(p[1]++, (num_t) temp, 1);//write into bram
                    }
                    
                    if(i != 0 && j != IMG_SIZE - 1){
                        write_bram(p[9]++, (num_t) temp, 9);//write into bram
                    }
                    
                    if(i != IMG_SIZE - 2 && j != 1){
                        write_bram(p[3]++, (num_t) temp, 3);//write into bram
                    }
                    
                    if(i != 0 && j != 1){
                        write_bram(p[11]++, (num_t) temp, 11);//write into bram
                    }
                }
            }
            else{
                if(b == 0){
                    if(i != IMG_SIZE - 1 && j != IMG_SIZE - 2){
                        write_bram(p[4]++, (num_t) temp, 4);//write into bram
                    }
                    if(i != 1 && j != IMG_SIZE - 2){
                        write_bram(p[12]++, (num_t) temp, 12);//write into bram
                    }
                    if(i != IMG_SIZE - 1 && j != 0){
                        write_bram(p[6]++, (num_t) temp, 6);//write into bram
                    }
                    if(i != 1 && j != 0){
                        write_bram(p[14]++, (num_t) temp, 14);//write into bram
                    }
                }
                else{
                    if(i != IMG_SIZE - 1 && j != IMG_SIZE - 1){
                        write_bram(p[5]++, (num_t) temp, 5);//write into bram
                    }
                    
                    if(i != 1 && j != IMG_SIZE - 1){
                        write_bram(p[13]++, (num_t) temp, 13);//write into bram
                    }
                    
                    if(i != IMG_SIZE - 1 && j != 1){
                        write_bram(p[7]++, (num_t) temp, 7);//write into bram
                    }
                    if(i != 1 && j != 1){
                        write_bram(p[15]++, (num_t) temp, 15);//write into bram
                    }
                }
            }
        }
    }

    write_hard(ADDR_INIT, 1);//start hardware

    while(read_hard(ADDR_STATUS_INIT) == 0){//wait for hardware to finish - pooling
        delay += sc_core::sc_time(1, sc_core::SC_NS);//increment time
    }

    write_hard(ADDR_CMD, 1);//start hardware

    while(read_hard(ADDR_STATUS) == 0){//wait for hardware to finish - pooling
        delay += sc_core::sc_time(1, sc_core::SC_NS);//increment time
   }
    std::cout << std::endl << "Writing finished." << std::endl;//message

    std::vector<num_t> read;
    delay += sc_core::sc_time(9.5*50, sc_core::SC_NS);
    for (int i = 0; i < OUT_SIZE; ++i){
        read.push_back( read_hard(ADDR_RES + i) );//read result
       
        delay += sc_core::sc_time(9.5, sc_core::SC_NS);
    }
    string msg = "Image showed: ";//set message
    switch(std::distance(read.begin(), std::max_element(read.begin(), read.end()) )){//check most probable result and set message
        case 0:
            msg += "T-shirt/top";
            break;
        case 1:
            msg += "Trousers";
            break;
        case 2:
            msg += "Pullover";
            break;
        case 3:
            msg += "Dress";
            break;
        case 4:
            msg += "Coat";
            break;
        case 5:
            msg += "Sandal";
            break;
        case 6:
            msg += "Shirt";
            break;
        case 7:
            msg += "Sneaker";
            break;
        case 8:
            msg += "Bag";
            break;
        case 9:
            msg += "Ankle boot";
            break;
        default:
            msg += "NaN";
            break;
    }
    std::cout << std::endl << msg << endl <<"Image:"; //print message
    printv(read, 10);

    int time_delay;
    double t;
    sscanf(delay.to_string().c_str(), "%d ns ", &time_delay);
    t = 1000.0*2.25*counter/time_delay;
    std::cout << "Throughput: " << t << "MB/s" << endl;

}
num_t Soft::read_bram(sc_dt::uint64 addr, unsigned char type){
    pl_t pl;//payload
    unsigned char buf[BUFF_SIZE];//buffer that converts num_t into unsigned char for interconnect

    sc_dt::uint64 taddr = (addr*BUFF_SIZE) | VP_ADDR_BRAM_BASE;

    switch(type){
        case 0:
            taddr |= VP_ADDR_IMG0_BASE;
            break;
        case 1:
            taddr |= VP_ADDR_IMG1_BASE;
            break;
        case 2:
            taddr |= VP_ADDR_IMG2_BASE;
            break;
        case 3:
            taddr |= VP_ADDR_IMG3_BASE;
            break;
        case 4:
            taddr |= VP_ADDR_IMG4_BASE;
            break;
        case 5:
            taddr |= VP_ADDR_IMG5_BASE;
            break;
        case 6:
            taddr |= VP_ADDR_IMG6_BASE;
            break;
        case 7:
            taddr |= VP_ADDR_IMG7_BASE;
            break;
        case 8:
            taddr |= VP_ADDR_IMG8_BASE;
            break;
        case 9:
            taddr |= VP_ADDR_IMG9_BASE;
            break;
        case 10:
            taddr |= VP_ADDR_IMGA_BASE;
            break;
        case 11:
            taddr |= VP_ADDR_IMGB_BASE;
            break;
        case 12:
            taddr |= VP_ADDR_IMGC_BASE;
            break;
        case 13:
            taddr |= VP_ADDR_IMGD_BASE;
            break;
        case 14:
            taddr |= VP_ADDR_IMGE_BASE;
            break;
        case 15:
            taddr |= VP_ADDR_IMGF_BASE;
            break;
        default://error
            break;
    }

    pl.set_address(taddr);

    pl.set_data_length(BUFF_SIZE);//set lengths of buf
    pl.set_data_ptr(buf);//set buf as pointer for transport
    pl.set_command( tlm::TLM_READ_COMMAND );//set command for reading
    pl.set_response_status ( tlm::TLM_INCOMPLETE_RESPONSE );//set response
    icso->b_transport(pl, offset);//transport

    return to_fixed(buf);//convert unsigned char into num_t
}

void Soft::write_bram(sc_dt::uint64 addr, num_t val, unsigned char type){
    pl_t pl;//payload
    unsigned char buf[BUFF_SIZE];//buffer that converts num_t into unsigned char for interconnect
    to_uchar(buf, val);//convert real part to unsigned char
    sc_dt::uint64 taddr = (addr*BUFF_SIZE) | VP_ADDR_BRAM_BASE;

    switch(type){
        case 0:
            taddr |= VP_ADDR_IMG0_BASE;
            break;
        case 1:
            taddr |= VP_ADDR_IMG1_BASE;
            break;
        case 2:
            taddr |= VP_ADDR_IMG2_BASE;
            break;
        case 3:
            taddr |= VP_ADDR_IMG3_BASE;
            break;
        case 4:
            taddr |= VP_ADDR_IMG4_BASE;
            break;
        case 5:
            taddr |= VP_ADDR_IMG5_BASE;
            break;
        case 6:
            taddr |= VP_ADDR_IMG6_BASE;
            break;
        case 7:
            taddr |= VP_ADDR_IMG7_BASE;
            break;
        case 8:
            taddr |= VP_ADDR_IMG8_BASE;
            break;
        case 9:
            taddr |= VP_ADDR_IMG9_BASE;
            break;
        case 10:
            taddr |= VP_ADDR_IMGA_BASE;
            break;
        case 11:
            taddr |= VP_ADDR_IMGB_BASE;
            break;
        case 12:
            taddr |= VP_ADDR_IMGC_BASE;
            break;
        case 13:
            taddr |= VP_ADDR_IMGD_BASE;
            break;
        case 14:
            taddr |= VP_ADDR_IMGE_BASE;
            break;
        case 15:
            taddr |= VP_ADDR_IMGF_BASE;
            break;
        default://error
            break;
    }

    pl.set_address(taddr);
    pl.set_data_length(BUFF_SIZE);//set lengths of buf
    pl.set_data_ptr(buf);//set buf as pointer for transport
    pl.set_command( tlm::TLM_WRITE_COMMAND );//set command for writing
    pl.set_response_status ( tlm::TLM_INCOMPLETE_RESPONSE );//set response
    icso->b_transport(pl, offset);//transport
}

num_t Soft::read_hard(sc_dt::uint64 addr){
    pl_t pl;//payload
    unsigned char buf[BUFF_SIZE];//buffer that converts num_t into unsigned char for interconnect
    pl.set_address(addr | VP_ADDR_HARD_BASE);//set address: local + global
    pl.set_data_length(BUFF_SIZE);//set lengths of buf
    pl.set_data_ptr(buf);//set buf as pointer for transport
    pl.set_command( tlm::TLM_READ_COMMAND );//set command for reading
    pl.set_response_status ( tlm::TLM_INCOMPLETE_RESPONSE );//set response
    sc_core::sc_time offset = sc_core::SC_ZERO_TIME;//TIME ???
    icso->b_transport(pl, offset);//transport

    return to_fixed(buf);
}

void Soft::write_hard(sc_dt::uint64 addr, int val){
    pl_t pl;//payload
    unsigned char buf[BUFF_SIZE];//buffer that converts num_t into unsigned char for interconnect
    to_uchar (buf, val);//convert value to unsigned char
    pl.set_address(addr | VP_ADDR_HARD_BASE);//set address: local + global
    pl.set_data_length(BUFF_SIZE);//set lengths of buf
    pl.set_data_ptr(buf);//set buf as pointer for transport
    pl.set_command( tlm::TLM_WRITE_COMMAND );//set command for writing
    pl.set_response_status ( tlm::TLM_INCOMPLETE_RESPONSE );//set response
    icso->b_transport(pl, offset);//transport
}
