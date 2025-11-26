class generator;
    transaction tr;
    mailbox mbxgd;

    function new(mailbox mbxgd);
        this.mbxgd = mbxgd;
    endfunction
    
    virtual task run();
        repeat(10)begin
            tr = new();
            tr.randomize();
            mbxgd.put(tr);
            tr.display("GEN");
        end
    endtask
endclass
