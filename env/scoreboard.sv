class scoreboard #(int WIDTH=8, int DEPTH=3);
    transaction tr;
    mailbox mbxms;
    
    logic [WIDTH:0] y_exp; 
    logic carry_exp, zero_exp, overflow_exp;
    localparam SHAMT = $clog2(WIDTH);
    
    function new(mailbox mbxms);
        this.mbxms = mbxms;
    endfunction
  
    function automatic void predict(
        input  logic [WIDTH-1:0] a,
        input  logic [WIDTH-1:0] b,
        input  logic [DEPTH-1:0] opcode,
        output logic [WIDTH-1:0] y_exp,
        output logic carry_exp,
        output logic zero_exp,
        output logic overflow_exp
    );
        logic [WIDTH:0] temp;
        temp        = 0;
        y_exp       = 0;
        carry_exp   = 0;
        zero_exp    = 0;
        overflow_exp= 0;
        
        case(opcode)
            3'b000 : begin
                temp = a + b;
                y_exp = temp[WIDTH-1:0];
                carry_exp = temp[WIDTH];
                overflow_exp = (a[WIDTH-1] == b[WIDTH-1] && y_exp[WIDTH-1] != a[WIDTH-1]);
            end
            3'b001 : begin
                temp = a - b;
                y_exp = temp[WIDTH-1:0];
                carry_exp = temp[WIDTH];
                overflow_exp = (a[WIDTH-1] != b[WIDTH-1] && y_exp[WIDTH-1] != a[WIDTH-1]);
            end
            3'b010: y_exp = a & b;
            3'b011: y_exp = a | b;
            3'b100: y_exp = ~(a | b);
            3'b101: y_exp = a << b[SHAMT-1:0];
            3'b110: y_exp = a >> b[SHAMT-1:0];
            3'b111: y_exp = (a==b);
            default: y_exp = 0;
        endcase
        
        zero_exp = (y_exp == 0);
    endfunction
  
  task run();
      $display("[SOC] Scoreboard started!");
    forever begin
      mbxms.get(tr);
      predict(tr.operand_a, tr.operand_b, tr.opcode, y_exp, carry_exp, zero_exp, overflow_exp);
      
      if(tr.y !== y_exp || tr.carry !== carry_exp ||
         tr.zero !== zero_exp || tr.overflow !== overflow_exp) begin
        $display("Mismatch! OPCODE=%0b A=%0d B=%0d | DUT: Y=%0d C=%0b Z=%0b O=%0b | EXP: Y=%0d C=%0b Z=%0b O=%0b",
                 tr.opcode, tr.operand_a, tr.operand_b,
                 tr.y, tr.carry, tr.zero, tr.overflow,
                 y_exp, carry_exp, zero_exp, overflow_exp);
      end else begin
        $display("Match! OPCODE=%0b A=%0d B=%0d | Y=%0d C=%0b Z=%0b O=%0b",
                 tr.opcode, tr.operand_a, tr.operand_b,
                 tr.y, tr.carry, tr.zero, tr.overflow);
      end
    end
  endtask
endclass
