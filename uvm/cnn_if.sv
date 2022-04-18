`ifndef CNN_IF_SV
`define CNN_IF_SV

interface cnn_if (input clk);

   parameter DATA_WIDTH = 32;

   logic [DATA_WIDTH - 1 : 0]  addra;
   logic [DATA_WIDTH - 1 : 0]  dina;
   logic [2*DATA_WIDTH - 1 : 0]  wea;
   logic start;
   
   logic ready;
   logic [DATA_WIDTH - 1 : 0]  r_0;
   logic [DATA_WIDTH - 1 : 0]  r_1;
   logic [DATA_WIDTH - 1 : 0]  r_2;
   logic [DATA_WIDTH - 1 : 0]  r_3;
   logic [DATA_WIDTH - 1 : 0]  r_4;
   logic [DATA_WIDTH - 1 : 0]  r_5;
   logic [DATA_WIDTH - 1 : 0]  r_6;
   logic [DATA_WIDTH - 1 : 0]  r_7;
   logic [DATA_WIDTH - 1 : 0]  r_8;
   logic [DATA_WIDTH - 1 : 0]  r_9;

endinterface : cnn_if

`endif