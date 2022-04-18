#include "hard.hpp"
Hard::Hard(sc_core::sc_module_name name, char *txt): sc_module(name), start(0), done(1), start_i(0), done_i(1){
    sfso.register_b_transport(this, &Hard::b_transport);

    weights.open(txt);//open file
    if(!weights.is_open()){//check if file is ok
        SC_REPORT_ERROR("Hard", "Cannot open file.");//error
    }
    SC_REPORT_INFO("Hard", "Constructed.");
}

Hard::~Hard(){
    SC_REPORT_INFO("Hard", "Destructed.");
}

void Hard::init_bram(){
   int c = 0;
   //init conv_weights
   num_t temp;
   for(int i = 0; i < NUM_CONV; i++){
        for(int j = 0; j < KER_SIZE; j++){
            for(int k = 0; k < KER_SIZE; k++){
                weights >> temp;//read from file
                write_bram(c++, temp, 16);
            }
        }
    }
   //init dense_weights
    for(int i = 0; i < NUM_CONV * (IMG_SIZE-(KER_SIZE-1))/2 * (IMG_SIZE-(KER_SIZE-1))/2; i++){
        for(int j = 0; j < OUT_SIZE; j++){
            weights >> temp;//read from file
            write_bram(i, temp, j+17);
        }
    }

    for(int k = 0; k < OUT_SIZE; k++){
        result[k] = 0;
    }

	done_i = 1;
}

void Hard::network(){
    num_t temp;

    num_t temp0 = 0;
    num_t temp1 = 0;
    int v = 0;
    //sections: 1 mult 5 add 1||2||3 comp 1 mult 1 add  
    delay += sc_core::sc_time(9.5*10, sc_core::SC_NS);
    for(int i = 0; i < NUM_CONV; i++){
        //set convolution kernel
        for(int j = 0; j < 9; j++){
            temp = read_bram(i*9 + j, 16);
		    conv_ker[j] = temp;
        }
        int c;
        //go through whole image
        for(int j = 0; j < (IMG_SIZE-2)/2*(IMG_SIZE-2)/2; j++){
            //read 16 pixels for convolution multiplications
            delay += sc_core::sc_time(9.5, sc_core::SC_NS);
            c = 0;
            for(int k = 0; k < 4; k++){
                for(int l = 0; l < 4; l++){
                    image[k][l] = read_bram(j, c++);
                }
            }
            //convolution multiplications
            c = 0;
            conv_res[0] = 0;
            for(int k = 0; k < 3; k++){
                for(int l = 0; l < 3; l++){
                    conv_res[0] += conv_ker[c++]*image[k][l];
                }
            }
            counter++;
            c = 0;
            conv_res[1] = 0;
            for(int k = 0; k < 3; k++){
                for(int l = 1; l < 4; l++){
                    conv_res[1] += conv_ker[c++]*image[k][l];
                }
            }
            counter++;
            c = 0;
            conv_res[2] = 0;
            for(int k = 1; k < 4; k++){
                for(int l = 0; l < 3; l++){
                    conv_res[2] += conv_ker[c++]*image[k][l];
                }
            }
            counter++;
            c = 0;
            conv_res[3] = 0;
            for(int k = 1; k < 4; k++){
                for(int l = 1; l < 4; l++){
                    conv_res[3] += conv_ker[c++]*image[k][l];
                }
            }
            counter++;
            //1 mult stage and 5 stages of pipeline           
            //pooling
            if(conv_res[0] > conv_res[1]){
                temp0 = conv_res[0];
            }
            else{
                temp0 = conv_res[1];
            }
            if(conv_res[2] > conv_res[3]){
                temp1 = conv_res[2];
            }
            else{
                temp1 = conv_res[3];
            }
            if(temp0 > temp1){
                pool_res = temp0;
            }
            else{
                pool_res = temp1;
            }
            //relu
            if(pool_res < 0){
                pool_res = 0;
            }
            //dense
            for(int k = 0; k < OUT_SIZE; k++){
                result[k] += pool_res*read_bram(v, k+17);
            }
            //two stage incrementation
         v++;
        }
    }

    done = 1;
}

void Hard::b_transport(pl_t &pl, sc_core::sc_time &offset){
    tlm::tlm_command cmd = pl.get_command();
    sc_dt::uint64 addr = pl.get_address();
    unsigned int len = pl.get_data_length();
    unsigned char *buf = pl.get_data_ptr();
    pl.set_response_status( tlm::TLM_OK_RESPONSE );

    if (len != BUFF_SIZE){
        pl.set_response_status( tlm::TLM_BURST_ERROR_RESPONSE );
    }

    if(cmd == tlm::TLM_WRITE_COMMAND){
        if(addr == ADDR_CMD){
            start = to_fixed(buf);
            done = !start;
            network();
        }
        else if(addr == ADDR_INIT){
            start_i = to_fixed(buf);
            done_i = !start_i;
            init_bram();
        }
        else{
            pl.set_response_status( tlm::TLM_ADDRESS_ERROR_RESPONSE );
        }
    }
    else if(cmd == tlm::TLM_READ_COMMAND){
        if(addr == ADDR_STATUS){
            to_uchar(buf, done);
        }
        else if(addr == ADDR_STATUS_INIT){
            to_uchar(buf, done_i);
        }
        else if(addr >= ADDR_RES){
            to_uchar(buf, result[addr - ADDR_RES]);
        }
        else{
            pl.set_response_status( tlm::TLM_ADDRESS_ERROR_RESPONSE );
        }
    }
    else{
        pl.set_response_status( tlm::TLM_COMMAND_ERROR_RESPONSE );
    }
}

num_t Hard::read_bram(int addr, unsigned char type){
    pl_t pl;//paylaod
    unsigned char buf[BUFF_SIZE];//buffer that converts num_t into unsigned char for interconnect
    pl.set_address(addr*BUFF_SIZE);//set address
    pl.set_data_length(BUFF_SIZE);//set data length
    pl.set_data_ptr(buf);//set data
    pl.set_command( tlm::TLM_READ_COMMAND );//set command
    pl.set_response_status ( tlm::TLM_INCOMPLETE_RESPONSE );//set response
    sc_core::sc_time offset = sc_core::SC_ZERO_TIME;//TIME ???

    switch(type){
        case 0:
            i0so->b_transport(pl, offset);//transport
            break;
        case 1:
            i1so->b_transport(pl, offset);//transport
            break;
        case 2:
            i2so->b_transport(pl, offset);//transport
            break;
        case 3:
            i3so->b_transport(pl, offset);//transport
            break;
        case 4:
            i4so->b_transport(pl, offset);//transport
            break;
        case 5:
            i5so->b_transport(pl, offset);//transport
            break;
        case 6:
            i6so->b_transport(pl, offset);//transport
            break;
        case 7:
            i7so->b_transport(pl, offset);//transport
            break;
        case 8:
            i8so->b_transport(pl, offset);//transport
            break;
        case 9:
            i9so->b_transport(pl, offset);//transport
            break;
        case 10:
            iaso->b_transport(pl, offset);//transport
            break;
        case 11:
            ibso->b_transport(pl, offset);//transport
            break;
        case 12:
            icso->b_transport(pl, offset);//transport
            break;
        case 13:
            idso->b_transport(pl, offset);//transport
            break;
        case 14:
            ieso->b_transport(pl, offset);//transport
            break;
        case 15:
            ifso->b_transport(pl, offset);//transport
            break;
        case 16:
            coso->b_transport(pl, offset);//transport
            break;
        case 17:
            d0so->b_transport(pl, offset);//transport
            break;
        case 18:
            d1so->b_transport(pl, offset);//transport
            break;
        case 19:
            d2so->b_transport(pl, offset);//transport
            break;
        case 20:
            d3so->b_transport(pl, offset);//transport
            break;
        case 21:
            d4so->b_transport(pl, offset);//transport
            break;
        case 22:
            d5so->b_transport(pl, offset);//transport
            break;
        case 23:
            d6so->b_transport(pl, offset);//transport
            break;
        case 24:
            d7so->b_transport(pl, offset);//transport
            break;
        case 25:
            d8so->b_transport(pl, offset);//transport
            break;
        case 26:
            d9so->b_transport(pl, offset);//transport
            break;
        default://error
            break;
    }

    return to_fixed(buf);
}

void Hard::write_bram(int addr, num_t val, unsigned char type){
    pl_t pl;//payload
    unsigned char buf[BUFF_SIZE];//buffer that converts num_t into unsigned char for interconnect
    to_uchar(buf, val);//convert val from num_t into unsigned char
    pl.set_address(addr*BUFF_SIZE);//set address
    pl.set_data_length(BUFF_SIZE);//set length
    pl.set_data_ptr(buf);//set data
    pl.set_command( tlm::TLM_WRITE_COMMAND );//set command
    pl.set_response_status ( tlm::TLM_INCOMPLETE_RESPONSE );//set response

    switch(type){
        case 0:
            i0so->b_transport(pl, offset);//transport
            break;
        case 1:
            i1so->b_transport(pl, offset);//transport
            break;
        case 2:
            i2so->b_transport(pl, offset);//transport
            break;
        case 3:
            i3so->b_transport(pl, offset);//transport
            break;
        case 4:
            i4so->b_transport(pl, offset);//transport
            break;
        case 5:
            i5so->b_transport(pl, offset);//transport
            break;
        case 6:
            i6so->b_transport(pl, offset);//transport
            break;
        case 7:
            i7so->b_transport(pl, offset);//transport
            break;
        case 8:
            i8so->b_transport(pl, offset);//transport
            break;
        case 9:
            i9so->b_transport(pl, offset);//transport
            break;
        case 10:
            iaso->b_transport(pl, offset);//transport
            break;
        case 11:
            ibso->b_transport(pl, offset);//transport
            break;
        case 12:
            icso->b_transport(pl, offset);//transport
            break;
        case 13:
            idso->b_transport(pl, offset);//transport
            break;
        case 14:
            ieso->b_transport(pl, offset);//transport
            break;
        case 15:
            ifso->b_transport(pl, offset);//transport
            break;
        case 16:
            coso->b_transport(pl, offset);//transport
            break;
        case 17:
            d0so->b_transport(pl, offset);//transport
            break;
        case 18:
            d1so->b_transport(pl, offset);//transport
            break;
        case 19:
            d2so->b_transport(pl, offset);//transport
            break;
        case 20:
            d3so->b_transport(pl, offset);//transport
            break;
        case 21:
            d4so->b_transport(pl, offset);//transport
            break;
        case 22:
            d5so->b_transport(pl, offset);//transport
            break;
        case 23:
            d6so->b_transport(pl, offset);//transport
            break;
        case 24:
            d7so->b_transport(pl, offset);//transport
            break;
        case 25:
            d8so->b_transport(pl, offset);//transport
            break;
        case 26:
            d9so->b_transport(pl, offset);//transport
            break;
        default://error
            break;
    }
}
