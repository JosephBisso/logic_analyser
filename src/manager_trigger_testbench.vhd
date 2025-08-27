library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity manager_trigger_testbench is
end entity;

architecture manager_trigger_testbench_impl of manager_trigger_testbench is
    
    component manager_trigger is
        generic(
            TRIGGER_WIDTH   : integer := 4
        );

        port (
        rst_n           : in  std_ulogic;
        clk             : in  std_ulogic;
        signal_i        : in  std_ulogic_vector(7 downto 0);
        trigger_set_i   : in  std_ulogic_vector(TRIGGER_WIDTH - 1 downto 0);
        trigger_flank_i : in  std_ulogic_vector(TRIGGER_WIDTH - 1 downto 0);
        triggered_o     : out std_ulogic
    );
    end component manager_trigger;

    constant TRIGGER_WIDTH : integer := 4;

    signal rst_n : std_ulogic;
    signal clk : std_ulogic;
    signal trigger_set : std_ulogic_vector(TRIGGER_WIDTH - 1 downto 0);
    signal trigger_flank : std_ulogic_vector(TRIGGER_WIDTH - 1 downto 0);
    signal signal_input : std_ulogic_vector(7 downto 0);
    signal triggered : std_ulogic;

begin
    
    manager_trigger_inst : manager_trigger
        generic map (
            TRIGGER_WIDTH => 4
        )
        port map (
            rst_n               => rst_n,
            clk                 => clk,
            signal_i            => signal_input,
            trigger_set_i       => trigger_set,
            trigger_flank_i     => trigger_flank,
            triggered_o         => triggered
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
        signal_input        <= (others => '0');
        trigger_set     <= (others => '0');
        trigger_flank   <= (others => '0');
        
        report "Initial Phase";
        
        wait for 10 sec;
        assert triggered = '0' report "triggered set";

        report "Signaling 0";
        wait for 1 sec;
        
        trigger_set     <= "0101";
        trigger_flank   <= "0100";

        assert triggered = '0' report "triggered set";

        report "Signaling 1";

        signal_input <= "00000101";
        wait until rising_edge(clk);
        wait for 1 ns;

        assert triggered = '1' report "triggered not set";

        report "Signaling 2";

        signal_input <= "00000001";
        wait until rising_edge(clk);
        wait for 1 ns;

        assert triggered = '0' report "triggered set";

        report "Signaling 3";

        signal_input <= "00001000";
        wait until rising_edge(clk);
        wait for 1 ns;

        assert triggered = '0' report "triggered not set";

        report "Signaling 4";

        signal_input <= "01100010";
        wait until rising_edge(clk);
        wait for 1 ns;

        assert triggered = '0' report "triggered set";

        report "Signaling 5";

        signal_input <= (others => '1');
        wait until rising_edge(clk);
        wait for 1 ns;

        assert triggered = '1' report "triggered not set";

        report "Signaling 6";

        signal_input <= (others => '0');
        wait until rising_edge(clk);
        wait for 1 ns;

        assert triggered = '0' report "triggered set";

        wait for 5 sec;

        report "No Signaling";

        wait until rising_edge(clk);
        wait for 1 ns;

        assert triggered = '0' report "triggered set";
        
        assert false report "End of Simulation" severity failure;
    end process;
    
end architecture manager_trigger_testbench_impl;
