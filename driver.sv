class driver;
  packet pkt;
  mailbox mbox;
  virtual interf vif;

  function new(mailbox m_box, virtual interf inter);
    mbox = m_box;
    vif  = inter;
  endfunction

  // --------------------------------------------
  // RESET
  // --------------------------------------------
  task reset_the_dut();
    vif.reset_in <= 1;
    vif.addr_in  <= 0;
    vif.data_in  <= 0;
    vif.write    <= 0;
    vif.sda_in   <= 1'b1;
    repeat (2) @(negedge vif.clk_in);
    vif.reset_in <= 0;
  endtask

  // --------------------------------------------
  // WAIT FOR BUS IDLE
  // --------------------------------------------
  task wait_idle();
    wait (vif.i2c_scl_out == 1 && vif.i2c_sda_out == 1);
  endtask

  // --------------------------------------------
  // WRITE TRANSACTION
  // --------------------------------------------
  task do_write(packet pkt);
    int bit_cnt;

    wait_idle();

    vif.addr_in <= pkt.addr;
    vif.data_in <= pkt.data;
    vif.write   <= 0;

    bit_cnt = 0;

    forever begin
      @(negedge vif.i2c_scl_out);
      bit_cnt++;

      if (bit_cnt == 9 || bit_cnt == 18)
        vif.sda_in <= 1'b0;   // ACK
      else
        vif.sda_in <= 1'b1;

      if (bit_cnt == 18)
        break;
    end

    @(negedge vif.i2c_scl_out);
    vif.sda_in <= 1'b1;

    $display("WRITE DONE : addr=%0h data=%0h", pkt.addr, pkt.data);
  endtask

  // --------------------------------------------
  // READ TRANSACTION
  // --------------------------------------------
  task do_read(packet pkt);
    int bit_cnt;
    int data_bit;

    wait_idle();

    vif.addr_in <= pkt.addr;
    vif.write   <= 1;

    bit_cnt  = 0;
    data_bit = 7;

    forever begin
      @(negedge vif.i2c_scl_out);
      bit_cnt++;

      if (bit_cnt == 9)
        vif.sda_in <= 1'b0;     // Address ACK

      else if (bit_cnt > 9 && bit_cnt <= 17) begin
        vif.sda_in <= pkt.data[data_bit];
        data_bit--;
      end

      else if (bit_cnt == 18) begin
        vif.sda_in <= 1'b1;     // NACK
        break;
      end
      else
        vif.sda_in <= 1'b1;
    end

    wait_idle();
    $display("READ DONE : addr=%0h read_out=%0h",
              pkt.addr, vif.read_out);
  endtask

  // --------------------------------------------
  // WRITE → REPEATED START → READ
  // --------------------------------------------
  task do_write_read(packet pkt);
    int bit_cnt;
    int data_bit;

    // -------- WRITE --------
    do_write(pkt);

    // -------- REPEATED START --------
    wait (vif.i2c_scl_out == 1);
    vif.sda_in <= 1'b1;
    @(negedge vif.clk_in);
    vif.sda_in <= 1'b0;

    // -------- READ --------
    vif.write <= 1;
    bit_cnt  = 0;
    data_bit = 7;

    forever begin
      @(negedge vif.i2c_scl_out);
      bit_cnt++;

      if (bit_cnt == 9)
        vif.sda_in <= 1'b0;

      else if (bit_cnt > 9 && bit_cnt <= 17) begin
        vif.sda_in <= pkt.data[data_bit];
        data_bit--;
      end

      else if (bit_cnt == 18) begin
        vif.sda_in <= 1'b0;
        break;
      end
      else
        vif.sda_in <= 1'b1;
    end

    @(negedge vif.i2c_scl_out);
    vif.sda_in <= 1'b1;

    wait_idle();
    $display("WRITE to READ DONE : addr=%0h data=%0h read_out=%0h",
              pkt.addr, pkt.data, vif.read_out);
  endtask

  // --------------------------------------------
  // MAIN RUN
  // --------------------------------------------
  task run();
    reset_the_dut();

    forever begin
      mbox.get(pkt);

      case (pkt.txn_type)
        WRITE_ONLY  : do_write(pkt);
        READ_ONLY   : do_read(pkt);
        WRITE_READ  : do_write_read(pkt);
      endcase
    end
  endtask

endclass
