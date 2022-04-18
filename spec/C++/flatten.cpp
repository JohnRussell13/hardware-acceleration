#include "flatten.h"
#include <iostream>
#include <vector>
#include "matfun.h"
using namespace std;

Flatten::Flatten(int a, int b){
	in_size = a;
	in_num = b;
	init3(in, in_num, in_size, in_size);
	init1(result, in_num*in_size*in_size);
}

void Flatten::set_in(vector<vector<vector<double>>> &x){
    for(int i = 0; i < in_num; i++){
        for(int j = 0; j < in_size; j++){
            for(int k = 0; k < in_size; k++){
                in[i][j][k] = x[i][j][k];
            }
        }
    }
}

void Flatten::flat(){
    int counter = 0;
    for(int i = 0; i < in_num; i++){
        for(int j = 0; j < in_size; j++){
            for(int k = 0; k < in_size; k++){
                result[counter++] = in[i][j][k]; //counter = i*in_size*in_num + j*in_num + k
            }
        }
    }
}

vector<double> Flatten::get_res(){
    return result;
}

int Flatten::get_aft_size(){
	return in_num*in_size*in_size;
}
