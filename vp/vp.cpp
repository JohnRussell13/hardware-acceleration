#include "vp.hpp"

Vp::Vp (sc_core::sc_module_name name, char *weight, char *image): sc_module (name), soft("Soft", image), bct("BramCtrl"), hard("Hard", weight),
 img0("ImgBram0"), img1("ImgBram1"), img2("ImgBram2"), img3("ImgBram3"), img4("ImgBram4"), img5("ImgBram5"), img6("ImgBram6"), img7("ImgBram7"),
 img8("ImgBram8"), img9("ImgBram9"), imga("ImgBramA"), imgb("ImgBramB"), imgc("ImgBramC"), imgd("ImgBramD"), imge("ImgBramE"), imgf("ImgBramF"),
 conv("ConvBram"), den0("DenBram0"), den1("DenBram1"), den2("DenBram2"), den3("DenBram3"), den4("DenBram4"), den5("DenBram5"), den6("DenBram6"),
 den7("DenBram7"), den8("DenBram8"), den9("DenBram9"), ic("Interconnect"){
    soft.icso.bind(ic.sfso);//bind software and interconnect

    ic.brso.bind(bct.sfso);//bind interconnect and software
    bct.i0so.bind(img0.bsoa);//bind bram controller and bram
    bct.i1so.bind(img1.bsoa);//bind bram controller and bram
    bct.i2so.bind(img2.bsoa);//bind bram controller and bram
    bct.i3so.bind(img3.bsoa);//bind bram controller and bram
    bct.i4so.bind(img4.bsoa);//bind bram controller and bram
    bct.i5so.bind(img5.bsoa);//bind bram controller and bram
    bct.i6so.bind(img6.bsoa);//bind bram controller and bram
    bct.i7so.bind(img7.bsoa);//bind bram controller and bram
    bct.i8so.bind(img8.bsoa);//bind bram controller and bram
    bct.i9so.bind(img9.bsoa);//bind bram controller and bram
    bct.iaso.bind(imga.bsoa);//bind bram controller and bram
    bct.ibso.bind(imgb.bsoa);//bind bram controller and bram
    bct.icso.bind(imgc.bsoa);//bind bram controller and bram
    bct.idso.bind(imgd.bsoa);//bind bram controller and bram
    bct.ieso.bind(imge.bsoa);//bind bram controller and bram
    bct.ifso.bind(imgf.bsoa);//bind bram controller and bram
    bct.coso.bind(conv.bsoa);//bind bram controller and bram
    bct.d0so.bind(den0.bsoa);//bind bram controller and bram
    bct.d1so.bind(den1.bsoa);//bind bram controller and bram
    bct.d2so.bind(den2.bsoa);//bind bram controller and bram
    bct.d3so.bind(den3.bsoa);//bind bram controller and bram
    bct.d4so.bind(den4.bsoa);//bind bram controller and bram
    bct.d5so.bind(den5.bsoa);//bind bram controller and bram
    bct.d6so.bind(den6.bsoa);//bind bram controller and bram
    bct.d7so.bind(den7.bsoa);//bind bram controller and bram
    bct.d8so.bind(den8.bsoa);//bind bram controller and bram
    bct.d9so.bind(den9.bsoa);//bind bram controller and bram

    ic.hrso.bind(hard.sfso);//bind interconnect and hardware
    hard.i0so.bind(img0.bsob);//bind hardware and first image bram port b
    hard.i1so.bind(img1.bsob);//bind hardware and second image bram port b
    hard.i2so.bind(img2.bsob);//bind hardware and first image bram port b
    hard.i3so.bind(img3.bsob);//bind hardware and second image bram port b
    hard.i4so.bind(img4.bsob);//bind hardware and first image bram port b
    hard.i5so.bind(img5.bsob);//bind hardware and second image bram port b
    hard.i6so.bind(img6.bsob);//bind hardware and first image bram port b
    hard.i7so.bind(img7.bsob);//bind hardware and second image bram port b
    hard.i8so.bind(img8.bsob);//bind hardware and first image bram port b
    hard.i9so.bind(img9.bsob);//bind hardware and second image bram port b
    hard.iaso.bind(imga.bsob);//bind hardware and first image bram port b
    hard.ibso.bind(imgb.bsob);//bind hardware and second image bram port b
    hard.icso.bind(imgc.bsob);//bind hardware and first image bram port b
    hard.idso.bind(imgd.bsob);//bind hardware and second image bram port b
    hard.ieso.bind(imge.bsob);//bind hardware and first image bram port b
    hard.ifso.bind(imgf.bsob);//bind hardware and second image bram port b
    hard.coso.bind(conv.bsob);//bind hardware and convolution bram port b
    hard.d0so.bind(den0.bsob);//bind hardware and first dense bram port b
    hard.d1so.bind(den1.bsob);//bind hardware and second dense bram port b
    hard.d2so.bind(den2.bsob);//bind hardware and third dense bram port b
    hard.d3so.bind(den3.bsob);//bind hardware and fourth dense bram port b
    hard.d4so.bind(den4.bsob);//bind hardware and fifth dense bram port b
    hard.d5so.bind(den5.bsob);//bind hardware and fifth dense bram port b
    hard.d6so.bind(den6.bsob);//bind hardware and fifth dense bram port b
    hard.d7so.bind(den7.bsob);//bind hardware and fifth dense bram port b
    hard.d8so.bind(den8.bsob);//bind hardware and fifth dense bram port b
    hard.d9so.bind(den9.bsob);//bind hardware and fifth dense bram port b

    SC_REPORT_INFO("Virtual Platform", "Constructed.");//message
}

Vp::~Vp(){
    SC_REPORT_INFO("Virtual Platform", "Destructed.");//message
}
