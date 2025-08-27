library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity manager_measure_ram_integration_testbench is
end entity;

architecture manager_measure_ram_integration_impl of manager_measure_ram_integration_testbench is
    
    component manager_measure is
        Generic(
            BIT_PER_ADDRESS    : integer := 16;
            MEASURE_TIME    : integer := 512
        );
        port (
            rst_n           : in  std_ulogic;
            clk             : in  std_ulogic;
            measure_i       : in  std_ulogic;
            done_o          : out std_ulogic;
            address_o       : out std_ulogic_vector(BIT_PER_ADDRESS - 1 downto 0)
        );
    end component manager_measure;

    component manager_ram_new is
	    generic(
            BIT_PER_DATA: integer:=8;
	        BIT_PER_ADDRESS: integer:=16
        ); 
	    port(
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


    constant BIT_PER_DATA       : integer := 4;
    constant BIT_PER_ADDRESS    : integer := 4;
    constant MEASURE_TIME       : integer := 12;

    signal rst_n            : std_ulogic;
    signal clk              : std_ulogic;
    signal measure          : std_ulogic;
    signal done             : std_ulogic;
    signal address          : std_ulogic_vector(BIT_PER_ADDRESS - 1 downto 0);

    signal display          : std_ulogic;
    signal data_in          : std_ulogic_vector(BIT_PER_ADDRESS - 1 downto 0);
    signal data_out         : std_ulogic_vector(BIT_PER_ADDRESS - 1 downto 0);
    signal address_display  : std_ulogic_vector(BIT_PER_ADDRESS - 1 downto 0);

begin
    
    manager_measure_inst : manager_measure
        generic map(
            BIT_PER_ADDRESS => BIT_PER_ADDRESS, 
            MEASURE_TIME    => MEASURE_TIME
        )
        port map(
            rst_n           => rst_n,           
            clk             => clk,             
            measure_i       => measure,       
            done_o          => done,          
            address_o       => address     
        );

    manager_ram_new_inst: manager_ram_new
        generic map(
            BIT_PER_DATA        => BIT_PER_DATA,
            BIT_PER_ADDRESS     => BIT_PER_ADDRESS
        )
        port map(
        	clk				    => clk,
        	rst_n			    => rst_n,
            measure_i		    => measure,
            display_i		    => display,
        	data_i    		    => data_in,
        	data_o 			    => data_out,
        	addr_measure        => address,
        	addr_display        => address_display
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

        report "Initial state";
        measure <= '0';
        rst_n <= '1';
        display <= '0';
        data_in <= std_ulogic_vector(to_unsigned(0, BIT_PER_DATA));
        address_display <=std_ulogic_vector(to_unsigned(0, BIT_PER_ADDRESS));

        wait until rising_edge(clk);
        wait for 1 ns;

        assert done = '0' report "Done set";
        assert address = std_ulogic_vector(to_unsigned(0, BIT_PER_ADDRESS));

        -- report "!! data_out = " & in'image(data_out);

        assert to_integer(unsigned(data_out)) = 0;
        wait for 1 ns;

        report "Messung start 1";
        measure <= '1';
        display <= '0';
        data_in <= std_ulogic_vector(to_unsigned(5, BIT_PER_DATA));

        wait until rising_edge(clk);
        wait for 1 ns;

        assert done = '0' report "Done set";
        assert address = std_ulogic_vector(to_unsigned(1, BIT_PER_ADDRESS));
        assert data_out = std_ulogic_vector(to_unsigned(5, BIT_PER_DATA));
        wait for 1 ns;

        report "Messung start 2";
        data_in <= std_ulogic_vector(to_unsigned(7, BIT_PER_DATA));

        wait until rising_edge(clk);
        wait for 1 ns;

        assert done = '0' report "Done set";
        assert address = std_ulogic_vector(to_unsigned(2, BIT_PER_ADDRESS));
        
        -- report "!! data_out = " & integer'image(to_integer(unsigned(data_out)));
        assert data_out = std_ulogic_vector(to_unsigned(7, BIT_PER_DATA));
        wait for 1 ns;

        report "Display start 1";
        measure <= '0';
        display <= '1';
        
        wait until rising_edge(clk);
        
        address_display <= std_ulogic_vector(to_unsigned(1, BIT_PER_DATA));
        wait until rising_edge(clk);
        
        -- report "!! data_out = " & integer'image(to_integer(unsigned(data_out)));

        assert data_out = std_ulogic_vector(to_unsigned(5, BIT_PER_DATA));
        wait for 1 ns;

        report "Display start 2";
        address_display <= std_ulogic_vector(to_unsigned(2, BIT_PER_DATA));

        wait until rising_edge(clk);
        -- wait for 1 ns;

        -- report "!! data_out = " & integer'image(to_integer(unsigned(data_out)));

        assert data_out = std_ulogic_vector(to_unsigned(7, BIT_PER_DATA));
        wait for 1 ns;


        report "Rest state";
        rst_n <= '0';

        wait until rising_edge(clk);
        wait for 1 ns;

        assert done = '0' report "Done set";
        assert address = std_ulogic_vector(to_unsigned(0, BIT_PER_ADDRESS));
        assert data_out = std_ulogic_vector(to_unsigned(0, BIT_PER_DATA));
        wait for 1 ns;
        
        assert false report "End of Simulation" severity failure;
    end process;
    
end architecture manager_measure_ram_integration_impl;
