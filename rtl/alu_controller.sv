module #(
    parameter WIDTH=8,
    parameter DEPTH=3
    )(
  	input   logic [WIDTH-1:0] operand_a,
  	input   logic [WIDTH-1:0] operand_b,
  	input   logic [DEPTH-1:0] opcode,
	output  logic             carry,
  	output  logic             zero,
  	output  logic             overflow,
    output  logic [WIDTH-1:0] y
);
  
    reg [WIDTH:0] temp;
    localparam SHAMT = $clog2(WIDTH);
  
    always @(*) begin
        temp = 0;
        y 	 = 0;
        case(opcode)
            3'b000 :begin
                     temp =operand_a + operand_b;
                     y = temp[WIDTH-1 :0];
                    end
            3'b001 : begin
                     temp = operand_a - operand_b;
                     y = temp[WIDTH-1:0];
                     end
            3'b010 : y = operand_a & operand_b;
            3'b011 : y = operand_a | operand_b;
            3'b100 : y =~(operand_a | operand_b);
            3'b101 : y = operand_a << operand_b[SHAMT-1:0];
            3'b110 : y = operand_a >> operand_b[SHAMT-1:0];
            3'b111 : y =(operand_a == operand_b);
            default: y = '0;
        endcase
    end
    assign zero 		= (y==0);
    assign carry 		= temp[WIDTH];
    assign overflow 	= ((opcode == 3'b000 || opcode == 3'b001) && 
                          (operand_a[WIDTH-1] == operand_b[WIDTH-1]) &&
                          (y[WIDTH-1] != operand_a[WIDTH-1]));
  
endmodule 