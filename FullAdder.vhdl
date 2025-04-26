library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity FullAdder_NAND is
	port (A, B, C_i : in std_logic; S, C_o : out std_logic);
end entity FullAdder_NAND;

architecture struct of FullAdder_NAND is 
	signal S1, S2, S3, S4, S5 : std_Logic;
begin
	-- Sum = A xor B xor C_i
	
	inst1 : XOR_2 port map(A => A, B => B, Y => S1);
	inst2 : XOR_2 port map(A => S1, B => C_i, Y => S);
	
	-- Carry = (A and B) or (A and C_i) or (B and C_i)
	
	inst3 : AND_2 port map(A => A, B => B, Y => S2);
	inst4 : AND_2 port map(A => A, B => C_i, Y => S3);
	inst5 : AND_2 port map(A => B, B => C_i, Y => S4);
	
	inst6 : OR_2 port map(A => S2, B => S3, Y => S5);
	inst7 : OR_2 port map(A => S5, B => S4, Y => C_o);
end architecture struct;
