#include "convolution.h"
#include <iostream>
#include <vector>
#include "matfun.h"
using namespace std;

Convolution::Convolution(int a, int b, int c, int d){
	img_size = a;
	num_prev = b;
	num_aft = c;
	ker_size = d;
	init3(image, num_prev, img_size, img_size);
	init3(weights, num_aft, ker_size, ker_size);
	init3(result, num_aft, img_size-(ker_size-1), img_size-(ker_size-1));
}

void Convolution::set_img(vector<vector<vector<double>>> &x){
    for(int i = 0; i < num_prev; i++){
        for(int j = 0; j < img_size; j++){
            for(int k = 0; k < img_size; k++){
                image[i][j][k] = x[i][j][k];
            }
        }
    }
}

void Convolution::set_weights(FILE *file){
    for(int i = 0; i < num_aft; i++){
        for(int j = 0; j < ker_size; j++){
            for(int k = 0; k < ker_size; k++){
                fscanf(file, "%lf", &weights[i][j][k]); //C style
            }
        }
    }
}

void Convolution::convolve(){
    for(int i = 0; i < num_aft; i++){
        for(int j = 0; j < img_size-(ker_size-1); j++){
            for(int k = 0; k < img_size-(ker_size-1); k++){
                for(int n = 0; n < num_prev; n++){
                    for(int l = 0; l < ker_size; l++){
                        for(int m = 0; m < ker_size; m++){
                            result[i][j][k] += image[n][j+l][k+m] * weights[i][l][m];
                        }
                    }
                }
                //relu
                if(result[i][j][k] < 0){
                    result[i][j][k] = 0;
                }
            }
        }
    }
}

vector<vector<vector<double>>> Convolution::get_res(){
    return result;
}

int Convolution::get_aft_size(){
	return img_size-(ker_size-1);
}
