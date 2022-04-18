#ifndef TB_CNN
#define TB_CNN

#include <systemc>
#include "cnn.hpp"

class tb_cnn : public sc_core::sc_module
{
public:
	tb_cnn(sc_core::sc_module_name name);
protected:
	void gen_thread();
	void mon_thread();
	cnn dut;
	sc_core::sc_clock clk;

	//LIST OF SIGNALS
	sc_core::sc_signal< sc_dt::sc_logic > start;
	sc_core::sc_signal< sc_dt::sc_logic > ready;
	sc_core::sc_signal< sc_dt::sc_lv<32> > addra;
	sc_core::sc_signal< sc_dt::sc_lv<32> > dina;
	sc_core::sc_signal< sc_dt::sc_lv<64> > wea;
	sc_core::sc_signal< sc_dt::sc_lv<32> > r_o_0;
	sc_core::sc_signal< sc_dt::sc_lv<32> > r_o_1;
	sc_core::sc_signal< sc_dt::sc_lv<32> > r_o_2;
	sc_core::sc_signal< sc_dt::sc_lv<32> > r_o_3;
	sc_core::sc_signal< sc_dt::sc_lv<32> > r_o_4;
	sc_core::sc_signal< sc_dt::sc_lv<32> > r_o_5;
	sc_core::sc_signal< sc_dt::sc_lv<32> > r_o_6;
	sc_core::sc_signal< sc_dt::sc_lv<32> > r_o_7;
	sc_core::sc_signal< sc_dt::sc_lv<32> > r_o_8;
	sc_core::sc_signal< sc_dt::sc_lv<32> > r_o_9;
private:
};

#ifndef SC_MAIN
SC_MODULE_EXPORT(tb_cnn)
#endif

#endif
