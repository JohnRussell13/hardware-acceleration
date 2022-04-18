#ifndef _CNN_HPP_
#define _CNN_HPP_

#include <systemc>

class cnn : public sc_core::sc_foreign_module
{
public:
	cnn(sc_core::sc_module_name name) :
		sc_core::sc_foreign_module(name),
		clk("clk"),
		//LIST OF SIGNALS		
		start("start"),
		ready("ready"),
		addra("addra"),
		dina("dina"),
		wea("wea"),
		r_o_0("r_o_0"),
		r_o_1("r_o_1"),
		r_o_2("r_o_2"),
		r_o_3("r_o_3"),
		r_o_4("r_o_4"),
		r_o_5("r_o_5"),
		r_o_6("r_o_6"),
		r_o_7("r_o_7"),
		r_o_8("r_o_8"),
		r_o_9("r_o_9")
	{

	}

	sc_core::sc_in< bool > clk;
	//LIST OF SIGNALS
	sc_core::sc_in< sc_dt::sc_logic > start;
	sc_core::sc_out< sc_dt::sc_logic > ready;
	sc_core::sc_in< sc_dt::sc_lv<32> > addra;
	sc_core::sc_in< sc_dt::sc_lv<32> > dina;
	sc_core::sc_in< sc_dt::sc_lv<64> > wea;
	sc_core::sc_out< sc_dt::sc_lv<32> > r_o_0;
	sc_core::sc_out< sc_dt::sc_lv<32> > r_o_1;
	sc_core::sc_out< sc_dt::sc_lv<32> > r_o_2;
	sc_core::sc_out< sc_dt::sc_lv<32> > r_o_3;
	sc_core::sc_out< sc_dt::sc_lv<32> > r_o_4;
	sc_core::sc_out< sc_dt::sc_lv<32> > r_o_5;
	sc_core::sc_out< sc_dt::sc_lv<32> > r_o_6;
	sc_core::sc_out< sc_dt::sc_lv<32> > r_o_7;
	sc_core::sc_out< sc_dt::sc_lv<32> > r_o_8;
	sc_core::sc_out< sc_dt::sc_lv<32> > r_o_9;

	const char* hdl_name() const { return "cnn"; }
};

#endif
