interface interf;
  logic clk_in;
  logic reset_in;
  logic [6:0] addr_in;
  logic [7:0] data_in;
  logic write;
  logic sda_in;
  logic i2c_sda_out;
  logic i2c_scl_out;
  logic [7:0] read_out;
 
endinterface
  
                     