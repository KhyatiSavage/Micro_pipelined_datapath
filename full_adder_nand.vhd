library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity full_adder_nand is 
	port (A, B, C_in: in std_logic; S, C_out : out std_logic);
end entity full_adder_nand;

architecture struct of full_adder_nand is 
	signal w_1, w_2, AB_not : std_logic;
	
	component xor_using_nand is
     port(A, B: in std_logic;
         Y: out std_logic);
   end component;
	
	begin
	N_1 : xor_using_nand port map (A => A, B => B, Y => w_1);
	N_2 : xor_using_nand port map (A => w_1, B => C_in, Y => S);
	N_3 : NAND_2 port map (A => C_in, B => w_1, Y => w_2);
	N_4 : NAND_2 port map (A => A, B => B, Y => AB_not);
	N_5 : NAND_2 port map (A => w_2, B => AB_not, Y => C_out);
end struct;