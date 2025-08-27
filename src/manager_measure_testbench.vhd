library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity manager_measure_testbench is
end entity;

architecture manager_measure_testbench_impl of manager_measure_testbench is
    component manager_measure is
        generic(
            BIT_PER_ADDRESS    : integer;
            MEASURE_TIME    : integer
        );

        port (
            rst_n           : in  std_ulogic;
            clk             : in  std_ulogic;
            measure_i       : in  std_ulogic;
            done_o          : out std_ulogic;
            address_o       : out std_ulogic_vector(BIT_PER_ADDRESS - 1 downto 0)
        );
    end component manager_measure;

    constant BIT_PER_ADDRESS   : integer := 4;
    constant MEASURE_TIME   : integer := 8;

    signal rst_n            : std_ulogic;
    signal clk              : std_ulogic;
    signal measure          : std_ulogic;
    signal address          : std_ulogic_vector(BIT_PER_ADDRESS - 1 downto 0);
    signal done             : std_ulogic;

begin
    
    manager_measure_inst : manager_measure
        generic map(
            BIT_PER_ADDRESS     => BIT_PER_ADDRESS,
            MEASURE_TIME        => MEASURE_TIME

        )
        port map (
            rst_n               => rst_n,
            clk                 => clk,
            measure_i           => measure,
            address_o           => address,
            done_o              => done
        );

    clock : process is
    begin
        clk <= '0';
        wait for 500 us;
        clk <= '1';
        wait for 500 us;
    end process;

    test : process is
        begin


        report "Reset Active,  Measure set";
        rst_n <= '0'; 
        measure <= '1';

        wait until rising_edge(clk);
        wait for 1 ns;

        assert done    = '0' report "Done set";
        assert address  = "0000" report "Ram Address not at 0";

        report "Init state";
        measure <= '0';
        rst_n <= '1';
        
        wait until rising_edge(clk);
        wait for 1 ns;
        
        assert done    = '0' report "Done set";
        assert address  = "0000" report "Ram Address not at 0";

        report "Measure Start";
        
        rst_n <= '1';
        measure <= '1';

        wait until rising_edge(clk);
        wait for 1 ns;

        assert address  = "0001" report "ram address not incremented 1";

        wait until rising_edge(clk);
        wait for 1 ns;
        
        assert address  = "0010" report "ram address not incremented 2";

        report "Measure Done";

        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait for 1 ns;

        assert address  = "0111" report "ram address not incremented 3";

        wait until rising_edge(clk);
        wait for 1 ns;
        assert address  = "0000" report "Ram Address not at 0";
        assert done    = '1' report "Done not set";

        
        assert false report "End of Simulation" severity failure;
    end process;
    
end architecture manager_measure_testbench_impl;
