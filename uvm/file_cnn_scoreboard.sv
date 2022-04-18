`ifndef CNN_SCOREBOARD_SV
`define CNN_SCOREBOARD_SV

`uvm_analysis_imp_decl(_input)
`uvm_analysis_imp_decl(_output)

class cnn_scoreboard extends uvm_scoreboard;

   // control fileds
   bit checks_enable = 1;
   bit coverage_enable = 1;

   // This TLM port is used to connect the scoreboard to the monitor
   uvm_analysis_imp_input#(cnn_din_seq_item, cnn_scoreboard) port_input;
   uvm_analysis_imp_output#(cnn_dout_seq_item, cnn_scoreboard) port_output;

   //int q = 0;
   //cnn_din_seq_item exp_input_que[784]; //28*28
   //cnn_dout_seq_item exp_output;

   `uvm_component_utils_begin(cnn_scoreboard)
      `uvm_field_int(checks_enable, UVM_DEFAULT)
      `uvm_field_int(coverage_enable, UVM_DEFAULT)
   `uvm_component_utils_end

   logic [18 : 0] image_vec[16][169];
   int count_vec[16];
   logic [18 : 0] mult[32][169][4][9];
   logic [18 : 0] add[32][169][4];
   logic [18 : 0] comp[32][169];
   int i, j, k, n, l, m;

   function new(string name = "cnn_scoreboard", uvm_component parent = null);
      super.new(name,parent);
      port_input = new("port_input", this);
      port_output = new("port_output", this);
      for (i = 0; i < 16; i++) begin
          count_vec[i] = 0;
      end
   endfunction : new

   function write_input (cnn_din_seq_item tr);
      image_vec[tr.pos][count_vec[tr.pos]] = tr.img_val;
      count_vec[tr.pos]++;
      //`uvm_info(get_type_name(), "Recieved pixel\n", UVM_LOW);
   endfunction : write_input
   
   //cnn_dout_seq_item exp_tr;
   int help;
   real a, b;
   real data;
   int data_int;
   logic [18 : 0] temp;
   logic [18 : 0] temp0;
   logic [18 : 0] temp1;
   int counter = 0;
   int fp;
   string weight_path = "../data/weights.txt";
   logic [18 : 0] conv_weights[32][3][3];
   logic [18 : 0] weights[5408][10];
   logic [18 : 0] image[28][28];
   logic [18 : 0] conv[32][26][26];
   logic [18 : 0] pool[32][13][13];
   logic [18 : 0] flat[5408];
   logic [18 : 0] result[10];
   int res_rec[10];
   int res_exp[10];
   int max_ex, max_rec;
   int exact;
   int fl;

   function real comp2 (logic [18 : 0] t);
      if(t < 262144) begin
         return t;
      end
      else begin
         return - (524288 - t);
      end
   endfunction

   function write_output (cnn_dout_seq_item tr);
      `uvm_info(get_type_name(), "Begin referent model\n", UVM_LOW);
      
      //BEGIN REF MODEL

      fp = $fopen(weight_path,"r");
      if (fp) begin
          `uvm_info(get_type_name(), $sformatf("File opened successfuly: %d\n", fp), UVM_LOW)
      end
      else begin 
          `uvm_info(get_type_name(), $sformatf("Failed to open file: %d\n", fp), UVM_LOW)
      end

      for(int i = 0; i < 32; i++) begin
          for(int j = 0; j < 3; j++) begin
              for(int k = 0; k < 3; k++) begin
                  $fscanf(fp, "%f", data); //C style
                  data = data * 2048;
                  data_int = data;
                  conv_weights[i][j][k] = data_int;
              end
          end
      end

      for(int i = 0; i < 13*13*32; i++) begin
          for(int j = 0; j < 10; j++) begin
              $fscanf(fp, "%f", data);
               data = data * 2048;
               data_int = data;
               weights[i][j] = data_int;
          end
      end
      
      //for(j = 0; j < 28; j++) begin
      //    for(k = 0; k < 28; k++) begin
      //        image[j][k] = exp_input_que[28*j + k].img_val[18 : 0];
      //    end
      //end
      
      //for(i = 0; i < 32; i++) begin
      //    for(j = 0; j < 26; j++) begin
      //        for(k = 0; k < 26; k++) begin
      //            conv[i][j][k] = 0;
      //            for(l = 0; l < 3; l++) begin
      //                for(m = 0; m < 3; m++) begin
      //                    a = comp2(image[j+l][k+m]);
      //                    b = comp2(conv_weights[i][l][m]);
      //                    help = a * b;
      //                    help = help / 2048;
      //                    temp = help;
      //                    conv[i][j][k] += temp; //multi be careful
      //                end
      //            end
      //            //relu
      //            if(conv[i][j][k] >= 262144) begin
      //                conv[i][j][k] = 0;
      //            end
      //        end
      //    end
      //end

      //for(i = 0; i < 32; i++) begin
      //    for(j = 0; j < 13; j++) begin
      //        for(k = 0; k < 13; k++) begin
      //            if(conv[i][2*j][2*k] > conv[i][2*j][2*k+1]) begin
      //                temp0 = conv[i][2*j][2*k];
      //            end
      //            else begin
      //                temp0 = conv[i][2*j][2*k+1];
      //            end
      //            if(conv[i][2*j+1][2*k] > conv[i][2*j+1][2*k+1]) begin
      //                temp1 = conv[i][2*j+1][2*k];
      //            end
      //            else begin
      //                temp1 = conv[i][2*j+1][2*k+1];
      //            end
      //            if(temp0 > temp1) begin
      //                pool[i][j][k] = temp0;
      //            end
      //            else begin
      //                pool[i][j][k] = temp1;
      //            end
      //        end
      //    end
      //end

      for (i = 0; i < 32; i++) begin
          for (j = 0; j < 169; j++) begin
             a = comp2(image_vec[0][j]);
             b = comp2(conv_weights[i][0][0]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[0][j] != 0 && conv_weights[i][0][0] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][0][0] = temp;
             
             a = comp2(image_vec[1][j]);
             b = comp2(conv_weights[i][0][1]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[1][j] != 0 && conv_weights[i][0][1] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][0][1] = temp;
             
             a = comp2(image_vec[2][j]);
             b = comp2(conv_weights[i][0][2]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[2][j] != 0 && conv_weights[i][0][2] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][0][2] = temp;
             
             a = comp2(image_vec[4][j]);
             b = comp2(conv_weights[i][1][0]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[4][j] != 0 && conv_weights[i][1][0] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][0][3] = temp;

             a = comp2(image_vec[5][j]);
             b = comp2(conv_weights[i][1][1]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[5][j] != 0 && conv_weights[i][1][1] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][0][4] = temp;
             
             a = comp2(image_vec[6][j]);
             b = comp2(conv_weights[i][1][2]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[6][j] != 0 && conv_weights[i][1][2] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][0][5] = temp;
             
             a = comp2(image_vec[8][j]);
             b = comp2(conv_weights[i][2][0]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[8][j] != 0 && conv_weights[i][2][0] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][0][6] = temp;
             
             a = comp2(image_vec[9][j]);
             b = comp2(conv_weights[i][2][1]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[9][j] != 0 && conv_weights[i][2][1] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][0][7] = temp;
             
             a = comp2(image_vec[10][j]);
             b = comp2(conv_weights[i][2][2]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[10][j] != 0 && conv_weights[i][2][2] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][0][8] = temp;
             
             
             a = comp2(image_vec[1][j]);
             b = comp2(conv_weights[i][0][0]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[1][j] != 0 && conv_weights[i][0][0] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][1][0] = temp;
             
             a = comp2(image_vec[2][j]);
             b = comp2(conv_weights[i][0][1]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[2][j] != 0 && conv_weights[i][0][1] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][1][1] = temp;
             
             a = comp2(image_vec[3][j]);
             b = comp2(conv_weights[i][0][2]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[3][j] != 0 && conv_weights[i][0][2] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][1][2] = temp;
             
             a = comp2(image_vec[5][j]);
             b = comp2(conv_weights[i][1][0]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[5][j] != 0 && conv_weights[i][1][0] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][1][3] = temp;

             a = comp2(image_vec[6][j]);
             b = comp2(conv_weights[i][1][1]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[6][j] != 0 && conv_weights[i][1][1] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][1][4] = temp;
             
             a = comp2(image_vec[7][j]);
             b = comp2(conv_weights[i][1][2]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[7][j] != 0 && conv_weights[i][1][2] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][1][5] = temp;
             
             a = comp2(image_vec[9][j]);
             b = comp2(conv_weights[i][2][0]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[9][j] != 0 && conv_weights[i][2][0] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][1][6] = temp;
             
             a = comp2(image_vec[10][j]);
             b = comp2(conv_weights[i][2][1]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[10][j] != 0 && conv_weights[i][2][1] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][1][7] = temp;
             
             a = comp2(image_vec[11][j]);
             b = comp2(conv_weights[i][2][2]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[11][j] != 0 && conv_weights[i][2][2] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][1][8] = temp;
             
             
             a = comp2(image_vec[4][j]);
             b = comp2(conv_weights[i][0][0]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[4][j] != 0 && conv_weights[i][0][0] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][2][0] = temp;
             
             a = comp2(image_vec[5][j]);
             b = comp2(conv_weights[i][0][1]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[5][j] != 0 && conv_weights[i][0][1] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][2][1] = temp;
             
             a = comp2(image_vec[6][j]);
             b = comp2(conv_weights[i][0][2]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[6][j] != 0 && conv_weights[i][0][2] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][2][2] = temp;
             
             a = comp2(image_vec[8][j]);
             b = comp2(conv_weights[i][1][0]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[8][j] != 0 && conv_weights[i][1][0] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][2][3] = temp;

             a = comp2(image_vec[9][j]);
             b = comp2(conv_weights[i][1][1]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[9][j] != 0 && conv_weights[i][1][1] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][2][4] = temp;
             
             a = comp2(image_vec[10][j]);
             b = comp2(conv_weights[i][1][2]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[10][j] != 0 && conv_weights[i][1][2] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][2][5] = temp;
             
             a = comp2(image_vec[12][j]);
             b = comp2(conv_weights[i][2][0]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[12][j] != 0 && conv_weights[i][2][0] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][2][6] = temp;
             
             a = comp2(image_vec[13][j]);
             b = comp2(conv_weights[i][2][1]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[13][j] != 0 && conv_weights[i][2][1] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][2][7] = temp;
             
             a = comp2(image_vec[14][j]);
             b = comp2(conv_weights[i][2][2]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[14][j] != 0 && conv_weights[i][2][2] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][2][8] = temp;
             
             
             a = comp2(image_vec[5][j]);
             b = comp2(conv_weights[i][0][0]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[5][j] != 0 && conv_weights[i][0][0] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][3][0] = temp;
             
             a = comp2(image_vec[6][j]);
             b = comp2(conv_weights[i][0][1]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[6][j] != 0 && conv_weights[i][0][1] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][3][1] = temp;
             
             a = comp2(image_vec[7][j]);
             b = comp2(conv_weights[i][0][2]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[7][j] != 0 && conv_weights[i][0][2] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][3][2] = temp;
             
             a = comp2(image_vec[9][j]);
             b = comp2(conv_weights[i][1][0]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[9][j] != 0 && conv_weights[i][1][0] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][3][3] = temp;

             a = comp2(image_vec[10][j]);
             b = comp2(conv_weights[i][1][1]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[10][j] != 0 && conv_weights[i][1][1] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][3][4] = temp;
             
             a = comp2(image_vec[11][j]);
             b = comp2(conv_weights[i][1][2]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[11][j] != 0 && conv_weights[i][1][2] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][3][5] = temp;
             
             a = comp2(image_vec[13][j]);
             b = comp2(conv_weights[i][2][0]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[13][j] != 0 && conv_weights[i][2][0] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][3][6] = temp;
             
             a = comp2(image_vec[14][j]);
             b = comp2(conv_weights[i][2][1]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[14][j] != 0 && conv_weights[i][2][1] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][3][7] = temp;
             
             a = comp2(image_vec[15][j]);
             b = comp2(conv_weights[i][2][2]);
             help = a * b;
             exact = help % 2048;
             help = help / 2048;
             temp = help;
             if (image_vec[15][j] != 0 && conv_weights[i][2][2] >= 262144 && exact != 0) begin
                 temp--;
             end
             mult[i][j][3][8] = temp;
          end
      end

      for (i = 0; i < 32; i++) begin
          for (j = 0; j < 169; j++) begin
              for (k = 0; k < 4; k++) begin
                  add[i][j][k] = 0;
                  for (l = 0; l < 9; l++) begin
                    add[i][j][k] += mult[i][j][k][l];
                  end

                  if (add[i][j][k] >= 262144) begin
                      add[i][j][k] = 0;
                  end
                  //else begin
                  //  for (l = 0; l < 3; l++) begin
                  //      for (m = 0; m < 3; m++) begin
                  //        if (conv_weights[i][l][m] >= 262144) begin
                  //            add[i][j][k]--;
                  //        end
                  //      end
                  //  end
                  //end

                  if (add[i][j][0] > add[i][j][1]) begin
                      temp0 = add[i][j][0];
                  end
                  else begin
                      temp0 = add[i][j][1];
                  end
                  if (add[i][j][2] > add[i][j][3]) begin
                      temp1 = add[i][j][2];
                  end
                  else begin
                      temp1 = add[i][j][3];
                  end

                  if (temp0 > temp1) begin
                      comp[i][j] = temp0;
                  end
                  else begin
                      comp[i][j] = temp1;
                  end

              end
          end
      end

      //for(i = 0; i < 32; i++) begin
      //    for(j = 0; j < 13; j++) begin
      //        for(k = 0; k < 13; k++) begin
      //            flat[counter] = pool[i][j][k]; //counter = i*in_size*in_num + j*in_num + k
      //            $display("%d", flat[counter]);
      //            counter++;
      //        end
      //    end
      //end

      for(i = 0; i < 32; i++) begin
          for(j = 0; j < 169; j++) begin
               flat[counter] = comp[i][j]; //counter = i*in_size*in_num + j*in_num + k
               //$display("%d", flat[counter]);
               counter++;
          end
      end

      //$display("%d * %d = %d", image_vec[0][0], conv_weights[0][0][0], mult[0][0][0][0]);
      //$display("%d * %d = %d", image_vec[1][0], conv_weights[0][0][1], mult[0][0][0][1]);
      //$display("%d * %d = %d", image_vec[2][0], conv_weights[0][0][2], mult[0][0][0][2]);
      //$display("%d * %d = %d", image_vec[4][0], conv_weights[0][1][0], mult[0][0][0][3]);
      //$display("%d * %d = %d", image_vec[5][0], conv_weights[0][1][1], mult[0][0][0][4]);
      //$display("%d * %d = %d", image_vec[6][0], conv_weights[0][1][2], mult[0][0][0][5]);
      //$display("%d * %d = %d", image_vec[8][0], conv_weights[0][2][0], mult[0][0][0][6]);
      //$display("%d * %d = %d", image_vec[9][0], conv_weights[0][2][1], mult[0][0][0][7]);
      //$display("%d * %d = %d", image_vec[10][0], conv_weights[0][2][2], mult[0][0][0][8]);
      //$display("Add %d", add[0][0][0]);
      
      for(int i = 0; i < 10; i++) begin
          result[i] = 0;
          for(int j = 0; j < 13*13*32; j++) begin
              a = comp2(flat[j]);
              b = comp2(weights[j][i]);
              help = a * b;
              exact = help % 2048;
              help = help / 2048;
              temp = help;
              if (weights[j][i] >= 262144 && flat[j] != 0 && exact != 0) begin
                  temp--;
              end
              result[i] += temp;
              //if (i == 0) begin
              //  $display("%d %d: %d", i, j, result[0]);
              //end
          end
      end

      for (i = 0; i < 10; i++) begin
          res_exp[i] = comp2(result[i]);
      end

      temp = res_exp[0];
      max_ex = 0;
      for(i = 1; i < 10; i++) begin
          if(temp < res_exp[i]) begin
              temp = res_exp[i];
              max_ex = i;
          end
      end

      res_rec[0] = comp2(tr.r_0);
      res_rec[1] = comp2(tr.r_1);
      res_rec[2] = comp2(tr.r_2);
      res_rec[3] = comp2(tr.r_3);
      res_rec[4] = comp2(tr.r_4);
      res_rec[5] = comp2(tr.r_5);
      res_rec[6] = comp2(tr.r_6);
      res_rec[7] = comp2(tr.r_7);
      res_rec[8] = comp2(tr.r_8);
      res_rec[9] = comp2(tr.r_9);

      temp = res_rec[0];
      max_rec = 0;
      for(i = 1; i < 10; i++) begin
          if(temp < res_rec[i]) begin
              temp = res_rec[i];
              max_rec = i;
          end
      end


      //END REF MODEL

      `uvm_info(get_type_name(), "End referent model\n", UVM_LOW);

      //asrt_tr_compare : assert (tr.compare(exp_tr)) begin 
      //   `uvm_info(get_type_name(), "Expected and received matched\n", UVM_LOW);
      //end
      //else begin
      //   `uvm_error(get_type_name(), "Expected and received mismatched\n");
      //end

      //$display("image[0][0] = %d", image[0][0]);
      //$display("conv_weights[0][0][0] = %d", conv_weights[0][0][0]);
      //$display("weights[0][0] = %d", weights[0][0]);
      //$display("convs[0][0][0] = %d", conv[0][0][0]);
      //$display("pool[0][0][0] = %d", pool[0][0][0]);
      //$display("flat[0] = %d", flat[0]);
      //$display("%f vs %f", res_exp[0]/2048.0, res_rec[0]/2048.0);
      //$display("%f vs %f", res_exp[1]/2048.0, res_rec[1]/2048.0);
      //$display("%f vs %f", res_exp[2]/2048.0, res_rec[2]/2048.0);
      //$display("%f vs %f", res_exp[3]/2048.0, res_rec[3]/2048.0);
      //$display("%f vs %f", res_exp[4]/2048.0, res_rec[4]/2048.0);
      //$display("%f vs %f", res_exp[5]/2048.0, res_rec[5]/2048.0);
      //$display("%f vs %f", res_exp[6]/2048.0, res_rec[6]/2048.0);
      //$display("%f vs %f", res_exp[7]/2048.0, res_rec[7]/2048.0);
      //$display("%f vs %f", res_exp[8]/2048.0, res_rec[8]/2048.0);
      //$display("%f vs %f", res_exp[9]/2048.0, res_rec[9]/2048.0);

      fl = 0;
      for (i = 0; i < 10; i++) begin
          if (res_exp[i] == res_rec[i]) begin
              fl++;
          end
      end

      //asrt_tr_compare : assert (max_ex == max_rec) begin 
      asrt_tr_compare : assert (fl == 10) begin 
         `uvm_info(get_type_name(), "Expected and received matched\n", UVM_LOW);
      end
      else begin
         `uvm_error(get_type_name(), "Expected and received mismatched\n");
      end
      
   endfunction : write_output

   function void report_phase(uvm_phase phase);
      `uvm_info(get_type_name(), $sformatf("CNN scoreboard examined"), UVM_LOW);
   endfunction : report_phase

endclass : cnn_scoreboard

`endif
