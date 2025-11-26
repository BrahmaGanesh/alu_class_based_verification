class monitor;
    virtual alu_interface.monitor vif;
    transaction tr;
    mailbox mbxms;
    
    function new(virtual alu_interface.monitor vif,mailbox mbxms);
        this.vif = vif;
        this.mbxms=mbxms;
    endfunction
  
    task run();
        forever begin
            tr=new();
            @(posedge vif.clk);
            
            tr.operand_a 	= vif.operand_a;
            tr.operand_b 	= vif.operand_b;
            tr.opcode 	    = vif.opcode;
            tr.y			= vif.y;
            tr.carry		= vif.carry;
            tr.zero		    = vif.zero;
            tr.overflow	    = vif.overflow;
            
            tr.display("MON");
        end
    endtask
endclass