library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity manager_measure is
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
end entity;

architecture manager_measure_impl of manager_measure is

    signal addr_ff              : std_ulogic_vector(BIT_PER_ADDRESS - 1 downto 0);
    signal addr_nxt            : std_ulogic_vector(BIT_PER_ADDRESS - 1 downto 0);
    signal done_ff              : std_ulogic;
    signal done_nxt              : std_ulogic;
begin

    seq : process (clk, rst_n) is
    begin
        if (rising_edge(clk)) then
            if (rst_n = '0' or measure_i = '0') then
                done_ff <= '0';
                addr_ff <= (others => '0');
            else
                done_ff <= done_nxt;
                addr_ff <= addr_nxt;
            end if;
        end if;
    end process;

    addressing : process (addr_ff) is
    begin
        done_nxt <= '0';
        if(addr_ff >= std_ulogic_vector(to_unsigned(MEASURE_TIME - 1, BIT_PER_ADDRESS))) then
            addr_nxt <= (others => '0');
            done_nxt <= '1';
        else
            addr_nxt <= std_ulogic_vector(unsigned(addr_ff) + 1);
        end if;
    end process;

    address_o <= addr_ff;
    done_o <= done_ff;
    --done_o <= (addr_nxt >= std_ulogic_vector(to_unsigned(MEASURE_TIME, BIT_PER_ADDRESS)));

end architecture;

