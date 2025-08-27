library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity manager_ram_new is 
	generic(
        BIT_PER_DATA: integer:=8;
	    BIT_PER_ADDRESS: integer:=16
    ); 
	port(
		clk				: in std_ulogic;
		rst_n			: in std_ulogic;
        measure_i		: in std_ulogic;
        display_i		: in std_ulogic; 
		data_i    		: in std_ulogic_vector(BIT_PER_DATA-1 downto 0); 
		data_o 			: out std_ulogic_vector(BIT_PER_DATA-1 downto 0);
		addr_measure    : in std_ulogic_vector(BIT_PER_ADDRESS-1 downto 0); 
		addr_display    : in std_ulogic_vector(BIT_PER_ADDRESS-1 downto 0)
    ); 
end manager_ram_new;

architecture solve of manager_ram_new is
	type ram_type is array (0 to (2**BIT_PER_ADDRESS) - 1) of std_ulogic_vector(BIT_PER_DATA-1 downto 0); 
	signal tmp_ram: ram_type; 
	signal addr : std_ulogic_vector(BIT_PER_ADDRESS - 1 downto 0);

	begin
	process(clk, measure_i, display_i)
		begin 
            addr <= (others => '0');
			if(rising_edge(clk)) then
				if(rst_n = '0') then
					addr <= (others => '0');
					tmp_ram <= (others => (others => '0'));
				elsif (measure_i = '1') then
					addr <= addr_measure;
					tmp_ram(to_integer(unsigned(addr))) <= data_i;
				elsif (display_i = '1') then
					addr <= addr_display;
				end if;
			end if;
	end process; 

	data_o <= tmp_ram(to_integer(unsigned(addr))) when measure_i = '0' ;
end solve;