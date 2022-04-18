#ifndef CONVOLUTION_H_INCLUDED
#define CONVOLUTION_H_INCLUDED

#include <iostream>
#include <vector>
#include "matfun.h"
using namespace std;

class Convolution {
  protected:
	int img_size;
	int num_prev;
	int num_aft;
	int ker_size;
	vector<vector<vector<double>>> image;
	vector<vector<vector<double>>> weights;
	vector<vector<vector<double>>> result;
  public:
    Convolution(int a, int b, int c, int d);
    void set_img(vector<vector<vector<double>>> &x);
    void set_weights(FILE *file);
    void convolve();
    vector<vector<vector<double>>> get_res();
    int get_aft_size();
};

#endif // CONVOLUTION_H_INCLUDED
