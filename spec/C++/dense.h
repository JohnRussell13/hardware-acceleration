#ifndef DENSE_H_INCLUDED
#define DENSE_H_INCLUDED

#include <iostream>
#include <vector>
#include "matfun.h"
using namespace std;

class Dense {
  protected:
	int in_size;
	int out_size;
	vector<double> in;
	vector<vector<double>> weights;
	vector<double> result;
  public:
    Dense(int a, int b);
    void set_in(vector<double> &x);
    void set_weights(FILE *file);
    void calc();
    vector<double> get_res();
};
#endif // DENSE_H_INCLUDED
