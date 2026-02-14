class environment;
  generator gen;
  driver drv;
  mailbox mbox;
  
  function new(virtual interf in);
    mbox = new();
    gen = new(mbox);
    drv = new(mbox, in);
  endfunction
  
  task run();
    fork
      gen.run();
      drv.run();
    join_none
  endtask
endclass
    