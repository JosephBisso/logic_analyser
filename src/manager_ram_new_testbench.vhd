library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity manager_ram_new_testbench is
end entity;

architecture manager_ram_new_testbench_impl of manager_ram_new_testbench is
    component manager_ram_new is
        generic(
            BIT_PER_DATA    : integer;
            BIT_PER_ADDRESS    : integer
        );

        port (
            clk				: in std_ulogic;
		    rst_n			: in std_ulogic;
		    measure_i		: in std_ulogic;
		    display_i		: in std_ulogic; 
		    data_i    		: in std_ulogic_vector(BIT_PER_DATA-1 downto 0); 
		    data_o 			: out std_ulogic_vector(BIT_PER_DATA-1 downto 0);
		    addr_measure    : in std_ulogic_vector(BIT_PER_ADDRESS-1 downto 0); 
		    addr_display    : in std_ulogic_vector(BIT_PER_ADDRESS-1 downto 0)
        );
    end component manager_ram_new;

    constant BIT_PER_DATA   : integer := 4;
    constant BIT_PER_ADDRESS   : integer := 4;

    signal clk              : std_ulogic;
    signal rst_n            : std_ulogic;
    signal measure        : std_ulogic;
    signal display        : std_ulogic; 
    signal data_in           : std_ulogic_vector(BIT_PER_DATA-1 downto 0); 
    signal data_out           : std_ulogic_vector(BIT_PER_DATA-1 downto 0);
    signal addr_measure     : std_ulogic_vector(BIT_PER_ADDRESS-1 downto 0); 
    signal addr_display     : std_ulogic_vector(BIT_PER_ADDRESS-1 downto 0);

begin
    
    manager_ram_new_inst : manager_ram_new
        generic map(
            BIT_PER_DATA        => BIT_PER_DATA,
            BIT_PER_ADDRESS     => BIT_PER_ADDRESS

        )
        port map (
            clk                 => clk,
            rst_n               => rst_n,
            measure_i           => measure,
            display_i           => display,
            data_i              => data_in,
            data_o              => data_out,
            addr_measure        => addr_measure,
            addr_display        => addr_display
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

        report "Read/Write Address 1";
        measure  <= '1';
        addr_measure        <= "0101";
        data_in         <= "1110";

        wait until rising_edge(clk);
        wait for 1 ns;
        
        assert data_out <= "1110" report "RAM write/read operation failed";
        wait for 1 ns;

        report "Read/Write Address 2";
        addr_measure        <= "1101";
        data_in         <= "1001";

        wait until rising_edge(clk);
        wait for 1 ns;
        
        assert data_out <= "1001" report "RAM write/read operation failed";
        wait for 1 ns;

        report "Display Read Address 1";
        measure  <= '0';
        display <= '1';
        addr_display   <= "0101";

        wait until rising_edge(clk);
        wait for 1 ns;
        
        assert data_out <= "1110" report "RAM write/read operation failed";
        wait for 1 ns;
        
        report "Display Read Address 2";
        measure  <= '0';
        display <= '1';
        addr_display   <= "1101";

        wait until rising_edge(clk);
        wait for 1 ns;
        
        assert data_out <= "1001" report "RAM write/read operation failed";
        wait for 1 ns;
        
        assert false report "End of Simulation" severity failure;
    end process;
    
end architecture manager_ram_new_testbench_impl;
