#ifndef MATFUN_H_INCLUDED
#define MATFUN_H_INCLUDED

#include <iostream>
#include <vector>
using namespace std;

void init1(vector<double> &x, int dim1);
void init2(vector<vector<double>> &x, int dim1, int dim2);
void init3(vector<vector<vector<double>>> &x, int dim1, int dim2, int dim3);
void print1(vector<double> &x, int dim1);
void print2(vector<vector<double>> &x, int dim1, int dim2);
void print3(vector<vector<vector<double>>> &x, int dim1, int dim2, int dim3);

#endif // MATFUN_H_INCLUDED
