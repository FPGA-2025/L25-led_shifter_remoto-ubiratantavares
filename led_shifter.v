module LedShifter #(
    parameter CLK_FREQ = 25_000_000
)(
    input wire clk,
    input wire rst_n,
    output wire [7:0] leds
);

    // registro para armazenar o estado atual dos LEDs
    reg [7:0] led_reg;
    
    // contador para controlar o tempo de deslocamento
    reg [31:0] counter;

    // valor inicial dos LEDS
    localparam INITIAL_LEDS = 8'h1F; // 0b00011111

    // inicializa registrador e contador
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset: inicializa com 0x1F e zera o contador
            led_reg <= INITIAL_LEDS;
            counter <= 0;
        end else begin
            // incrementa o contador
            if (counter == (CLK_FREQ -1)) begin
                // realiza o deslocamento circular para a esquerda
                led_reg <= {led_reg[6:0], led_reg[7]};
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end
    end
    
    // atribui o valor do registro à saída
    assign leds = led_reg;

endmodule
