library ieee;
use ieee.std_logic_1164.all;

library work;
use work.Gates.all;

entity mux_16_2_1 is
	port (
	b,a : in std_logic_vector(15 downto 0); 
	sel : in std_logic; 
	Y : out std_logic_vector(15 downto 0)
	);
	
end entity mux_16_2_1;

architecture struct of mux_16_2_1 is
	component mux_2_1 is
		port ( I1, I0, S : in std_logic; Y : out std_logic);
	end component mux_2_1;
begin

n16_bit : for i in 0 to 15 generate
	lsb: if i < 16 generate
		b2: mux_2_1 port map (I1 => b(i), I0 => a(i),S => sel, Y => Y(i));
	end generate lsb;
end generate ;
end struct;