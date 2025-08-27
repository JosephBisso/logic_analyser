library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter is
    Generic (
        -- Width of the timer value in bits
        -- The maximum value of the timer is 2**width - 1
        width : integer;
        COMPARE : unsigned
    );
    Port (
        -- Low aktiver reset
        rst_n       : in  std_ulogic;
        -- Clock
        clk         : in  std_ulogic;
        -- Active when timer value is equal to compare_i
        equal_o     : out std_ulogic;
        -- Active when timer value is greater than compare_i
        greater_o   : out std_ulogic
    );
end entity;

architecture rtl of counter is
    -- Internal counter value
    signal count_ff  : std_ulogic_vector(width - 1 downto 0);
    signal count_nxt : std_ulogic_vector(width - 1 downto 0);
begin

    seq : process (clk) is
    begin
        if rising_edge(clk) then
            if rst_n = '0' then
                count_ff <= (others => '0');
            else
                count_ff <= count_nxt; 
            end if;
        end if;
    end process;

    count : process (count_ff) is
    begin
        -- Default case hold counter value
        count_nxt <= std_ulogic_vector(unsigned(count_ff) + 1);
    end process;
    
    --equal_o <= '1' when to_unsigned(count_ff) >= COMPARE / 2 else '0';
    equal_o   <= '1' when unsigned(count_ff) >= COMPARE / 2 else '0';
    greater_o <= '1' when unsigned(count_ff) > COMPARE else '0';

end architecture;