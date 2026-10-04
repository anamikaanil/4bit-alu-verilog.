`timescale 1ns/1ps
module alu_4bit_tb;
    reg  [3:0] a, b;
    reg  [2:0] op;
    wire [3:0] result;
    wire       carry, zero;
    reg  [4:0] expected;
    integer i, j, k, errors;

    alu_4bit dut (.a(a), .b(b), .op(op),
                  .result(result), .carry(carry), .zero(zero));

    initial begin
        $dumpfile("alu.vcd");
        $dumpvars(0, alu_4bit_tb);
        errors = 0;

        
        for (k = 0; k < 8; k = k + 1)
            for (i = 0; i < 16; i = i + 1)
                for (j = 0; j < 16; j = j + 1) begin
                    op = k; a = i; b = j;
                    #1;
                    case (op)
                        3'b000: expected = a + b;
                        3'b001: expected = a - b;
                        3'b010: expected = {1'b0, a & b};
                        3'b011: expected = {1'b0, a | b};
                        3'b100: expected = {1'b0, a ^ b};
                        3'b101: expected = {1'b0, ~a};
                        3'b110: expected = {1'b0, a[2:0], 1'b0};
                        3'b111: expected = {2'b00, a[3:1]};
                    endcase
                    if ({carry, result} !== expected ||
                        zero !== (expected[3:0] == 4'b0)) begin
                        errors = errors + 1;
                        $display("FAIL: op=%b a=%d b=%d -> carry=%b result=%d",
                                 op, a, b, carry, result);
                    end
                end

        if (errors == 0) $display("PASS: all 2048 tests passed");
        else             $display("FAILED: %0d errors", errors);
        $finish;
    end
endmodule
