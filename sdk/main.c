#include <stdio.h>
#include <stdlib.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xil_io.h"

#define IMG_SIZE 28

/*
int comp2(double t) {
	if(t >= 0){
		return (int)(t*2048);
	}
	else{
		return 524288 + (int)(t*2048);
	}
}
*/

double cast(int t) {
	if(t < 262144) {
		return t/2048.0;
	}
	else {
		return (t - 524288)/2048.0;
	}
}

int main() {
	//FILE *weights, *image;
	int temp;
	int n[16], result[10];
	int weight[32*13*13][10];
	int conv[32][9];
	int img[28][28];
	int data, a, b;
	//double t;
	int i, j;

	srand(0);

	/*
	printf("init weight\n");
	for(i = 0; i < 32*13*13; i++) {
		printf("%d ", i);
		for(j = 0; j < 10; j++) {
			if(rand() % 2) weight[i][j] = rand() % 2048; // 0. ...
			else weight[i][j] = 524288 - rand() % 2048; // -0. ...
		}
	}
	*/

	printf("init conv\n");
	for(i = 0; i < 32; i++) {
		for(j = 0; j < 9; j++) {
			if(rand() % 2) conv[i][j] = rand() % 2048; // 0. ...
			else conv[i][j] = 524288 - rand() % 2048; // -0. ...
		}
	}

	printf("init img\n");
	for(i = 0; i < 28; i++) {
		for(j = 0; j < 28; j++) {
			img[i][j] = rand() % 2048; // 0. ...
		}
	}

	//RIP
	//weights = fopen("weights.txt", "r");
    //image = fopen("image.txt", "r");

    init_platform();

    for(i = 0; i < 16; i++){
    	n[i] = 0;
    }

    printf("writing image to bram\n");
	//init wea
    Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 0);
    Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+8, 0);

    for (i = 0; i < IMG_SIZE; ++i){//write matrix A into bram
        for (j = 0; j < IMG_SIZE; ++j){
        	//fscanf(image, "%d", &temp);

        	temp = img[i][j];

        	a = i & 1;
            b = j & 1;
            if(a == 0){
                if(b == 0){
                    if(i != IMG_SIZE - 2 && j != IMG_SIZE - 2){
    		            Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 1 << (0));
                    	Xil_Out32(XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR + 4*n[0], temp);//0
    		            Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 0);
                    	n[0]++;
                    }

                    if(i != IMG_SIZE - 2 && j != 0){
    		            Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 1 << (2));
                    	Xil_Out32(XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR + 4*n[2], temp);//2
    		            Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 0);
                    	n[2]++;
                    }

                    if(i != 0 && j != IMG_SIZE - 2){
    		            Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 1 << (8));
                    	Xil_Out32(XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR + 4*n[8], temp);//8
    		            Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 0);
                    	n[8]++;
                    }
                    if(i != 0 && j != 0){
    		            Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 1 << (10));
                    	Xil_Out32(XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR + 4*n[10], temp);//10
    		            Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 0);
                    	n[10]++;
                    }
                }
                else{
                    if(i != IMG_SIZE - 2 && j != IMG_SIZE - 1){
    		            Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 1 << (1));
                    	Xil_Out32(XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR + 4*n[1], temp);//1
    		            Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 0);
                    	n[1]++;
                    }

                    if(i != 0 && j != IMG_SIZE - 1){
    		            Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 1 << (9));
                    	Xil_Out32(XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR + 4*n[9], temp);//9
    		            Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 0);
                    	n[9]++;
                    }

                    if(i != IMG_SIZE - 2 && j != 1){
    		            Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 1 << (3));
                    	Xil_Out32(XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR + 4*n[3], temp);//3
    		            Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 0);
                    	n[3]++;
                    }

                    if(i != 0 && j != 1){
    		            Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 1 << (11));
                    	Xil_Out32(XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR + 4*n[11], temp);//11
    		            Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 0);
                    	n[11]++;
                    }
                }
            }
            else{
                if(b == 0){
                    if(i != IMG_SIZE - 1 && j != IMG_SIZE - 2){
    		            Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 1 << (4));
                    	Xil_Out32(XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR + 4*n[4], temp);//4
    		            Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 0);
                    	n[4]++;
                    }
                    if(i != 1 && j != IMG_SIZE - 2){
    		            Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 1 << (12));
                    	Xil_Out32(XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR + 4*n[12], temp);//12
    		            Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 0);
                    	n[12]++;
                    }
                    if(i != IMG_SIZE - 1 && j != 0){
    		            Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 1 << (6));
                    	Xil_Out32(XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR + 4*n[6], temp);//6
    		            Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 0);
                    	n[6]++;
                    }
                    if(i != 1 && j != 0){
    		            Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 1 << (14));
                    	Xil_Out32(XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR + 4*n[14], temp);//14
    		            Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 0);
                    	n[14]++;
                    }
                }
                else{
                    if(i != IMG_SIZE - 1 && j != IMG_SIZE - 1){
    		            Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 1 << (5));
                    	Xil_Out32(XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR + 4*n[5], temp);//5
    		            Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 0);
                    	n[5]++;
                    }

                    if(i != 1 && j != IMG_SIZE - 1){
    		            Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 1 << (13));
                    	Xil_Out32(XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR + 4*n[13], temp);//13
    		            Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 0);
                    	n[13]++;
                    }

                    if(i != IMG_SIZE - 1 && j != 1){
    		            Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 1 << (7));
                    	Xil_Out32(XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR + 4*n[7], temp);//7
    		            Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 0);
                    	n[7]++;
                    }
                    if(i != 1 && j != 1){
    		            Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 1 << (15));
                    	Xil_Out32(XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR + 4*n[15], temp);//15
    		            Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 0);
                    	n[15]++;
                    }
                }
            }
        }
    }
    printf("done\n");

    printf("writing image to bram\n");
    for (i = 0; i < 32; i++){
    	for (j = 0; j < 9; j++){
    		//fscanf(weights, "%lf", &t);
			//temp = comp2(t);

    		temp = conv[i][j];

    		Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 1 << (16+j));
    		Xil_Out32(XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR + 4*i, temp);
    		Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 0);
    	}
    }

    printf("done\n");
    printf("writing conv w to bram\n");
    i = 0;
    while (i < 7){
    	for (j = 0; j < 10; j++){
            if(16+9+j < 32) Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 1 << (16+9+j));
            else Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+8, 1 << (16+9+j - 32));
    		Xil_Out32(XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR + 4*i , 0);
            Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 0);
            Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+8, 0);
    	}
    	i++;
    }
    printf("done\n");
    printf("writing dense w to bram\n");
    while (i < 13*13*32+7){

    	//printf("i: %d\n", i);

    	for (j = 0; j < 10; j++){
    		//fscanf(weights, "%lf", &t);
    		//temp = comp2(t);

    		//temp = weight[i][j];

			if(rand() % 2) temp = rand() % 2048; // 0. ...
			else temp = 524288 - rand() % 2048; // -0. ...

            if(16+9+j < 32){
            	Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 1 << (16+9+j));
            }
            else{
            	Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+8, 1 << (16+9+j - 32));
            }
        	Xil_Out32(XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR + 4*i, temp);
        	Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+4, 0);
        	Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR+8, 0);
    	}
    	i++;
    }
    printf("done\n");
    print("Start\n\r");
    Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR, 1);
    data =  Xil_In32(XPAR_IP_0_S00_AXI_BASEADDR);
    printf("start is: %d\n", data);

    while(1){
    	data = Xil_In32(XPAR_IP_0_S00_AXI_BASEADDR+12);
    	if(data)
    		break;
    }

    for(i = 0; i < 10; i++){
    	data = Xil_In32(XPAR_IP_0_S00_AXI_BASEADDR+16+4*i);
    	result[i] = data;
    }

	//reset IP
    Xil_Out32(XPAR_IP_0_S00_AXI_BASEADDR, 0);

    printf("Result: ");
    for(i = 0; i< 10; i++){
     	printf("%d ", result[i]);
    }

    printf("\nProper result: ");
    for(i = 0; i< 10; i++){
     	printf("%lf ", cast(result[i]));
    }

    //fclose(weights);
    //weights = NULL;
    //fclose(image);
    //image = NULL;

    cleanup_platform();
    return 0;
}

