#ifndef NETWORK_H_INCLUDED
#define NETWORK_H_INCLUDED

#include <iostream>
#include <vector>
#include "matfun.h"
#include "convolution.h"
#include "pooling.h"
#include "flatten.h"
#include "dense.h"
using namespace std;

class Network{
    private:
        int conv_size;
        int img_size;
        int out_size;
    public:
        Network(int a, int b, int c);
        vector<double> pass(vector<vector<vector<double>>> &img, FILE *weights);
};

#endif // NETWORK_H_INCLUDED
