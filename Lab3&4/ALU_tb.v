`timescale 1ns/1ps
module TOP_MODULE_tb;

  // Parameters
  localparam WIDTH      = 20;
  localparam ADDR_WIDTH = 8;
  localparam ALU_OUT    = 8;

  // Ports
  reg                    clk_tb;
  reg                    rst_n_tb;
  reg                    wr_en_tb;
  reg  [ADDR_WIDTH-1:0]  addr_tb;
  reg  [WIDTH-1:0]       din_tb;
  wire [ALU_OUT-1:0]     out_tb;
  wire                   a_is_zero_tb;

  // Instantitantion
  TOP_MODULE DUT (
    .clk        (clk_tb),
    .rst_n      (rst_n_tb),
    .wr_en      (wr_en_tb),
    .addr       (addr_tb),
    .din        (din_tb),
    .out        (out_tb),
    .a_is_zero  (a_is_zero_tb)
  );
  
  always #5 clk_tb=~clk_tb;
  
  initial begin
    
    clk_tb=0;
    addr_tb=0;
    din_tb=0;
    
    rst_n_tb = 0;
wr_en_tb = 0;

repeat(2) @(posedge clk_tb);

// Release reset
rst_n_tb = 1;

// Immediately prepare the write BEFORE the next posedge
wr_en_tb = 1;
addr_tb  = 1;                          // <-- CHANGED: addr 0 -> addr 1
din_tb   = {1'b1,3'b000,8'd3,8'd2};

@(posedge clk_tb);   // RAM writes here

wr_en_tb = 0;
    $display("RAM[1] = %b", DUT.U1.mem[1]);   // <-- relabeled to match addr 1

    // Pass 1: PISO's default post-reset read of addr 0 (stale zeros) ? let it finish
    @(posedge DUT.en);

    // Pass 2: PISO now moves to addr 1, where our real data is waiting
    @(posedge DUT.en);
#1;
$display("OUT = %0d", out_tb);
$display("ZERO = %0b", a_is_zero_tb);
$display("RAM valid      = %b", DUT.ram_valid);
$display("RAM dout       = %b", DUT.ram_dout);

$display("PISO en        = %b", DUT.en);
$display("PISO valid     = %b", DUT.PISO_valid);
$display("PISO addr      = %d", DUT.piso_addr);

$display("Parallel out   = %b", DUT.parallel_out);

$display("ALU out        = %d", out_tb);
    $display("wr_en=%b rd_en=%b", wr_en_tb, DUT.en);
    
    $display("loading = %b", DUT.U2.loading);
$display("count   = %0d", DUT.U2.count);
    
    $stop;
  
  
  end

 
 
 
 endmodule