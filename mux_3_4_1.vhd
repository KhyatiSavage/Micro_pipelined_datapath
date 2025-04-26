library ieee;
use ieee.std_logic_1164.all;

library work;
use work.Gates.all;

entity mux_3_4_1 is
	port (
	d,c,b,a : in std_logic_vector(2 downto 0); 
	sel : in std_logic_vector(1 downto 0); 
	Y : out std_logic_vector(2 downto 0)
	);
	
end entity mux_3_4_1;

architecture struct of mux_3_4_1 is
	component mux_4_2 is
		port ( In4, In3, In2, In1, S2, S1 : in std_logic; Y : out std_logic);
	end component;
begin

n16_bit : for i in 0 to 2 generate
	lsb: if i < 3 generate
		b2: mux_4_2 port map (In4 => d(i), In3 => c(i), In2 => b(i), In1 => a(i), S2 => sel(1), S1 => sel(0), Y => Y(i));
	end generate lsb;
end generate ;
end struct;