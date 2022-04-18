#include "tb_cnn.hpp"
#include <string>
#include <iostream>
#include <stdio.h>

using namespace sc_core;
using namespace sc_dt;
using namespace std;
#define IMG_SIZE 28

int comp2(float t){
	if(t >= 0) return (int)(t*2048);
	else return 524288 + (int)(t*2048);
}

float cast(sc_uint<32> t){
	int x = (int) t;
	if(x < 262144) return x/2048.0;
	else return (x - 524288)/2048.0;
}

SC_HAS_PROCESS(tb_cnn);

tb_cnn::tb_cnn(sc_module_name name) :
	sc_module(name),
	dut("dut"),
	clk("clk", 10, SC_NS)
{
	SC_THREAD(gen_thread);
	SC_METHOD(mon_thread);
	dont_initialize();
	sensitive << ready;
	dut.clk( clk.signal() );
	//LIST OF SIGNALS	
	dut.start(start);
	dut.ready(ready);
	dut.addra(addra);
	dut.dina(dina);
	dut.wea(wea);
	dut.r_o_0(r_o_0);
	dut.r_o_1(r_o_1);
	dut.r_o_2(r_o_2);
	dut.r_o_3(r_o_3);
	dut.r_o_4(r_o_4);
	dut.r_o_5(r_o_5);
	dut.r_o_6(r_o_6);
	dut.r_o_7(r_o_7);
	dut.r_o_8(r_o_8);
	dut.r_o_9(r_o_9);
}

void tb_cnn::gen_thread()
{
	int i, j, a, b;
	int temp;
	ostringstream ss;
	int n[16];
	FILE *wp;
	FILE *ip;
	float t;
	wp = fopen("../data/weights.txt", "r");
	ip = fopen("../data/image0.txt", "r");

	for(i =  0; i < 16; i++){
		n[i] = 0;
	}
		

	wait(1, SC_NS);
	start.write(SC_LOGIC_0);
	//INPUT SIGNALS

	ss << "@" << sc_time_stamp();
	ss << " image init started";
	SC_REPORT_INFO(name(), ss.str().c_str());
	ss.str("");
	ss.clear();
	for(i = 0; i < 28; i++){
		for(j = 0; j < 28; j++){
		    //if block
		    fscanf(ip, "%d", &temp);
		    t = temp / 256.0;
		    temp = comp2(t);
		    a = i & 1;
		    b = j & 1;
		    if(a == 0){
		        if(b == 0){
		            if(i != IMG_SIZE - 2 && j != IMG_SIZE - 2){
				addra.write(n[0]);
				dina.write(temp);
				wea.write(1 << (0));
		            	n[0]++;
				wait(10, SC_NS);
		            }

		            if(i != IMG_SIZE - 2 && j != 0){
				addra.write(n[2]);
				dina.write(temp);
				wea.write(1 << (2));
		            	n[2]++;
				wait(10, SC_NS);
		            }

		            if(i != 0 && j != IMG_SIZE - 2){
				addra.write(n[8]);
				dina.write(temp);
				wea.write(1 << (8));
		            	n[8]++;
				wait(10, SC_NS);
		            }
		            if(i != 0 && j != 0){
				addra.write(n[10]);
				dina.write(temp);
				wea.write(1 << (10));
		            	n[10]++;
				wait(10, SC_NS);
		            }
		        }
		        else{
		            if(i != IMG_SIZE - 2 && j != IMG_SIZE - 1){
				addra.write(n[1]);
				dina.write(temp);
				wea.write(1 << (1));
		            	n[1]++;
				wait(10, SC_NS);
		            }

		            if(i != 0 && j != IMG_SIZE - 1){
				addra.write(n[9]);
				dina.write(temp);
				wea.write(1 << (9));
		            	n[9]++;
				wait(10, SC_NS);
		            }

		            if(i != IMG_SIZE - 2 && j != 1){
				addra.write(n[3]);
				dina.write(temp);
				wea.write(1 << (3));
		            	n[3]++;
				wait(10, SC_NS);
		            }

		            if(i != 0 && j != 1){
				addra.write(n[11]);
				dina.write(temp);
				wea.write(1 << (11));
		            	n[11]++;
				wait(10, SC_NS);
		            }
		        }
		    }
		    else{
		        if(b == 0){
		            if(i != IMG_SIZE - 1 && j != IMG_SIZE - 2){
				addra.write(n[4]);
				dina.write(temp);
				wea.write(1 << (4));
		            	n[4]++;
				wait(10, SC_NS);
		            }
		            if(i != 1 && j != IMG_SIZE - 2){
				addra.write(n[12]);
				dina.write(temp);
				wea.write(1 << (12));
		            	n[12]++;
				wait(10, SC_NS);
		            }
		            if(i != IMG_SIZE - 1 && j != 0){
				addra.write(n[6]);
				dina.write(temp);
				wea.write(1 << (6));
		            	n[6]++;
				wait(10, SC_NS);
		            }
		            if(i != 1 && j != 0){
				addra.write(n[14]);
				dina.write(temp);
				wea.write(1 << (14));
		            	n[14]++;
				wait(10, SC_NS);
		            }
		        }
		        else{
		            if(i != IMG_SIZE - 1 && j != IMG_SIZE - 1){
				addra.write(n[5]);
				dina.write(temp);
				wea.write(1 << (5));
		            	n[5]++;
				wait(10, SC_NS);
		            }

		            if(i != 1 && j != IMG_SIZE - 1){
				addra.write(n[13]);
				dina.write(temp);
				wea.write(1 << (13));
		            	n[13]++;
				wait(10, SC_NS);
		            }

		            if(i != IMG_SIZE - 1 && j != 1){
				addra.write(n[7]);
				dina.write(temp);
				wea.write(1 << (7));
		            	n[7]++;
				wait(10, SC_NS);
		            }
		            if(i != 1 && j != 1){
				addra.write(n[15]);
				dina.write(temp);
				wea.write(1 << (15));
		            	n[15]++;
				wait(10, SC_NS);
		            }
		        }
		    }
		}
	}
	ss << "@" << sc_time_stamp();
	ss << " image init done";
	SC_REPORT_INFO(name(), ss.str().c_str());
	ss.str("");
	ss.clear();

	ss << "@" << sc_time_stamp();
	ss << " conv init started";
	SC_REPORT_INFO(name(), ss.str().c_str());
	ss.str("");
	ss.clear();
	for(i = 0; i < 32; i++){
		for(j = 0; j < 9; j++){
			addra.write(i);
			fscanf(wp, "%f", &t);
			temp = comp2(t);
			dina.write(temp);
			wea.write(1 << (16+j));
			wait(10, SC_NS);
		}
	}
	ss << "@" << sc_time_stamp();
	ss << " conv init done";
	SC_REPORT_INFO(name(), ss.str().c_str());
	ss.str("");
	ss.clear();

	ss << "@" << sc_time_stamp();
	ss << " weights init part 1 started";
	SC_REPORT_INFO(name(), ss.str().c_str());
	ss.str("");
	ss.clear();
	for(i = 0; i < 7; i++){
		for(j = 0; j < 10; j++){
			addra.write(i);
			dina.write(0);
			wea.write(1 << (16+9+j));
			wait(10, SC_NS);
		}
	}
	ss << "@" << sc_time_stamp();
	ss << " weights init part 1 done";
	SC_REPORT_INFO(name(), ss.str().c_str());
	ss.str("");
	ss.clear();
	

	ss << "@" << sc_time_stamp();
	ss << " weights init part 2 started";
	SC_REPORT_INFO(name(), ss.str().c_str());
	ss.str("");
	ss.clear();
	while(i < 32*13*13 + 7){
		for(j = 0; j < 10; j++){
			addra.write(i);
			fscanf(wp, "%f", &t);
			temp = comp2(t);
			dina.write(temp);
			wea.write(long(long (1) << long(16+9+j))); //why? systemC...
			wait(10, SC_NS);
		}
		i++;
	}
	ss << "@" << sc_time_stamp();
	ss << " weights init part 2 done";
	SC_REPORT_INFO(name(), ss.str().c_str());
	ss.str("");
	ss.clear();

	ss << "@" << sc_time_stamp();
	ss << " start IP";
	SC_REPORT_INFO(name(), ss.str().c_str());
	ss.str("");
	ss.clear();
	start.write(SC_LOGIC_1);

        while(ready.read() == SC_LOGIC_0){
		wait(10, SC_NS);
	}

	ss << "@" << sc_time_stamp();
	ss << " IP done";
	SC_REPORT_INFO(name(), ss.str().c_str());
	ss.str("");
	ss.clear();

	wait(10, SC_NS);
	sc_stop();
}

void tb_cnn::mon_thread()
{
	if(ready.read() == SC_LOGIC_1){
		ostringstream ss;
		FILE *res;
		ss << "@" << sc_time_stamp();
		//OUTPUT SIGNALS
		ss << "\nr_o_0 = " << r_o_0.read();
		ss << "\nr_o_1 = " << r_o_1.read();
		ss << "\nr_o_2 = " << r_o_2.read();
		ss << "\nr_o_3 = " << r_o_3.read();
		ss << "\nr_o_4 = " << r_o_4.read();
		ss << "\nr_o_5 = " << r_o_5.read();
		ss << "\nr_o_6 = " << r_o_6.read();
		ss << "\nr_o_7 = " << r_o_7.read();
		ss << "\nr_o_8 = " << r_o_8.read();
		ss << "\nr_o_9 = " << r_o_9.read();
		SC_REPORT_INFO(name(), ss.str().c_str());
		ss.str("");
		ss.clear();

		res = fopen("../data/results_cosim.txt", "w");
		fprintf(res, "\nCOSIM res: ");
		fprintf(res, "%f %f ", cast(static_cast< sc_uint<32> > (r_o_0.read())), cast(static_cast< sc_uint<32> > (r_o_1.read())));
		fprintf(res, "%f %f ", cast(static_cast< sc_uint<32> > (r_o_2.read())), cast(static_cast< sc_uint<32> > (r_o_3.read())));
		fprintf(res, "%f %f ", cast(static_cast< sc_uint<32> > (r_o_4.read())), cast(static_cast< sc_uint<32> > (r_o_5.read())));
		fprintf(res, "%f %f ", cast(static_cast< sc_uint<32> > (r_o_6.read())), cast(static_cast< sc_uint<32> > (r_o_7.read())));
		fprintf(res, "%f %f ", cast(static_cast< sc_uint<32> > (r_o_8.read())), cast(static_cast< sc_uint<32> > (r_o_9.read())));
	}
}
