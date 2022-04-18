`ifndef CNN_DIN_DRIVER_SV
`define CNN_DIN_DRIVER_SV

class cnn_din_driver extends uvm_driver#(cnn_din_seq_item);

   `uvm_component_utils(cnn_din_driver)
   
   virtual interface cnn_if vif;
   
   typedef enum {send_img, send_conv, send_weights, wait_for_resp} driving_stages;
   driving_stages cnn_driving_stages = send_img;

   parameter DATA_WIDTH = 32;
   parameter IMG_SIZE = 28;

   real data;
   int data_int;
   logic [DATA_WIDTH - 1 : 0] cast_data;
   logic [2*DATA_WIDTH - 1 : 0] enable;
   int counter = 0;
   int p[16] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
   int c[9] = {0,0,0,0,0,0,0,0,0};
   int w[10] = {0,0,0,0,0,0,0,0,0,0};
   int i;
   int j;
   int a;
   int b;

   int fp;
   string weight_path = "../data/weights.txt";
   int temp;
   
   //string input_path = "../data/input.txt";

   function new(string name = "cnn_din_driver", uvm_component parent = null);
      super.new(name,parent);
      if (!uvm_config_db#(virtual cnn_if)::get(this, "", "cnn_if", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set:",get_full_name(),".vif"})
   endfunction

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      if (!uvm_config_db#(virtual cnn_if)::get(this, "", "cnn_if", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
   endfunction : connect_phase
   
   task main_phase(uvm_phase phase);
      //conv and weights
      fp = $fopen(weight_path,"r");
      if (fp) begin
          `uvm_info(get_type_name(), $sformatf("File opened successfuly: %d\n", fp), UVM_LOW)
      end
      else begin 
          `uvm_info(get_type_name(), $sformatf("Failed to open file: %d\n", fp), UVM_LOW)
      end
      for(int k = 0; k < 32; k++) begin
         for(int l = 0; l < 9; l++) begin
            $fscanf(fp, "%f", data);
            data = data * 2048;
            data_int = data;
            cast_data = data_int;
            @(posedge vif.clk);
            #1
            vif.addra = c[l];
            c[l]++;
            vif.dina = cast_data;
            vif.wea = 2**(16+l);
         end
      end
      
      for(int k = 0; k < 7; k++) begin //initial 7 zeros for pipeline
         for(int l = 0; l < 10; l++) begin
            @(posedge vif.clk);
            #1
            vif.addra = w[l];
            w[l]++;
            vif.dina = 0;
            vif.wea = 2**(25+l);
         end
      end
      for(int k = 0; k < 13*13*32; k++) begin
         for(int l = 0; l < 10; l++) begin
            $fscanf(fp, "%f", data);
            data = data * 2048;
            data_int = data;
            cast_data = data_int;
            @(posedge vif.clk);
            #1
            vif.addra = w[l];
            w[l]++;
            vif.dina = cast_data;
            vif.wea = 2**(25+l);
         end
      end
      $fclose(fp);

      //fp = $fopen(input_path,"w");
      //if (fp) begin
      //    `uvm_info(get_type_name(), $sformatf("File opened successfuly: %d\n", fp), UVM_LOW)
      //end
      //else begin 
      //    `uvm_info(get_type_name(), $sformatf("Failed to open file: %d\n", fp), UVM_LOW)
      //end

      forever begin
         //if(vif.start == 0) begin //wait for start
         //   @vif.start
         //end
         seq_item_port.get_next_item(req);

         //$fwrite(fp, "%d ", req.img_val);

         `uvm_info(get_type_name(), $sformatf("Driver sending...\n%s", req.sprint()), UVM_HIGH)
         // do actual driving here
         i = counter / 28;
         j = counter % 28;
         a = i & 1;
         b = j & 1;

         //if(counter < 28*28) begin
            if(a == 0) begin
               if(b == 0) begin
                  if(i != IMG_SIZE - 2 && j != IMG_SIZE - 2) begin
                     @(posedge vif.clk);
                     #1
                     vif.addra = p[0];
                     p[0]++;
                     vif.dina = req.img_val;
                     vif.wea = 2**0;
                  end
                  if(i != IMG_SIZE - 2 && j != 0) begin
                     @(posedge vif.clk);
                     #1
                     vif.addra = p[2];
                     p[2]++;
                     vif.dina = req.img_val;
                     vif.wea = 2**2;
                  end
                  if(i != 0 && j != IMG_SIZE - 2) begin
                     @(posedge vif.clk);
                     #1
                     vif.addra = p[8];
                     p[8]++;
                     vif.dina = req.img_val;
                     vif.wea = 2**8;
                  end
                  if(i != 0 && j != 0) begin
                     @(posedge vif.clk);
                     #1
                     vif.addra = p[10];
                     p[10]++;
                     vif.dina = req.img_val;
                     vif.wea = 2**10;
                  end
               end
               else begin
                  if(i != IMG_SIZE - 2 && j != IMG_SIZE - 1) begin
                     @(posedge vif.clk);
                     #1
                     vif.addra = p[1];
                     p[1]++;
                     vif.dina = req.img_val;
                     vif.wea = 2**1;
                  end
                  if(i != 0 && j != IMG_SIZE - 1) begin
                     @(posedge vif.clk);
                     #1
                     vif.addra = p[9];
                     p[9]++;
                     vif.dina = req.img_val;
                     vif.wea = 2**9;
                  end
                  if(i != IMG_SIZE - 2 && j != 1) begin
                     @(posedge vif.clk);
                     #1
                     vif.addra = p[3];
                     p[3]++;
                     vif.dina = req.img_val;
                     vif.wea = 2**3;
                  end
                  if(i != 0 && j != 1) begin
                     @(posedge vif.clk);
                     #1
                     vif.addra = p[11];
                     p[11]++;
                     vif.dina = req.img_val;
                     vif.wea = 2**11;
                  end
               end
            end
            else begin
               if(b == 0) begin
                  if(i != IMG_SIZE - 1 && j != IMG_SIZE - 2) begin
                     @(posedge vif.clk);
                     #1
                     vif.addra = p[4];
                     p[4]++;
                     vif.dina = req.img_val;
                     vif.wea = 2**4;
                  end
                  if(i != 1 && j != IMG_SIZE - 2) begin
                     @(posedge vif.clk);
                     #1
                     vif.addra = p[12];
                     p[12]++;
                     vif.dina = req.img_val;
                     vif.wea = 2**12;
                  end
                  if(i != IMG_SIZE - 1 && j != 0) begin
                     @(posedge vif.clk);
                     #1
                     vif.addra = p[6];
                     p[6]++;
                     vif.dina = req.img_val;
                     vif.wea = 2**6;
                  end
                  if(i != 1 && j != 0) begin
                     @(posedge vif.clk);
                     #1
                     vif.addra = p[14];
                     p[14]++;
                     vif.dina = req.img_val;
                     vif.wea = 2**14;
                  end
               end
               else begin
                  if(i != IMG_SIZE - 1 && j != IMG_SIZE - 1) begin
                     @(posedge vif.clk);
                     #1
                     vif.addra = p[5];
                     p[5]++;
                     vif.dina = req.img_val;
                     vif.wea = 2**5;
                  end
                  if(i != 1 && j != IMG_SIZE - 1) begin
                     @(posedge vif.clk);
                     #1
                     vif.addra = p[13];
                     p[13]++;
                     vif.dina = req.img_val;
                     vif.wea = 2**13;
                  end
                  if(i != IMG_SIZE - 1 && j != 1) begin
                     @(posedge vif.clk);
                     #1
                     vif.addra = p[7];
                     p[7]++;
                     vif.dina = req.img_val;
                     vif.wea = 2**7;
                  end
                  if(i != 1 && j != 1) begin
                     @(posedge vif.clk);
                     #1
                     vif.addra = p[15];
                     p[15]++;
                     vif.dina = req.img_val;
                     vif.wea = 2**15;
                  end
               end
            end
         //end
         counter++;
         //else begin
         if (counter == 28*28) begin
            @(posedge vif.clk);
            #1
            vif.wea = 0;
            vif.start = 1;
            //$fclose(fp);
         end
         //end
         seq_item_port.item_done();
      end
   endtask : main_phase

endclass : cnn_din_driver

`endif
