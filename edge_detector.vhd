library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity edge_detector is
    port (
        rst_n         : in std_ulogic;
        clk           : in std_ulogic;
        input_i       : in std_ulogic;
        rising_edge_o : out std_ulogic 
    );
end entity;

architecture edge_detector_impl of edge_detector is
    type fsm_state_t is (LOW, HIGH);

    signal fsm_state_ff  : fsm_state_t;
    signal fsm_state_nxt : fsm_state_t;

begin
    
    seq : process (clk) is
    begin
        if (rising_edge(clk)) then
            if (rst_n = '0') then
                fsm_state_ff <= LOW;
            else
                fsm_state_ff <= fsm_state_nxt;
            end if;
        end if;
    end process;

    fsm : process (fsm_state_ff, input_i) is
    begin
        fsm_state_nxt <= fsm_state_ff;

        rising_edge_o <= '0';

        case(fsm_state_ff) is
            when LOW =>
                if input_i = '1' then
                    fsm_state_nxt <= HIGH;
                    if fsm_state_ff = LOW then 
                        rising_edge_o <= '1';
                    end if;
                end if;
            when HIGH =>
                if input_i = '0' then
                    fsm_state_nxt <= LOW;
                end if;
        end case;
    end process;
end architecture;