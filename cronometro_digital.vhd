library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  -- Biblioteca padrão recomendada

entity cronometro_digital is
    Port ( clk      : in  STD_LOGIC;  -- Clock principal da FPGA
           reset    : in  STD_LOGIC;  -- Botão de reset
           start    : in  STD_LOGIC;  -- Botão de start/stop
           seg_out  : out STD_LOGIC_VECTOR(6 downto 0); -- Display de 7 segmentos
           min_out  : out STD_LOGIC_VECTOR(6 downto 0); -- Display de minutos
           anodo    : out STD_LOGIC_VECTOR(2 downto 0)); -- Anodo para multiplexação dos displays
end cronometro_digital;

architecture Behavioral of cronometro_digital is
    signal clk_div  : STD_LOGIC := '0';  -- Clock dividido (1 Hz)
    signal counter  : UNSIGNED(9 downto 0) := (others => '0');  -- Conta segundos (0 a 599)
    signal running  : STD_LOGIC := '0';  -- Estado de execução (0 = parado, 1 = rodando)

begin
    -- Processo de divisão de clock para gerar pulso de 1Hz
    process(clk)
        variable count : INTEGER := 0;
    begin
        if rising_edge(clk) then
            if count = 50_000_000 then  -- Assume um clock de 50 MHz
                clk_div <= NOT clk_div;
                count := 0;
            else
                count := count + 1;
            end if;
        end if;
    end process;

    -- Processo de controle do cronômetro
    process(clk_div, reset, start)
    begin
        if reset = '1' then
            counter <= (others => '0');
            running <= '0';
        elsif rising_edge(clk_div) then
            if start = '1' then
                running <= NOT running; -- Alterna entre iniciar e parar
            end if;
            
            if running = '1' then
                if counter < 599 then
                    counter <= counter + 1;
                else
                    counter <= (others => '0'); -- Reseta quando chega a 9min 59s
                end if;
            end if;
        end if;
    end process;

    -- Processo para converter valores para display de 7 segmentos
    process(counter)
        variable sec : INTEGER;
        variable min : INTEGER;
    begin
        sec := to_integer(counter) mod 60;
        min := to_integer(counter) / 60;

        -- Implementação simples para converter valores em 7 segmentos (exemplo para 0 e 1)
        case sec mod 10 is
            when 0 => seg_out <= "0111111";
            when 1 => seg_out <= "0000110";
            when others => seg_out <= "0000000";
        end case;

        case min is
            when 0 => min_out <= "0111111";
            when 1 => min_out <= "0000110";
            when others => min_out <= "0000000";
        end case;
    end process;

    -- Controle da multiplexação dos displays
    process(clk)
        variable mux : INTEGER := 0;
    begin
        if rising_edge(clk) then
            mux := (mux + 1) mod 3;
            case mux is
                when 0 => anodo <= "001"; -- Unidade dos segundos
                when 1 => anodo <= "010"; -- Dezenas dos segundos
                when 2 => anodo <= "100"; -- Minutos
                when others => anodo <= "000";
            end case;
        end if;
    end process;
    
end Behavioral;
