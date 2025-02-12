library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_cronometro_digital is
end tb_cronometro_digital;

architecture Behavioral of tb_cronometro_digital is
    -- Declaração dos sinais para conexão com a UUT (Unidade sob Teste)
    signal clk         : STD_LOGIC := '0';
    signal rst         : STD_LOGIC := '1';
    signal start_stop  : STD_LOGIC := '1';
    signal display     : STD_LOGIC_VECTOR(6 downto 0);
    signal anode       : STD_LOGIC_VECTOR(2 downto 0);
    signal btn_debounced : STD_LOGIC := '1';
    
    -- Constante para simular o clock (50 MHz)
    constant clk_period : time := 20 ns; -- 50 MHz = 20 ns de período

begin
    -- Instância do cronômetro (Unidade Sob Teste - UUT)
    uut: entity work.cronometro_digital
        port map (
            clk => clk,
            rst => rst,
            start_stop => start_stop,
            display => display,
            anode => anode,
            btn_debounced => btn_debounced
        );

    -- Processo para gerar o clock
    process
    begin
        while now < 500 ms loop -- Simulação por 500 ms
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

    -- Processo para simular o funcionamento do cronômetro
    process
    begin
        -- Reset inicial
        rst <= '0';
        wait for 50 ns;
        rst <= '1';

        -- Simula pressionamento do botão para iniciar a contagem
        wait for 100 ns;
        btn_debounced <= '0';
        wait for 50 ns;
        btn_debounced <= '1';

        -- Aguarda alguns segundos para verificar a contagem
        wait for 5 sec;

        -- Simula pressionamento do botão para parar a contagem
        btn_debounced <= '0';
        wait for 50 ns;
        btn_debounced <= '1';

        -- Aguarda um tempo para verificar se parou
        wait for 2 sec;

        -- Simula reset para ver se volta ao zero
        rst <= '0';
        wait for 50 ns;
        rst <= '1';

        -- Finaliza simulação
        wait;
    end process;

end Behavioral;
