library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity manager_display_vga_integration_testbench is
end entity;

architecture manager_display_vga_integration_impl of manager_display_vga_integration_testbench is
    
    component manager_display is
        generic(
            BIT_PER_DATA      : integer;
            BIT_PER_ADDRESS : integer;
            MEASURE_TIME    : integer;
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

    component vga is
        generic(
            SCREEN_WIDTH    : integer := 640;
            SCREEN_HEIGTH   : integer := 480
        );
	    port(
            clk             : in std_ulogic;
            pixel_i         : in std_ulogic;
            r_o             : out std_logic_vector(3 downto 0);
            g_o             : out std_logic_vector(3 downto 0);
            b_o             : out std_logic_vector(3 downto 0);
            h_pos_o         : out unsigned(9 downto 0);
            v_pos_o         : out unsigned(9 downto 0);
            hs              : out std_logic;
            vs              : out std_logic
        );
    end component vga;

    constant BIT_PER_DATA      : integer   := 4;
    constant BIT_PER_ADDRESS : integer   := 4;
    constant MEASURE_TIME    : integer   := 640;
    constant SCREEN_WIDTH    : integer   := 640;
    constant SCREEN_HEIGTH   : integer   := 480;

    signal clk            : std_ulogic;
    signal rst_n          : std_ulogic;
    signal h_pos          : unsigned(9 downto 0);
    signal v_pos          : unsigned(9 downto 0);
    signal ram            : std_ulogic_vector(BIT_PER_DATA - 1 downto 0);
    signal addr           : std_ulogic_vector(BIT_PER_ADDRESS - 1 downto 0);
    signal pixel          : std_ulogic;
    signal enable         : std_ulogic;
    signal hs             : std_logic;
    signal vs             : std_logic;


begin
    manager_display_inst : manager_display
        generic map(
            BIT_PER_DATA        => BIT_PER_DATA,
            BIT_PER_ADDRESS     => BIT_PER_ADDRESS,
            MEASURE_TIME        => MEASURE_TIME,
            SCREEN_WIDTH        => SCREEN_WIDTH,
            SCREEN_HEIGTH        => SCREEN_HEIGTH

        )
        port map (
            clk                 => clk,
            rst_n               => rst_n,
            h_pos_i             => h_pos,
            v_pos_i             => v_pos,
            ram_i               => ram,
            addr_o              => addr,
            pixel_o             => pixel,
            enable_i            => enable
        );

    vga_inst: vga
        generic map(
            SCREEN_WIDTH        => SCREEN_WIDTH,
            SCREEN_HEIGTH       => SCREEN_HEIGTH

        )
        port map(
            clk                 => clk,
            pixel_i             => pixel,
            h_pos_o             => h_pos,
            v_pos_o             => v_pos,
            hs                  => hs,
            vs                  => vs
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
        ram <= std_ulogic_vector(to_unsigned(0, BIT_PER_DATA));
        enable <= '0';
        rst_n <= '1';
        
        wait until rising_edge(clk);
        wait for 1 ns;

        assert pixel = '0' report "Pixel auf 1";
        assert addr = std_ulogic_vector(to_unsigned(0, BIT_PER_ADDRESS));
        wait for 1 ns;

        report "Display High state 1";

        enable <= '1';
        ram <= "0011";

        wait until rising_edge(clk);
        -- wait for 1 ns;
        
        -- report "addr = " & integer'image(to_integer(unsigned(addr)));

        assert addr = std_ulogic_vector(to_unsigned(0, BIT_PER_ADDRESS));
        assert pixel = '1' report "Pixel nicht auf 1";
        wait for 1 ns;

        report "Display High state 2";

        wait until rising_edge(clk); -- because of vga clock divider
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait for 1 ns;

        assert addr = std_ulogic_vector(to_unsigned(1, BIT_PER_ADDRESS));
        assert pixel = '1' report "Pixel nicht auf 1";
        wait for 1 ns;
        
        report "Display Low state 1";
        ram <= "0010";
        
        wait until rising_edge(clk); -- because of vga clock divider
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait for 1 ns;

        assert addr = std_ulogic_vector(to_unsigned(2, BIT_PER_ADDRESS));

        assert pixel = '0' report "Pixel auf 1";
        wait for 1 ns;

        report "Display Low state 2";

        wait until rising_edge(clk); -- because of vga clock divider
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait for 1 ns;

        -- report "addr = " & integer'image(to_integer(unsigned(addr)));

        assert addr = std_ulogic_vector(to_unsigned(3, BIT_PER_ADDRESS));
        assert pixel = '0' report "Pixel auf 1";
        wait for 1 ns;

        report "Rest state";
        rst_n <= '0';

        wait until rising_edge(clk);
        wait for 1 ns;

        assert pixel = '0' report "Pixel auf 1";

        wait for 1 ns;

        assert false report "End of Simulation" severity failure;
    end process;
    
end architecture manager_display_vga_integration_impl;
