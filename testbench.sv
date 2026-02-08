`include "interface.sv"
`include "packet.sv"
`include "generator.sv"
`include "driver.sv"
`include "environment.sv"
`include "test.sv"

module top;

  // Interface instance
  interf i();

  // DUT
  i2c_master dut (
      .addr_in(i.addr_in),
      .data_in(i.data_in),
      .write(i.write),
      .clk_in(i.clk_in),
      .reset_in(i.reset_in),
      .sda_in(i.sda_in),
      .i2c_sda_out(i.i2c_sda_out),
      .i2c_scl_out(i.i2c_scl_out),
      .read_out(i.read_out)
  );

  // Test handle
  test t;

  // Clock generation
  initial i.clk_in = 0;
  always #5 i.clk_in = ~i.clk_in;


initial begin
    t = new(i);
    t.run();
    #1000;
    $finish;
  end

  // VCD dump
  initial begin
    $dumpfile("i2c_master.vcd");
    $dumpvars();
  end

endmodule
