#ifndef POOLING_H_INCLUDED
#define POOLING_H_INCLUDED

#include <iostream>
#include <vector>
#include "matfun.h"
using namespace std;

class Pooling {
  protected:
	int in_size;
	int in_num;
	vector<vector<vector<double>>> in;
	vector<vector<vector<double>>> result;
  public:
    Pooling(int a, int b);
    void set_in(vector<vector<vector<double>>> &x);
    void pool();
    vector<vector<vector<double>>> get_res();
    int get_aft_size();
};

#endif // POOLING_H_INCLUDED
