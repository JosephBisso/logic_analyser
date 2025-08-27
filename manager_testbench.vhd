library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity manager_testbench is
end entity;

architecture manager_testbench_impl of manager_testbench is
    
    component manager is
        Generic(
            BIT_PER_DATA      : integer := 8;
            TRIGGER_WIDTH   : integer := 4;
            BIT_PER_ADDRESS : integer := 8;
            MEASURE_TIME    : integer  := 40;
        );
        port (
            rst_n               : in  std_ulogic;
            clk                 : in  std_ulogic;
            signal_i            : in  std_ulogic_vector( BIT_PER_DATA - 1 downto 0);
            trigger_set_i       : in  std_ulogic_vector(TRIGGER_WIDTH - 1 downto 0);
            trigger_flank_i     : in  std_ulogic_vector(TRIGGER_WIDTH - 1 downto 0);
            start               : in  std_ulogic;
        
            signal_o            : out  std_ulogic_vector( BIT_PER_DATA - 1 downto 0);
            display_en_o        : out std_ulogic
        
        );
    end component manager;

    signal rst_n         : std_ulogic;
    signal clk           : std_ulogic;
    signal start         : std_ulogic;
    signal triggered     : std_ulogic;
    signal measured      : std_ulogic;
    signal displayed     : std_ulogic;
    signal trigger_en    : std_ulogic;
    signal measure_en    : std_ulogic;
    signal display_en    : std_ulogic;

begin
    
    manager_inst : manager
        port map (
            rst_n               => rst_n,
            clk                 => clk,
            start_i             => start,
            triggered_i         => triggered,
            measured_i          => measured,
            displayed_i         => displayed,
            trigger_en_o        => trigger_en,
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
        start <= '0';
        triggered <= '0';
        measured <= '0';
        displayed <= '0';
        
        wait for 10 sec;

        report "Init State";
        assert measure_en    = '0' report "measure enabled";
        assert display_en  = '0' report "display enabled";

        wait for 10 sec;
        
        report "WAIT Start State";

        assert measure_en    = '0' report "measure enabled";
        assert display_en  = '0' report "display enabled";

        wait for 10 sec;
        assert measure_en    = '0' report "measure enabled";
        assert display_en  = '0' report "display enabled";

        start <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;

        report "WAIT Trigger State";

        assert measure_en    = '0' report "measure enabled";
        assert display_en  = '0' report "display enabled";

        wait for 10 sec;
        assert measure_en    = '0' report "measure enabled";
        assert display_en  = '0' report "display enabled";

        start <= '0';
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
        wait until rising_edge(clk);
        wait for 1 ns;

        report "Display State";

        assert measure_en    = '0' report "measure enabled";
        assert display_en  = '1' report "display not enabled";

        wait for 10 sec;
        assert measure_en    = '0' report "measure enabled";
        assert display_en  = '1' report "display not enabled";

        measured <= '0';
        displayed <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;

        report "WAIT Start State";

        assert measure_en    = '0' report "measure enabled";
        assert display_en  = '0' report "display enabled";

        assert false report "End of Simulation" severity failure;
    end process;
    
end architecture manager_testbench_impl;
