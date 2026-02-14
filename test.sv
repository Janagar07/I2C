class test;
  environment env;
  virtual interf vif;
  function new(virtual interf in);
    vif = in;
    env = new(vif);
  endfunction
  
  virtual task run();
    env.run();
  endtask
endclass

/*class single_read extends test;
  function new(virtual interf in);
    super.new(in);
  endfunction
  
  task run();
    packet pkt = new();
    pkt.randomize with {pkt.write == 0;};
    env.gen.send(pkt);
  endtask
endclass

class single_write extends test;
   function new(virtual interf in);
    super.new(in);
   endfunction
  task run();
    packet pkt = new();
    pkt.write = 1; pkt.send_ack = 0;
    env.gen.send(pkt);
  endtask
endclass

class write_nack extends test;
   function new(virtual interf in);
    super.new(in);
   endfunction
  task run();
    packet pkt = new();
    pkt.write = 0; pkt.send_ack = 0;
    env.gen.send(pkt);
  endtask
endclass

class read_ack extends test;
   function new(virtual interf in);
    super.new(in);
   endfunction
  task run();
    packet pkt = new();
    pkt.write = 1; pkt.send_ack = 1;
    env.gen.send(pkt);
  endtask
endclass//

class repeated_start extends test;
   function new(virtual interf in);
    super.new(in);
   endfunction
  task run();
    packet pkt = new();
    pkt.write = 0; pkt.repeated_start = 1;
    env.gen.send(pkt);
  endtask
endclass//

class random_write extends test;
   function new(virtual interf in);
    super.new(in);
   endfunction
  task run();
    packet pkt = new();
    pkt.write = 0; pkt.randomize();
    env.gen.send(pkt);
  endtask
endclass//

class random_read extends test;
   function new(virtual interf in);
    super.new(in);
   endfunction
  task run();
    packet pkt = new();
    pkt.write = 1;  pkt.randomize();
    env.gen.send(pkt);
  endtask
endclass

class back_to_back extends test;
   function new(virtual interf in);
    super.new(in);
   endfunction
  task run();
    repeat(2) begin
    packet pkt = new();
    pkt.randomize();
    env.gen.send(pkt);
    end
  endtask
endclass//

class address_boundry extends test;
   function new(virtual interf in);
    super.new(in);
   endfunction
  task run();
    packet pkt = new();
    pkt.addr = 7'b1010011;
    env.gen.send(pkt);
  endtask
endclass

class data_zero extends test;
   function new(virtual interf in);
    super.new(in);
   endfunction
  task run();
    packet pkt = new();
    pkt.data = 0;
    env.gen.send(pkt);
  endtask
endclass//

class max_data extends test;
   function new(virtual interf in);
    super.new(in);
   endfunction
  task run();
    packet pkt = new();
    pkt.data = 8'b10101100;
    env.gen.send(pkt);
  endtask
endclass

class stress extends test;
   function new(virtual interf in);
    super.new(in);
   endfunction
  task run();
    repeat(5) begin
    packet pkt = new();
    pkt.randomize();
    env.gen.send(pkt);
    end
  endtask
endclass*/




    