library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tester is
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

        out_o       : out std_ulogic_vector(width-1 downto 0)
    );
end entity;

architecture rtl of tester is
    -- Internal counter valuesignal 
signal clk_divider        : unsigned(width-1  downto 0) := (others => '0');

begin

    seq : process (clk) is
    begin
        if rising_edge(clk) then
            if rst_n = '0' then
                clk_divider <= (others => '0');
            else
                clk_divider <= clk_divider + 1;
                if clk_divider = COMPARE then
                    clk_divider <= (others => '0');
                end if;
            end if;
        end if;
    end process;

    out_o <= std_ulogic_vector(clk_divider);

end architecture;