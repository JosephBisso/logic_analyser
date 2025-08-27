library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity manager_state is
    port (
        rst_n           : in  std_ulogic;
        clk             : in  std_ulogic;
        triggered_i     : in  std_ulogic;
        measured_i      : in  std_ulogic;
        displayed_i      : in  std_ulogic;
        measure_en_o    : out std_ulogic;
        display_en_o    : out std_ulogic
    );
end entity;

architecture manager_state_impl of manager_state is

    type fsm_state_t is(WAIT_TRIGGER, MEASURE, DISPLAY);

    signal fsm_state_ff  : fsm_state_t;
    signal fsm_state_nxt : fsm_state_t;

begin

    seq : process (clk, rst_n) is
    begin
        if (rising_edge(clk)) then
            if (rst_n = '0') then
                fsm_state_ff <= DISPLAY;
            else
                fsm_state_ff <= fsm_state_nxt;
            end if;
        end if;
    end process;

    fsm : process (fsm_state_ff, triggered_i, measured_i, displayed_i) is
        begin   
        fsm_state_nxt <= fsm_state_ff;

        -- Default Werte festlegen
        measure_en_o    <= '0';
        display_en_o    <= '0';

        case (fsm_state_ff) is
            when WAIT_TRIGGER =>
                display_en_o    <= '1';
                if(triggered_i = '1') then
                    fsm_state_nxt <= MEASURE;
                end if;

            when MEASURE =>
                measure_en_o    <= '1';
                if(measured_i = '1') then   
                    fsm_state_nxt <= DISPLAY;
                end if;

            when DISPLAY =>
                display_en_o    <= '1';
                if(displayed_i = '1') then
                    fsm_state_nxt <= WAIT_TRIGGER;
                end if;


        end case;

    end process;

end architecture;