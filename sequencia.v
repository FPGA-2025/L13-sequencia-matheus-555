module Sequencia (
    input wire clk,
    input wire rst_n,

    input wire setar_palavra,
    input wire [7:0] palavra,

    input wire start,
    input wire bit_in,

    output reg encontrado
);

    reg [7:0] palavra_armazenada;
    reg [7:0] shift_reg;
    reg ativo;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset síncrono
            palavra_armazenada = 8'b0;
            shift_reg = 8'b0;
            encontrado = 1'b0;
            ativo = 1'b0;
        end 
        else begin
            if (setar_palavra) begin
                // Armazena a nova palavra a ser buscada
                palavra_armazenada = palavra;
                encontrado = 1'b0;
                ativo = 1'b0;
            end 
            else if (start) begin
                // Inicia o processamento da sequência serial
                ativo = 1'b1;
                encontrado = 1'b0;
                shift_reg = {shift_reg[6:0], bit_in};
            end 
            else if (ativo && !encontrado) begin
                // Continua processando bits enquanto ativo e não encontrou
                shift_reg = {shift_reg[6:0], bit_in};
                
                // Compara os últimos 8 bits recebidos com a palavra armazenada
                if (shift_reg == palavra_armazenada) begin
                    encontrado = 1'b1;
                end
            end
        end
    end

endmodule