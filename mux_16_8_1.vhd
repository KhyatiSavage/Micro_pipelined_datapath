library ieee;
use ieee.std_logic_1164.all;

library work;
use work.Gates.all;

entity mux_16_8_1 is
	port (
	h,g,f,e,d,c,b,a : in std_logic_vector(15 downto 0); 
	sel : in std_logic_vector(2 downto 0); 
	Y : out std_logic_vector(15 downto 0)
	);
	
end entity mux_16_8_1;

architecture struct of mux_16_8_1 is
	component mux_8_3 is
		port ( In8, In7, In6, In5, In4, In3, In2, In1, S3, S2, S1 : in std_logic; Y : out std_logic);
	end component mux_8_3;
begin

n16_bit : for i in 0 to 15 generate
	lsb: if i < 16 generate
		b2: mux_8_3 port map (In8 => h(i), In7 => g(i), In6 => f(i), In5 => e(i), In4 => d(i), In3 => c(i), 
									In2 => b(i), In1 => a(i), S3 => sel(2), S2 => sel(1), S1 => sel(0), Y => Y(i));
	end generate lsb;
end generate ;
end struct;