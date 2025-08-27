library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity manager_trigger is
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
        triggered_set_o : out  std_ulogic_vector(TRIGGER_WIDTH - 1 downto 0);
        trigger_flank_o : out  std_ulogic_vector(TRIGGER_WIDTH - 1 downto 0);
        triggered_o     : out std_ulogic
    );
end entity;

architecture rtl of manager_trigger is

    component edge_detector is
        port (
            rst_n         : in std_ulogic;
            clk           : in std_ulogic;
            input_i       : in std_ulogic;
            rising_edge_o : out std_ulogic 
        );
    end component edge_detector;


    signal signal_ff : std_ulogic_vector(TRIGGER_WIDTH-1 downto 0);
    signal signal_nxt : std_ulogic_vector(TRIGGER_WIDTH-1 downto 0);
    signal is_rising_edge: std_ulogic_vector(TRIGGER_WIDTH-1 downto 0);
    signal triggered_vec : std_ulogic_vector(TRIGGER_WIDTH-1 downto 0);
    signal flanken_vec : std_ulogic_vector(TRIGGER_WIDTH-1 downto 0);
begin

    gen_edges : for i in 0 to TRIGGER_WIDTH - 1 generate
    edge_detector_inst : edge_detector
        port map (
            rst_n         => rst_n,
            clk           => clk,
            input_i       => signal_i(i),
            rising_edge_o => is_rising_edge(i)
        );
    end generate;


    read : process (clk, rst_n,trigger_set_i,signal_i,is_rising_edge,trigger_flank_i) is
    begin

        if rst_n = '0' then
            triggered_vec <= (others => '0');
            flanken_vec   <= (others => '0');
        elsif rising_edge(clk) then
            triggered_vec <= signal_i(TRIGGER_WIDTH-1 downto 0) and trigger_set_i;
            flanken_vec   <= is_rising_edge xor trigger_flank_i;
        end if;


        triggered_set_o <= triggered_vec;
        trigger_flank_o <= flanken_vec;
    end process;

    triggered_o <= '1' when (triggered_vec and flanken_vec) /= std_ulogic_vector(to_unsigned(0, TRIGGER_WIDTH)) else '0';


end architecture;