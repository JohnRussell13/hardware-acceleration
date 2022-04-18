#include <iostream>
#include <vector>
#include "matfun.h"
#include "convolution.h"
#include "pooling.h"
#include "flatten.h"
#include "dense.h"
#include "network.h"
using namespace std;

void imgscan(FILE *file, vector<vector<vector<double>>> &img, int num, int dim){
    int temp;
    init3(img, num, dim, dim);
    for(int i = 0; i < num; i++){
        for(int j = 0; j < dim; j++){
            for(int k = 0; k < dim; k++){
                fscanf(file, "%d", &temp);
                img[i][j][k] = (double) temp/256.0;
            }
        }
    }
}

int main (int argc, char* argv[]) {
    if(argc < 3){
        return 0;
    }
    vector<double> result;
    vector<vector<vector<double>>> img;

    FILE *weights;
    weights = fopen(argv[1], "r");

    FILE *image;
    image = fopen(argv[2], "r");

    Network Neural(32, 28, 10);

    imgscan(image, img, 1, 28);

    result = Neural.pass(img, weights);
    
    double temp = result[0];
    int j = 0;
    for(int i = 1; i < 10; i++){
        if(temp < result[i]){
            temp = result[i];
            j = i;
        }
    }
   
    string msg = "Image showed: ";//set message
    switch(j){
        case 0:
            msg += "T-shirt/top";
            break;
        case 1:
            msg += "Trousers";
            break;
        case 2:
            msg += "Pullover";
            break;
        case 3:
            msg += "Dress";
            break;
        case 4:
            msg += "Coat";
            break;
        case 5:
            msg += "Sandal";
            break;
        case 6:
            msg += "Shirt";
            break;
        case 7:
            msg += "Sneaker";
            break;
        case 8:
            msg += "Bag";
            break;
        case 9:
            msg += "Ankle boot";
            break;
        default:
            msg += "NaN";
            break;
    }
    std::cout << std::endl << msg << std::endl;//print message
    print1(result, 10);

    fclose(weights);
    weights = NULL;

    fclose(image);
    image = NULL;



	return 0;
}
