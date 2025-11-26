interface alu_interface #(
  parameter int WIDTH = 8,
  parameter int DEPTH = 3
);
  logic 			clk;
  logic [WIDTH-1:0] operand_a;
  logic [WIDTH-1:0] operand_b;
  logic [DEPTH-1:0] opcode;
  logic [WIDTH-1:0] y;
  logic 			carry;
  logic				zero;
  logic 			overflow;
  
   clocking cb @(posedge clk);
    default input #1 output #1;

    output operand_a, operand_b, opcode;
    input  y, carry, zero, overflow;
  endclocking

  modport master  (clocking cb);
  modport monitor (input operand_a, operand_b, opcode,
                   input y, carry, zero, overflow);
  modport slave (input operand_a,operand_b,opcode, output carry,zero,overflow,y);
  
endinterface