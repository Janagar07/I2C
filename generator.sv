class generator;
  packet pkt;
  mailbox mbox;
  function new(mailbox m_box);
    mbox = m_box;
  endfunction
  
  task run();
    repeat(4)begin
    pkt = new();
    pkt.randomize();
    mbox.put(pkt);
    end
  endtask
endclass