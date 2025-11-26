class generator;
    transaction tr;
    mailbox mbxgd;

    function new(mailbox mbxgd);
        this.mbxgd = mbxgd;
    endfunction
    
    task run();
        repeat(10)begin
            tr = new();
            tr.randomize();
            mbxgd.put(tr);
            tr.display("GEN");
            #1;
        end
    endtask
endclass