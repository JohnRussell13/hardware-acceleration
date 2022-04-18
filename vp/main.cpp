#include <systemc>
#include "vp.hpp"
#include <sstream>
using namespace sc_core;
using namespace tlm;

int counter;
sc_core::sc_time offset;
sc_core::sc_time delay;
int t;
int sc_main(int argc, char* argv[]){
	counter = 0;
    if(argc != 3){
        return 0;
    }
  	Vp vp("VP", argv[1], argv[2]);
	sc_start();

   return 0;
}
