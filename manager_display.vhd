library ieee;                                                                             
use ieee.std_logic_1164.all;                                                              
use ieee.numeric_std.all;    

entity manager_display is
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
end manager_display;

architecture manager_display_impl of manager_display is

    constant ZERO               : unsigned(10 downto 0) := (others => '0');
    constant D_WIDTH            : unsigned(10 downto 0) := ZERO + SCREEN_WIDTH;
    constant D_HEIGTH           : unsigned(10 downto 0) := ZERO + SCREEN_HEIGTH;

    constant V_SPACING         : integer := 10;
    constant ROW_HEIGTH         : unsigned(10 downto 0) := (D_HEIGTH/ 8);
    constant BIT_WIDTH          : unsigned(10 downto 0) := to_unsigned(to_integer(D_WIDTH) / MEASURE_TIME, 11);

    signal pos_to_measure     : std_ulogic_vector(BIT_PER_ADDRESS - 1 downto 0);
    signal pos_to_signal      : integer range 0 to BIT_PER_DATA - 1;
    signal pos_of_underline   : std_ulogic := '0';
    signal pos_of_row_spacing  : std_ulogic := '0';

    begin
        process (clk, enable_i, v_pos_i, h_pos_i)
        begin
            if rising_edge(clk) then
                if(enable_i = '1') then
                    -- report "h_pos_i = " & integer'image(to_integer(h_pos_i));
                    -- report "pos_to_measure = " & integer'image(to_integer(h_pos_i) / to_integer(BIT_WIDTH));

                    pos_to_measure <= std_ulogic_vector(to_unsigned(to_integer(h_pos_i) / to_integer(BIT_WIDTH), BIT_PER_ADDRESS));

                    pos_to_signal <= to_integer(v_pos_i) / to_integer(ROW_HEIGTH) mod 8;

                    --pos_of_underline <= '1' when (to_integer(v_pos_i) mod to_integer(ROW_HEIGTH)) = 0 else '0';
                    pos_of_underline <= '0';
                    if(v_pos_i /= to_unsigned(0, 10) and (to_integer(v_pos_i) mod to_integer(ROW_HEIGTH)) = 0) then
                        pos_of_underline <= '1';
                        -- report "pos_of_underline = " & integer'image(to_integer(unsigned(pos_of_underline)));
                    end if;
                    
                    pos_of_row_spacing <= '0';
                    if(to_integer(v_pos_i) mod to_integer(ROW_HEIGTH) > 0 and to_integer(v_pos_i) mod to_integer(ROW_HEIGTH) < 10) then
                        pos_of_row_spacing <= '1';
                    -- report "!! row_spacing = " & integer'image(row_spacing_px);
                    end if;

                    
                else
                    pos_to_measure <= (others => '0');
                    pos_to_signal <= 0;
                    pos_of_underline <= '0';
                    pos_of_row_spacing <= '0';
                end if;
            end if;
        end process;

        addr_o <= pos_to_measure;
        pixel_o <= '0' when (rst_n = '0' or pos_of_row_spacing = '1') else ram_i(pos_to_signal) when pos_of_underline = '0' else '1';

end architecture;
