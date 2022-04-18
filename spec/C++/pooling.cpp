#include "pooling.h"
#include <iostream>
#include <vector>
#include "matfun.h"
using namespace std;

Pooling::Pooling(int a, int b){
	in_size = a;
	in_num = b;
	init3(in, in_num, in_size, in_size);
	init3(result, in_num, in_size/2, in_size/2);
}

void Pooling::set_in(vector<vector<vector<double>>> &x){
    for(int i = 0; i < in_num; i++){
        for(int j = 0; j < in_size; j++){
            for(int k = 0; k < in_size; k++){
                in[i][j][k] = x[i][j][k];
            }
        }
    }
}

void Pooling::pool(){
    double temp0 = 0;
    double temp1 = 0;
    for(int i = 0; i < in_num; i++){
        for(int j = 0; j < in_size/2; j++){
            for(int k = 0; k < in_size/2; k++){
                if(in[i][2*j][2*k] > in[i][2*j][2*k+1]){
                    temp0 = in[i][2*j][2*k];
                }
                else{
                    temp0 = in[i][2*j][2*k+1];
                }
                if(in[i][2*j+1][2*k] > in[i][2*j+1][2*k+1]){
                    temp1 = in[i][2*j+1][2*k];
                }
                else{
                    temp1 = in[i][2*j+1][2*k+1];
                }
                if(temp0 > temp1){
                    result[i][j][k] = temp0;
                }
                else{
                    result[i][j][k] = temp1;
                }
            }
        }
    }
}

vector<vector<vector<double>>> Pooling::get_res(){
    return result;
}

int Pooling::get_aft_size(){
	return in_size/2;
}
