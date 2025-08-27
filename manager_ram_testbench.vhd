library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity manager_ram_testbench is
end entity;

architecture manager_ram_testbench_impl of manager_ram_testbench is
    component manager_ram is
        generic(
            BIT_PER_DATA    : integer;
            BIT_PER_ADDRESS    : integer
        );

        port (
            clk:        in std_ulogic; 
		    read_write: in std_ulogic; 
		    addr :      in std_ulogic_vector(BIT_PER_ADDRESS-1 downto 0); 
		    Din :       in std_ulogic_vector(BIT_PER_DATA-1 downto 0);
		    Dout :      out std_ulogic_vector(BIT_PER_DATA-1 downto 0)
        );
    end component manager_ram;

    constant BIT_PER_DATA   : integer := 4;
    constant BIT_PER_ADDRESS   : integer := 4;

    signal clk          : std_ulogic;
    signal read_write   : std_ulogic;
    signal addr         : std_ulogic_vector(BIT_PER_ADDRESS-1 downto 0);
    signal Din          : std_ulogic_vector(BIT_PER_DATA-1 downto 0);
	signal Dout         : std_ulogic_vector(BIT_PER_DATA-1 downto 0);

begin
    
    manager_ram_inst : manager_ram
        generic map(
            BIT_PER_DATA        => BIT_PER_DATA,
            BIT_PER_ADDRESS     => BIT_PER_ADDRESS

        )
        port map (
            clk             => clk,
            read_write      => read_write,
            addr            => addr,
            Din             => Din,
            Dout            => Dout
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
        read_write  <= '1';
        addr        <= "0101";
        Din         <= "1110";

        wait until rising_edge(clk);
        wait for 1 ns;

        read_write <= '0';
        wait until rising_edge(clk);
        wait for 1 ns;

        assert Dout <= "1110" report "RAM write/read operation failed";
        wait for 1 ns;

        report "Read/Write Address 2";
        read_write  <= '1';
        addr        <= "1101";
        Din         <= "1001";

        wait until rising_edge(clk);
        wait for 1 ns;
        addr        <= "1101";
        read_write  <= '0';
        wait until rising_edge(clk);
        wait for 1 ns;
        
        assert Dout <= "1001" report "RAM write/read operation failed";
        wait for 1 ns;

        addr        <= "0101";
        read_write  <= '0';
        wait until rising_edge(clk);
        wait for 1 ns;
        
        assert Dout <= "1110" report "RAM write/read operation failed";
        wait for 1 ns;
        
        assert false report "End of Simulation" severity failure;
    end process;
    
end architecture manager_ram_testbench_impl;
