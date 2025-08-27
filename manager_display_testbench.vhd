library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity manager_display_testbench is
end entity;

architecture manager_display_testbench_impl of manager_display_testbench is
    component manager_display is
        generic(
            BIT_PER_DATA      : integer   := 8;
            BIT_PER_ADDRESS : integer   := 16;
            MEASURE_TIME    : integer   := 32
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

    constant BIT_PER_DATA      : integer   := 8;
    constant BIT_PER_ADDRESS : integer   := 4;
    constant MEASURE_TIME    : integer   := 32;

    signal clk            : std_ulogic;
    signal h_pos          : unsigned(9 downto 0);
    signal v_pos          : unsigned(9 downto 0);
    signal ram            : std_ulogic_vector(BIT_PER_DATA - 1 downto 0);
    signal addr           : std_ulogic_vector(BIT_PER_ADDRESS - 1 downto 0);
    signal pixel          : std_ulogic;
    signal enable         : std_ulogic;
    signal rst_n          : std_ulogic;

begin
    
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
            ram_i               => ram,
            addr_o              => addr,
            pixel_o             => pixel,
            enable_i            => enable
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
        h_pos <= to_unsigned(0, 10);
        v_pos <= to_unsigned(0, 10);
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
        h_pos <= to_unsigned(80, 10); -- Should be 4th address if bit_width is 20
        v_pos <= to_unsigned(120, 10);  -- Should be 2th signal if row_heigth is 60 
        ram <= "00001111";

        wait until rising_edge(clk);
        wait for 1 ns;
        
        -- report "addr = " & integer'image(to_integer(unsigned(addr)));

        assert addr = std_ulogic_vector(to_unsigned(4, BIT_PER_ADDRESS));
        assert pixel = '1' report "Pixel nicht auf 1 for underline";
        wait for 1 ns;

        v_pos <= to_unsigned(125, 10);  -- Should be 2th signal if row_heigth is 60 
        wait until rising_edge(clk);
        wait for 1 ns;
        
        assert pixel = '0' report "Pixel auf 1 for row spacing";
        wait for 1 ns;

        v_pos <= to_unsigned(135, 10);  -- Should be 2th signal if row_heigth is 60 
        wait until rising_edge(clk);
        wait for 1 ns;
        
        assert pixel = '1' report "Pixel nicht auf 1 for high bit";
        wait for 1 ns;

        report "Display High state 2";

        h_pos <= to_unsigned(85, 10); -- Should still be 4th address if bit_width is 20
        v_pos <= to_unsigned(130, 10);  -- Should still be 2th signal if row_heigth is 60 

        wait until rising_edge(clk);
        wait for 1 ns;

        -- report "addr = " & integer'image(to_integer(unsigned(addr)));

        assert addr = std_ulogic_vector(to_unsigned(4, BIT_PER_ADDRESS));
        assert pixel = '1' report "Pixel nicht auf 1";
        wait for 1 ns;

        report "Display Line of Low state";

        h_pos <= to_unsigned(400, 10); -- Should be 20th address if bit_width is 20
        v_pos <= to_unsigned(180, 10);  -- Should be the line 2th signal if row_heigth is 60 
        ram <= "10011001";

        wait until rising_edge(clk);
        wait for 1 ns;

        assert addr = std_ulogic_vector(to_unsigned(20, BIT_PER_ADDRESS));
        assert pixel = '1' report "Pixel nicht auf 1";
        wait for 1 ns;

        report "Display Low state";

        h_pos <= to_unsigned(400, 10); -- Should be 20th address if bit_width is 20
        v_pos <= to_unsigned(175, 10);  -- Should be 2th signal if row_heigth is 60 
        ram <= "10011001";

        wait until rising_edge(clk);
        wait for 1 ns;

        assert addr = std_ulogic_vector(to_unsigned(20, BIT_PER_ADDRESS));
        assert pixel = '0' report "Pixel  auf 1";
        wait for 1 ns;

        assert false report "End of Simulation" severity failure;
    end process;
    
end architecture manager_display_testbench_impl;
