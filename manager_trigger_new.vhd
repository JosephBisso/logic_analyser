library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity manager_trigger_new is
    Generic(
        NUM_SIGNAL      : integer := 8;
        TRIGGER_WIDTH   : integer := 4
    );
    port (
        rst_n           : in  std_ulogic;
        clk             : in  std_ulogic;
        signal_i        : in  std_ulogic_vector(NUM_SIGNAL -1 downto 0);
        trigger_set_i   : in  std_ulogic_vector(TRIGGER_WIDTH - 1 downto 0);
        trigger_flank_i : in  std_ulogic_vector(TRIGGER_WIDTH - 1 downto 0);
        triggered_o     : out std_ulogic
    );
end entity;

architecture rtl of manager_trigger_new is

    signal signal_ff : std_ulogic_vector(TRIGGER_WIDTH-1 downto 0);
    signal signal_nxt : std_ulogic_vector(TRIGGER_WIDTH-1 downto 0);
    signal is_rising_egde: std_ulogic_vector(TRIGGER_WIDTH-1 downto 0);

begin

    seq : process (clk, rst_n) is
    begin
        if (rising_edge(clk)) then 
			if (rst_n='0') then
                signal_ff <= (others => '0');
            else
                signal_ff <= signal_nxt;
			end if; 
		end if; 
    end process;

    flank : process (signal_ff, signal_i, trigger_set_i, trigger_flank_i) is
    begin
        signal_nxt <= (signal_i(TRIGGER_WIDTH - 1 downto 0) and trigger_set_i) xor trigger_flank_i;
    end process;

    triggered_o <= '1' when (signal_nxt and (not signal_ff)) /= std_ulogic_vector(to_unsigned (0,TRIGGER_WIDTH))  else '0';

end architecture;