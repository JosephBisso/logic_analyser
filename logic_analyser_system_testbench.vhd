library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity logic_analyser_system_testbench is
end entity;

architecture rtl of logic_analyser_system_testbench is

    component manager_state is
        port (
            rst_n           : in  std_ulogic;
            clk             : in  std_ulogic;
            triggered_i     : in  std_ulogic;
            measured_i      : in  std_ulogic;
            displayed_i      : in  std_ulogic;
            measure_en_o    : out std_ulogic;
            display_en_o    : out std_ulogic
        );
    end component manager_state;

    component manager_trigger is
        Generic(
            BIT_PER_DATA      : integer := 8;
            TRIGGER_WIDTH   : integer := 4
        );
        port (
            rst_n           : in  std_ulogic;
            clk             : in  std_ulogic;
            signal_i        : in  std_ulogic_vector(BIT_PER_DATA -1 downto 0);
            trigger_set_i   : in  std_ulogic_vector(TRIGGER_WIDTH - 1 downto 0);
            trigger_flank_i : in  std_ulogic_vector(TRIGGER_WIDTH - 1 downto 0);
            triggered_o     : out std_ulogic
        );
    end component manager_trigger;
    
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
    
    component manager_display is
        generic(
            BIT_PER_DATA      : integer   := 8;
            BIT_PER_ADDRESS : integer   := 16;
            MEASURE_TIME    : integer   := 32;
            SCREEN_WIDTH    : integer := 640;
            SCREEN_HEIGTH   : integer := 480
        ); 
        port(
            clk             : in std_ulogic; 
            rst_n           : in std_ulogic;
            h_pos_i         : in unsigned(9 downto 0);
            v_pos_i         : in unsigned(9 downto 0);
            ram_i           : in std_ulogic_vector(BIT_PER_DATA - 1 downto 0);
            addr_o          : out std_ulogic_vector(BIT_PER_ADDRESS - 1 downto 0);
            pixel_o         : out std_ulogic;
            enable_i        : in std_ulogic
        );
    end component manager_display;


    constant BIT_PER_DATA      : integer := 8;
    constant TRIGGER_WIDTH   : integer := 4;
    constant BIT_PER_ADDRESS : integer := 8;
    constant MEASURE_TIME    : integer  := 4;
    constant SCREEN_WIDTH    : integer   := 640;
    constant SCREEN_HEIGTH   : integer   := 480;
    constant ROW_HEIGTH       : unsigned(9 downto 0) := to_unsigned(SCREEN_HEIGTH / 8, 10);
    constant BIT_WIDTH        : unsigned(9 downto 0) := to_unsigned(SCREEN_WIDTH / MEASURE_TIME, 10);

    signal clk              : std_ulogic;
    signal rst_n            : std_ulogic;
    signal displayed         : std_ulogic;
    signal signal_in        :  std_ulogic_vector(BIT_PER_DATA - 1 downto 0);
    signal trigger_set      :  std_ulogic_vector(TRIGGER_WIDTH - 1 downto 0);
    signal trigger_flank    :  std_ulogic_vector(TRIGGER_WIDTH - 1 downto 0);
    signal h_pos            : unsigned(9 downto 0);
    signal v_pos            : unsigned(9 downto 0);
    signal pixel            : std_ulogic;
    signal line_displayed   : std_ulogic;

    signal triggered     : std_ulogic;
    signal measured      : std_ulogic;
    signal measure_en    : std_ulogic;
    signal display_en    : std_ulogic;
    signal address          : std_ulogic_vector(BIT_PER_ADDRESS - 1 downto 0);
    signal data_out           : std_ulogic_vector(BIT_PER_DATA-1 downto 0);
    signal addr_display     : std_ulogic_vector(BIT_PER_ADDRESS-1 downto 0);

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

    manager_trigger_inst : manager_trigger
        port map (
            rst_n               => rst_n,
            clk                 => clk,
            signal_i            => signal_in,
            trigger_set_i       => trigger_set,
            trigger_flank_i     => trigger_flank,
            triggered_o         => triggered
        );

    manager_measure_inst : manager_measure
        generic map(
            BIT_PER_ADDRESS        => BIT_PER_ADDRESS,
            MEASURE_TIME        => MEASURE_TIME

        )
        port map (
            rst_n               => rst_n,
            clk                 => clk,
            measure_i           => measure_en,
            address_o           => address,
            done_o              => measured
        );

    manager_ram_inst : manager_ram_new
        generic map(
            BIT_PER_DATA        => BIT_PER_DATA,
            BIT_PER_ADDRESS     => BIT_PER_ADDRESS

        )
        port map (
            clk                 => clk,
            rst_n               => rst_n,
            measure_i           => measure_en,
            display_i           => display_en,
            data_i              => signal_in,
            data_o              => data_out,
            addr_measure        => address,
            addr_display        => addr_display
        );

    manager_display_inst : manager_display
        generic map(
            BIT_PER_DATA        => BIT_PER_DATA,
            BIT_PER_ADDRESS     => BIT_PER_ADDRESS,
            MEASURE_TIME        => MEASURE_TIME

        )
        port map (
            clk                 => clk,
            rst_n               => rst_n,
            h_pos_i             => h_pos,
            v_pos_i             => v_pos,
            ram_i               => data_out,
            addr_o              => addr_display,
            pixel_o             => pixel,
            enable_i            => display_en
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

        report "Initial state -> Wait for Trigger";
        rst_n <= '0';
        displayed <= '1';
        signal_in <= (others => '0');
        trigger_set <= (others => '0');
        trigger_flank <= (others => '0');
        h_pos <= (others => '0');
        v_pos <= (others => '0');
        
        wait until rising_edge(clk);
        wait for 1 ns;

        assert measure_en = '0' report "Measure Enabled";
        assert display_en = '1' report "Display Not Enabled";
        assert pixel = '0' report "Pixel auf 1";
        wait for 1 ns;

        report "Trigger state - normal trigger";
        rst_n <= '1';
        displayed <= '1';

        signal_in <= "00001111";
        trigger_set <= "0110";
        trigger_flank <= "0000";

        wait until rising_edge(clk);
        wait for 1 ns;

        assert triggered = '1' report "trigger not set";

        wait until rising_edge(clk);
        wait for 1 ns;
        assert measure_en = '1' report "measure not enabled";
        assert display_en = '0' report "Display Enabled";
        
        report "Measure state ";
        
        wait until rising_edge(clk);
        assert address = std_ulogic_vector(to_unsigned(0, BIT_PER_ADDRESS)) report "Addres not at zero";

        signal_in <= "00001111";
        wait until rising_edge(clk);

        assert data_out = "00001111" report "data out from memory unexpected 1";
        assert address = std_ulogic_vector(to_unsigned(1, BIT_PER_ADDRESS)) report "Addres not incremented";
        
        
        signal_in <= "11110000";
        wait until rising_edge(clk);

        assert data_out = "00001111" report "data out from memory unexpected 2";
        assert address = std_ulogic_vector(to_unsigned(2, BIT_PER_ADDRESS)) report "Addres not incremented";
        -- report "!! data_out = " & integer'image(to_integer(unsigned(data_out)));
        

        signal_in <= "00001111";
        wait until rising_edge(clk);

        assert data_out = "11110000" report "data out from memory unexpected 3";
        assert address = std_ulogic_vector(to_unsigned(3, BIT_PER_ADDRESS)) report "Addres not incremented";
        -- report "!! data_out = " & integer'image(to_integer(unsigned(data_out)));

        wait until rising_edge(clk);
        assert measured = '1' report "measure not done after measure time";
        
        assert data_out = "00001111" report "data out from memory unexpected 4";
        assert address = std_ulogic_vector(to_unsigned(0, BIT_PER_ADDRESS)) report "Addres not reset after measure time";
        -- report "!! data_out = " & integer'image(to_integer(unsigned(data_out)));

        wait until rising_edge(clk);
        wait for 1 ns;
        assert measure_en = '0' report "measure enabled";
        assert display_en = '1' report "Display not Enabled";

        report "Display state ";

        h_pos <= to_unsigned(to_integer(BIT_WIDTH) / 2, 10);
        v_pos <= to_unsigned(to_integer(ROW_HEIGTH) * 0, 10);
        wait until rising_edge(clk);
        assert addr_display = std_ulogic_vector(to_unsigned(0, BIT_PER_ADDRESS)) report "Addres not first";
        assert data_out = "00001111" report "data out from memory unexpected 1";
        assert pixel = '1' report "Pixel not set 1 ";
        -- report "!! data_out = " & integer'image(to_integer(unsigned(data_out)));

        v_pos <= to_unsigned(to_integer(ROW_HEIGTH) * 0 + 5, 10);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        assert addr_display = std_ulogic_vector(to_unsigned(0, BIT_PER_ADDRESS)) report "Addres not first";
        assert data_out = "00001111" report "data out from memory unexpected 1";
        assert pixel = '0' report "Pixel set for row spacing";

        v_pos <= to_unsigned(to_integer(ROW_HEIGTH) * 1/2, 10);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        assert addr_display = std_ulogic_vector(to_unsigned(0, BIT_PER_ADDRESS)) report "Addres not first";
        assert data_out = "00001111" report "data out from memory unexpected 2";
        assert pixel = '1' report "Pixel set 2";
        -- report "!! data_out = " & integer'image(to_integer(unsigned(data_out)));

        v_pos <= to_unsigned(to_integer(ROW_HEIGTH) * 1, 10);
        wait until rising_edge(clk);
        assert addr_display = std_ulogic_vector(to_unsigned(0, BIT_PER_ADDRESS)) report "Addres not first";
        assert data_out = "00001111" report "data out from memory unexpected 3";
        assert pixel = '1' report "Pixel not set for underline";


        h_pos <= to_unsigned(5 * to_integer(BIT_WIDTH) / 2, 10);
        v_pos <= to_unsigned(to_integer(ROW_HEIGTH) * 3/2, 10);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        assert addr_display = std_ulogic_vector(to_unsigned(2, BIT_PER_ADDRESS)) report "Addres not thrid";
        -- report "!! addr_display = " & integer'image(to_integer(unsigned(addr_display)));
        wait until rising_edge(clk);
        assert data_out = "11110000" report "data out from memory unexpected 4";
        assert pixel = '0' report "Pixel set 3";
        -- report "!! data_out = " & integer'image(to_integer(unsigned(data_out)));

        v_pos <= to_unsigned(to_integer(ROW_HEIGTH) * 2, 10);
        wait until rising_edge(clk);
        assert addr_display = std_ulogic_vector(to_unsigned(2, BIT_PER_ADDRESS)) report "Addres not thrid";
        wait until rising_edge(clk);
        assert data_out = "11110000" report "data out from memory unexpected 5";
        assert pixel = '1' report "Pixel not set for underline";
        -- report "!! data_out = " & integer'image(to_integer(unsigned(data_out)));

        v_pos <= to_unsigned(to_integer(ROW_HEIGTH) * 5/2, 10);
        wait until rising_edge(clk);
        assert addr_display = std_ulogic_vector(to_unsigned(2, BIT_PER_ADDRESS)) report "Addres not thrid";
        wait until rising_edge(clk);
        assert data_out = "11110000" report "data out from memory unexpected 6";
        assert pixel = '0' report "Pixel set 4";

        v_pos <= to_unsigned(to_integer(ROW_HEIGTH) * 3, 10);
        wait until rising_edge(clk);
        assert addr_display = std_ulogic_vector(to_unsigned(2, BIT_PER_ADDRESS)) report "Addres not at zero";
        wait until rising_edge(clk);
        assert data_out = "11110000" report "data out from memory unexpected 7";
        assert pixel = '1' report "Pixel not set for underline";

        report "Rest state";
        rst_n <= '0';

        wait until rising_edge(clk);
        wait for 1 ns;

        assert pixel = '0' report "Pixel auf 1";

        wait for 1 ns;

        assert false report "End of Simulation" severity failure;
    end process;
    
end architecture;