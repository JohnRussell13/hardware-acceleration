#include "matfun.h"
#include <iostream>
#include <vector>
using namespace std;

void init1(vector<double> &x, int dim1){
    for(int i = 0; i < dim1; i++) {
        x.push_back(0);
    }
}

void init2(vector<vector<double>> &x, int dim1, int dim2){
    for(int i = 0; i < dim1; i++) {
        vector<double> v1;
        for(int j = 0; j < dim2; j++) {
            v1.push_back(0);
        }
        x.push_back(v1);
    }
}

void init3(vector<vector<vector<double>>> &x, int dim1, int dim2, int dim3){
    for(int i = 0; i < dim1; i++) {
        vector<vector<double>> m1;
        for(int j = 0; j < dim2; j++) {
        	vector<double> v1;
        	for(int k = 0; k < dim3; k++){
        		v1.push_back(0);
        	}
            m1.push_back(v1);
        }
        x.push_back(m1);
    }
}

void print1(vector<double> &x, int dim1){
	for(int i = 0; i < dim1; i++){
		cout << x[i] << ' ';
	}
	cout << endl;
}

void print2(vector<vector<double>> &x, int dim1, int dim2){
	for(int i = 0; i < dim1; i++){
		for(int j = 0; j < dim2; j++){
			cout << x[i][j] << ' ';
		}
		cout << endl;
	}
	cout << endl;
}

void print3(vector<vector<vector<double>>> &x, int dim1, int dim2, int dim3){
	for(int i = 0; i < dim1; i++){
		for(int j = 0; j < dim2; j++){
			for(int k = 0; k < dim3; k++){
				cout << x[i][j][k] << ' ';
			}
			cout << endl;
		}
		cout << endl;
	}
	cout << endl;
}
