library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity inverter is
    port(
        in_i     : in std_ulogic;
        out_o    : out std_ulogic
    );
end entity;

architecture inv of inverter is
    begin
        out_o <= not in_i;
    end architecture;