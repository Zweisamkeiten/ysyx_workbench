module ysyx_22050710_ifu_sram_axi_lite #(
  parameter ADDR_WIDTH = 32,
  parameter DATA_WIDTH = 64
) (
    input                 i_ckl,
    input                 i_reset,

    // AXI-Lite Interface Signals
    // read address channel
    input                   i_arvalid,
    output                  o_arready,
    input  [ADDR_WIDTH-1:0] i_araddr,

    // read data channel
    output                  o_rvalid,
    input                   i_rready,
    output [DATA_WIDTH-1:0] o_rdata,
    output [1:0]            o_rresp

);

  // Internal Signals 
  reg [ADDR_WIDTH-1:0] addr;  // Address Register 

  // Read and Write Data Registers  
  reg [DATA_WIDTH-1:0] readData;   // Read Data Register  

  always @(posedge i_ckl) begin   // Clock Edge Sensitivity  
    if (i_reset) begin   // Reset Logic  
        addr <= 0;   // Initialize Address Register to 0  
        readData <= 0;   // Initialize Read Data Register to 0  
    end
    else begin     // Non Reset Logic    
      if (i_arvalid && i_rready) begin     // Read Request Logic    
        addr <= i_araddr;       // Return Address from Address Register      
        pmem_read(addr, readData);       // Call pmem_read() via DPI-C      
        #1 o_rdata <= readData;       // Delay one cycle to return the read data      
        #1 o_rvalid <= 1'b1;
        #1 o_arready <= 1'b1;
        o_rresp <= 2'b00;
      end
      else begin       // No Request Logic      
        o_arready <= 0;
        o_rdata <= 0;
        o_rvalid <= 0;
        o_rresp <= 2'b00;
      end
    end
  end
endmodule
