library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity manager_state_testbench is
end entity;

architecture manager_state_testbench_impl of manager_state_testbench is
    
    component manager_state is
        port (
        rst_n           : in  std_ulogic;
        clk             : in  std_ulogic;
        triggered_i     : in  std_ulogic;
        measured_i      : in  std_ulogic;
        displayed_i     : in  std_ulogic;
        measure_en_o    : out std_ulogic;
        display_en_o    : out std_ulogic
    );
    end component manager_state;

    signal rst_n           : std_ulogic;
    signal clk             : std_ulogic;
    signal triggered     : std_ulogic;
    signal measured      : std_ulogic;
    signal displayed     : std_ulogic;
    signal measure_en    : std_ulogic;
    signal display_en    : std_ulogic;

begin
    
    manager_state_inst : manager_state
        port map (
            rst_n               => rst_n,
            clk                 => clk,
            triggered_i         => triggered,
            measured_i          => measured,
            displayed_i         => displayed,
            measure_en_o        => measure_en,
            display_en_o        => display_en
        );

   

    clock : process is
    begin
        clk <= '0';
        wait for 500 ms;
        clk <= '1';
        wait for 500 ms;
    end process;

    test : process is
    begin
        triggered <= '0';
        measured <= '0';
        displayed <= '0';
        rst_n <= '0';

        wait until rising_edge(clk);
        wait for 1 ns;

        report "Resest State";

        assert measure_en    = '0' report "measure enabled";
        assert display_en  = '1' report "display not enabled";

        wait for 10 sec;
        assert measure_en    = '0' report "measure enabled";
        assert display_en  = '1' report "display not enabled";

        
        rst_n <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;

        report "WAIT Trigger State";

        assert measure_en    = '0' report "measure enabled";
        assert display_en  = '1' report "display not enabled";

        wait for 10 sec;
        assert measure_en    = '0' report "measure enabled";
        assert display_en  = '1' report "display not enabled";

        triggered <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;

        report "Measure State";

        assert measure_en    = '1' report "measure not enabled";
        assert display_en  = '0' report "display enabled";

        wait for 10 sec;
        assert measure_en    = '1' report "measure not enabled";
        assert display_en  = '0' report "display enabled";

        triggered <= '0';
        measured <= '1';
        displayed <= '0';
        wait until rising_edge(clk);
        wait for 1 ns;

        report "Display State";

        assert measure_en    = '0' report "measure enabled";
        assert display_en  = '1' report "display not enabled on state";

        wait for 10 sec;
        assert measure_en    = '0' report "measure enabled";
        assert display_en  = '1' report "display not enabled until displayed";

        measured <= '0';
        displayed <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;

        report "WAIT Trigger State";

        assert measure_en    = '0' report "measure enabled";
        assert display_en  = '1' report "display enabled";

        assert false report "End of Simulation" severity failure;
    end process;
    
end architecture manager_state_testbench_impl;
