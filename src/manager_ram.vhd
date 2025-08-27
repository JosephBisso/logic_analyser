library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity manager_ram is 
	generic(
        BIT_PER_DATA: integer:=8;
	    BIT_PER_ADDRESS: integer:=8
    ); 
	port(
		clk:        in std_ulogic; 
		read_write: in std_ulogic; 
		addr :      in std_ulogic_vector(BIT_PER_ADDRESS-1 downto 0); 
		Din :       in std_ulogic_vector(BIT_PER_DATA-1 downto 0);
		Dout :      out std_ulogic_vector(BIT_PER_DATA-1 downto 0)
    ); 
end manager_ram;

architecture solve of manager_ram is

	type ram_type is array (0 to (2**BIT_PER_ADDRESS)-1) of std_ulogic_vector(BIT_PER_DATA-1 downto 0); 
	signal tmp_ram: ram_type; 

	begin
	process(clk, read_write)
		begin 
			if (rising_edge(clk)) then 
				if read_write='1' then --write
					tmp_ram(to_integer(unsigned(addr))) <= Din; 
				end if; 
			end if; 
	end process; 

	Dout <= tmp_ram(to_integer(unsigned(addr)));--read
end solve;