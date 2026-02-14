typedef enum {WRITE_ONLY, READ_ONLY, WRITE_READ} txn_t;

class packet;
  rand bit [6:0] addr;
  rand bit [7:0] data;
  rand bit       write;
  rand txn_t     txn_type;

  constraint c1 {
    addr != 0;
    data != 0;
    data != 8'b1;
    txn_type == READ_ONLY;
  }

  function void post_randomize();
    $display("[PKT]addr=%0h data=%0h write=%0b txn=%0s",
              addr, data, write, txn_type.name());
  endfunction
endclass
