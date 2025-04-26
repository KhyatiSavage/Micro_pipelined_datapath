library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity n_bit_adder_subtractor is
	port (
		a, b : in std_logic_vector(15 downto 0);
		m : in std_logic;
		s : out std_logic_vector(15 downto 0);
		c_out : out std_logic
	);
end entity n_bit_adder_subtractor;

architecture struct of n_bit_adder_subtractor is 

	component FullAdder_NAND is 
		port (A, B, C_i : in std_logic; S, C_o : out std_logic);
	end component FullAdder_NAND;
	
	signal x : std_logic_vector(15 downto 0);
	signal c : std_logic_vector(15 downto 0);
begin 

	inst1 : XOR_2 port map (A => m, B => b(0), Y => x(0));
	inst2 : FullAdder_NAND port map (A => a(0), B => x(0), C_i => m, S => s(0), C_o => c(0));

	loops : for i in 1 to 15 generate
		b1 : XOR_2 port map (A => m, B => b(i), Y => x(i));
		b2 : FullAdder_NAND port map (A => a(i), B => x(i), C_i => c(i-1), S => s(i), C_o => c(i));
	end generate ;
	
	c_out <= c(15) and (not m);
	
end architecture struct;
