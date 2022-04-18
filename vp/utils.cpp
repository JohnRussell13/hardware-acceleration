#include "utils.hpp"

void init(vector<num_t> &x, int dim1){
    for(int i = 0; i < dim1; i++) {
        x.push_back(0);
    }
}

void init(vector<vector<num_t>> &x, int dim1, int dim2){
    for(int i = 0; i < dim1; i++) {
        vector<num_t> v1;
        for(int j = 0; j < dim2; j++) {
            v1.push_back(0);
        }
        x.push_back(v1);
    }
}

void init(vector<vector<vector<num_t>>> &x, int dim1, int dim2, int dim3){
    for(int i = 0; i < dim1; i++) {
        vector<vector<num_t>> m1;
        for(int j = 0; j < dim2; j++) {
        	vector<num_t> v1;
        	for(int k = 0; k < dim3; k++){
        		v1.push_back(0);
        	}
            m1.push_back(v1);
        }
        x.push_back(m1);
    }
}

void printv(vector<num_t> &x, int dim1){
	for(int i = 0; i < dim1; i++){
		cout << x[i] << ' ';
	}
	cout << endl;
}

void printv(vector<vector<num_t>> &x, int dim1, int dim2){
	for(int i = 0; i < dim1; i++){
		for(int j = 0; j < dim2; j++){
			cout << x[i][j] << ' ';
		}
		cout << endl;
	}
	cout << endl;
}

void printv(vector<vector<vector<num_t>>> &x, int dim1, int dim2, int dim3){
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

num_t to_fixed (unsigned char *buf){
    string s;
    num_t mult = 1;//sign

    for (int i = 0; i < BUFF_SIZE; ++i){
        s += bitset<CHAR_LEN>((int)buf[i]).to_string();//from unsigned char into binary
    }

    if (s[0] == '1'){
        s = bitset< TOTAL_SIZE + BUFF_EXTRA >( -stoi(s, 0, 2) ).to_string();//turn negative into positive and change mult
        mult = -1;
    }

    string w, f;//whole and fraction parts
    for(int i = 0; i < WHOLE_SIZE; i++){
        w += s[i];//whole part
    }
    for(int i = WHOLE_SIZE; i < TOTAL_SIZE; i++){
        f += s[i];//fraction part
    }

    int w_i = stoi(w, 0, 2);//turn from string into int
    double f_i = (double)stoi(f, 0, 2);//turn from string into double

    return (num_t) ( mult*(w_i + f_i / (1 << FRAC_SIZE)));//set put it back together and set sign
}

void to_uchar(unsigned char *buf, num_t d){
    string s = d.to_bin();//from num_t into binary

    s.erase(0,2);//erase 0b
    s.erase(I, 1);//erase .

    char single_char[CHAR_LEN];
    for (int i = 0; i < BUFF_SIZE; i++){
        s.copy(single_char, CHAR_LEN, i*CHAR_LEN);//copy first BUFF_SIZE bits
        buf[i] = (unsigned char) stoi(single_char, 0, 2);//change to unsigned char
    }
}
