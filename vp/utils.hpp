#ifndef _UTILS_HPP_
#define _UTILS_HPP_

#include <string>
#include <vector>
#include <iostream>
#include <bitset>
#include "typedefs.hpp"

using namespace std;

static const int TOTAL_SIZE = W;//num of bits in num_t
static const int WHOLE_SIZE = I;//num of whole bits in num_t
static const int FRAC_SIZE = TOTAL_SIZE - WHOLE_SIZE;//num of fractional bits in num_t
static const int CHAR_LEN = 8;//num of bits in char
static const int BUFF_SIZE = (int) std::ceil( (float)TOTAL_SIZE / CHAR_LEN);//how many chars are needed for num_t
static const int BUFF_EXTRA = BUFF_SIZE*CHAR_LEN - TOTAL_SIZE;//how many chars are extra

static const int NUM_CONV = 32;
static const int KER_SIZE = 3;
static const int OUT_SIZE = 10;

extern int counter;
extern sc_core::sc_time offset;
extern sc_core::sc_time delay;

num_t to_fixed (unsigned char *buf);//change unsigned char * into num_t
void to_uchar (unsigned char *buf, num_t d);//change num_t into unsigned char *

void init(vector<num_t> &, int);//init 1D array
void init(vector<vector<num_t>> &, int, int);//init 2D matrix
void init(vector<vector<vector<num_t>>> &, int, int, int);//init 3D array of matrices
void printv(vector<num_t> &, int);//print 1D array
void printv(vector<vector<num_t>> &, int, int);//print 2D matrix
void printv(vector<vector<vector<num_t>>> &, int, int, int);//print 3D array of matrices

#endif // _UTILS_HPP_
