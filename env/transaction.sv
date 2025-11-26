class transaction;
  localparam WIDTH = 8;
  localparam DEPTH = 3;
  
  rand bit [WIDTH-1:0] operand_a;
  rand bit [WIDTH-1:0] operand_b;
  rand bit [DEPTH-1:0] opcode;
  	   bit 			   zero;
  	   bit 			   carry;
  	   bit 			   overflow;
       bit [WIDTH-1:0] y;
  
  
  constraint opcode_c {opcode inside {[0:7]};}
  constraint shift_limit {if(opcode inside {3'b101,3'b110}) 
                         operand_b < WIDTH;}
  constraint avoid_equal {if(opcode == 3'b111){
    (operand_a != operand_b);
   }}
  
  function void sprint(string s);
    $display("[%s] opcode=%0b operand_a=%0d operand_b=%0d result=%0d carry=%0b zero=%0b overflow=%0b",s,this.opcode,this.operand_a,this.operand_b,this.y,this.carry,this.zero,this.overflow);
  endfunction
endclass