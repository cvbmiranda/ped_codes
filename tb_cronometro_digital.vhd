library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  -- Biblioteca padrão recomendada

entity tb_cronometro_digital is
end tb_cronometro_digital;

architecture Behavioral of tb_cronometro_digital is
    signal clk_tb    : STD_LOGIC := '0';
    signal reset_tb  : STD_LOGIC := '0';
    signal start_tb  : STD_LOGIC := '0';
    signal seg_tb    : STD_LOGIC_VECTOR(6 downto 0);
    signal min_tb    : STD_LOGIC_VECTOR(6 downto 0);
    signal anodo_tb  : STD_LOGIC_VECTOR(2 downto 0);

    component cronometro_digital
        Port ( clk      : in  STD_LOGIC;
               reset    : in  STD_LOGIC;
               start    : in  STD_LOGIC;
               seg_out  : out STD_LOGIC_VECTOR(6 downto 0);
               min_out  : out STD_LOGIC_VECTOR(6 downto 0);
               anodo    : out STD_LOGIC_VECTOR(2 downto 0));
    end component;

begin
    -- Instanciação do cronômetro digital
    UUT: cronometro_digital
        port map ( clk      => clk_tb,
                   reset    => reset_tb,
                   start    => start_tb,
                   seg_out  => seg_tb,
                   min_out  => min_tb,
                   anodo    => anodo_tb );

    -- Processo para gerar o clock (50 MHz)
    process
    begin
        while now < 10 ms loop  -- Simulação por 10 ms
            clk_tb <= '0';
            wait for 10 ns;
            clk_tb <= '1';
            wait for 10 ns;
        end loop;
        wait;
    end process;

    -- Teste de inicialização, start, stop e reset
    process
    begin
        -- Inicializa com reset ativado
        reset_tb <= '1';
        wait for 50 ns;
        reset_tb <= '0';

        -- Inicia o cronômetro
        wait for 50 ns;
        start_tb <= '1';
        wait for 50 ns;
        start_tb <= '0';

        -- Espera um tempo e pausa o cronômetro
        wait for 1 ms;
        start_tb <= '1';
        wait for 50 ns;
        start_tb <= '0';

        -- Reseta e testa novamente
        wait for 1 ms;
        reset_tb <= '1';
        wait for 50 ns;
        reset_tb <= '0';

        wait;
    end process;
end Behavioral;
