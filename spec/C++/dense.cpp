#include "dense.h"
#include <iostream>
#include <vector>
#include "matfun.h"
using namespace std;

Dense::Dense(int a, int b){
	in_size = a;
	out_size = b;
	init1(in, in_size);
	init2(weights, in_size, out_size);
	init1(result, out_size);
}

void Dense::set_in(vector<double> &x){
    for(int i = 0; i < in_size; i++){
        in[i] = x[i];
    }
}

void Dense::set_weights(FILE *file){
    for(int i = 0; i < in_size; i++){
        for(int j = 0; j < out_size; j++){
            fscanf(file, "%lf", &weights[i][j]);
        }
    }
}

void Dense::calc(){
    for(int i = 0; i < out_size; i++){
        for(int j = 0; j < in_size; j++){
            result[i] += in[j] * weights[j][i];
        }
    }
}

vector<double> Dense::get_res(){
    return result;
}
