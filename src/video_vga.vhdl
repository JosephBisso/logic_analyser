library ieee;                                                                             
use ieee.std_logic_1164.all;                                                              
use ieee.numeric_std.all;    

entity vga is 
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
end entity;

architecture impl of vga is

constant ZERO             : unsigned(10 downto 0) := (others => '0');
constant h_active         : unsigned(10 downto 0) := ZERO + SCREEN_WIDTH;
constant h_front_porch    : unsigned(10 downto 0) := h_active        + 16;
constant h_sync_pulse     : unsigned(10 downto 0) := h_front_porch   + 96;
constant h_back_porch     : unsigned(10 downto 0) := h_sync_pulse    + 48 -1; 
constant v_active         : unsigned(10 downto 0) := ZERO + SCREEN_HEIGTH;
constant v_front_porch    : unsigned(10 downto 0) := v_active        + 10;
constant v_sync_pulse     : unsigned(10 downto 0) := v_front_porch   + 2;
constant v_back_porch     : unsigned(10 downto 0) := v_sync_pulse    + 33 - 1;

type pixel_buffer_type is array (0 to 63) of std_logic_vector(31 downto 0);
signal pixel_buffer       : pixel_buffer_type;
signal pixel_cnt          : unsigned(5  downto 0) := (others => '0');
signal clk_divider        : unsigned(1  downto 0) := (others => '0');
signal h_cnt              : unsigned(10 downto 0) := (others => '0');
signal v_cnt              : unsigned(10 downto 0) := (others => '0');

begin 

vga_clocking: process (clk)
begin
    if rising_edge(clk) then
        clk_divider <= clk_divider + 1;
        if clk_divider = 4 - 1 then -- 102Mhz ACLK input clock required
            clk_divider <= (others => '0');

            
            if v_cnt >= v_active or h_cnt >= h_active then 
                r_o <= (others => '0');
                g_o <= (others => '0');
                b_o <= (others => '0');
            else -- active video
            	r_o <= (others => pixel_i);
            	g_o <= (others => pixel_i);
            	b_o <= (others => pixel_i);
            end if;
            
            h_cnt <= h_cnt + 1;
            if h_cnt = h_back_porch then
                h_cnt <= (others => '0');
                v_cnt <= v_cnt + 1;
                if v_cnt = v_back_porch then
                    v_cnt <= (others => '0');
                end if;
            end if;
        end if;
    end if;
end process;

vs <= '1' when v_cnt >= v_front_porch and v_cnt <= v_sync_pulse else '0';
hs <= '1' when h_cnt >= h_front_porch and h_cnt <= h_sync_pulse else '0';

h_pos_o <= h_cnt(9 downto 0);
v_pos_o <= v_cnt(9 downto 0);
end impl;
