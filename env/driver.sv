class driver;
    virtual alu_interface.master vif;
    transaction tr;
    mailbox mbxgd;
  
  function new(virtual alu_interface.master vif,mailbox mbxgd);
        this.vif    = vif;
        this.mbxgd  = mbxgd;
    endfunction
    
    task run();
        forever begin
            mbxgd.get(tr);
            
            vif.cb.operand_a   <= tr.operand_a;
            vif.cb.operand_b   <= tr.operand_b;
            vif.cb.opcode      <= tr.opcode;
            
            tr.display("DRV");
            
          @(posedge vif.clk);
        end
    endtask
endclass