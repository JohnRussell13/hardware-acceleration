#define SC_MAIN
#include <systemc>
#include "tb_cnn.hpp"

using namespace sc_core;

int sc_main(int argc, char* argv[])
{
  tb_cnn uut("uut");

  sc_start();

  return 0;
}
