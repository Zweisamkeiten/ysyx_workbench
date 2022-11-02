module ps2_keyboard(clk,resetn,ps2_clk,ps2_data, out, chars);
    input clk,resetn,ps2_clk,ps2_data;
    output reg [7:0] out;
    output reg [9:0] chars;

    initial begin
      chars = 0;
    end
    reg [9:0] buffer;        // ps2_data bits
    reg [3:0] count;  // count ps2_data bits
    reg [2:0] ps2_clk_sync;

    always @(posedge clk) begin
        ps2_clk_sync <=  {ps2_clk_sync[1:0],ps2_clk};
    end

    wire sampling = ps2_clk_sync[2] & ~ps2_clk_sync[1];

    always @(posedge clk) begin
        if (resetn == 0) begin // reset
            count <= 0;
        end
        else begin
            if (sampling) begin
              if (count == 4'd10) begin
                if ((buffer[0] == 0) &&  // start bit
                    (ps2_data)       &&  // stop bit
                    (^buffer[9:1])) begin      // odd  parity
                    $display("receive %x", buffer[8:1]);
                    out <= buffer[8:1];
                    if (buffer[8:1] == 8'h5a) chars <= chars + 70 - chars % 70;
                    else begin
                      if (buffer[8:1] == 8'hf0) chars <= chars;
                      else chars <= chars + 1;
                    end
                end
                count <= 0;     // for next
              end else begin
                buffer[count] <= ps2_data;  // store ps2_data
                count <= count + 3'b1;
              end
            end
        end
    end

endmodule
