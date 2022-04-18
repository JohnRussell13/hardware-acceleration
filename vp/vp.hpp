#ifndef VP_HPP_
#define VP_HPP_

#include <systemc>
#include "soft.hpp"
#include "bram_ctrl.hpp"
#include "bram.hpp"
#include "hard.hpp"
#include "interconnect.hpp"

class Vp :  public sc_core::sc_module{
public:
    Vp(sc_core::sc_module_name name, char *weight, char *image);
    ~Vp();
protected:
    Soft soft;
    BramCtrl bct;
    Bram img0, img1, img2, img3, img4, img5, img6, img7, img8, img9, imga, imgb, imgc, imgd, imge, imgf;
    Bram conv, den0, den1, den2, den3, den4, den5, den6, den7, den8, den9;
    Hard hard;
    Interconnect ic;
};

#endif // VP_HPP_
