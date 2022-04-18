#ifndef FLATTEN_H_INCLUDED
#define FLATTEN_H_INCLUDED

#include <iostream>
#include <vector>
#include "matfun.h"
using namespace std;

class Flatten {
  protected:
	int in_size;
	int in_num;
	vector<vector<vector<double>>> in;
	vector<double> result;
  public:
    Flatten(int a, int b);
    void set_in(vector<vector<vector<double>>> &x);
    void flat();
    vector<double> get_res();
    int get_aft_size();
};

#endif // FLATTEN_H_INCLUDED
