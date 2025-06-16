`timescale 1ns/1ps

module tb();

    // Frequência reduzida para simulação rápida
    localparam CLK_FREQ = 8; // reduzido
    localparam ONE_SECOND = CLK_FREQ;

    reg clk;
    reg rst_n;
    wire [7:0] leds;

    // Instancia o módulo LedShifter
    LedShifter #(
        .CLK_FREQ (CLK_FREQ)
    ) dut (
        .clk   (clk),
        .rst_n (rst_n),
        .leds  (leds)
    );

    // Geração de clock (2ns de período)
    initial clk = 0;
    always #1 clk = ~clk;

    initial begin
        $dumpfile("saida.vcd");
        $dumpvars(0, tb);

        // TESTE 1: Reset e valor inicial
        rst_n = 0;
        #5;
        rst_n = 1;
        #(1); // espera 1 ciclo após reset
        if (leds == 8'h1F)
            $display("OK");
        else
            $display("ERRO: valor obtido: %h, valor experado: %h", leds, 8'h1F);

        // TESTE 2: 1 rotação (deveria ser 0x3E)
        #(ONE_SECOND * 2); // tempo para uma troca (CLK_FREQ / 4 * 1 = 2 ciclos)
        if (leds == 8'h3E)
            $display("OK");
        else
            $display("ERRO: valor obtido: %h, valor experado: %h", leds, 8'h3E);

        // TESTE 3: 2 rotações (deveria ser 0x7C)
        #(ONE_SECOND * 2);
        if (leds == 8'h7C)
            $display("OK");
        else
            $display("ERRO: valor obtido: %h, valor experado: %h", leds, 8'h7C);

        // TESTE 4: 3 rotações (deveria ser 0xF8)
        #(ONE_SECOND * 2);
        if (leds == 8'hF8)
            $display("OK");
        else
            $display("ERRO: valor obtido: %h, valor experado: %h", leds, 8'hF8);

        // TESTE 5: 4 rotações (deveria ser 0xF1)
        #(ONE_SECOND * 2);
        if (leds == 8'hF1)
            $display("OK");
        else
            $display("ERRO: valor obtido: %h, valor experado: %h", leds, 8'hF1);

        $finish;
    end

endmodule
