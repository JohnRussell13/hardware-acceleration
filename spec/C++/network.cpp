#include "network.h"
#include <iostream>
#include <vector>
#include "matfun.h"
using namespace std;

Network::Network(int a, int b, int c){
    conv_size = a;
    img_size = b;
    out_size = c;
}

vector<double> Network::pass(vector<vector<vector<double>>> &img, FILE *weights){
    Convolution L1(img_size, 1, conv_size, 3);
    Pooling L2(L1.get_aft_size(), conv_size);
    Flatten L3(L2.get_aft_size(), conv_size);
    Dense L4(L3.get_aft_size(), out_size);

    //print3(img, 1, img_size, img_size);

    L1.set_img(img);
    L1.set_weights(weights);
    L1.convolve();

    vector<vector<vector<double>>> a;
    a = L1.get_res();

    //print3(a, conv_size, L1.get_aft_size(), L1.get_aft_size());

    L2.set_in(a);
    L2.pool();

    vector<vector<vector<double>>> b;
    b = L2.get_res();

    //print3(b, conv_size, L2.get_aft_size(), L2.get_aft_size());

    L3.set_in(b);
    L3.flat();

    vector<double> c;
    c = L3.get_res();

    //print1(c, L3.get_aft_size());

    L4.set_in(c);
    L4.set_weights(weights);
    L4.calc();
    return L4.get_res();
}
