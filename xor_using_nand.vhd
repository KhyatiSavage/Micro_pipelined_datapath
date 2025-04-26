library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity xor_using_nand is 
	port (A, B : in std_logic; Y : out std_logic);
end entity xor_using_nand;

architecture struct of xor_using_nand is 
	signal A_bar, B_bar, w_1, w_2 : std_logic;
	
	begin
	N_1 : NAND_2 port map (A => A, B => A, Y => A_bar);
	N_2 : NAND_2 port map (A => B, B => B, Y => B_bar);
	N_3 : NAND_2 port map (A => A, B => B_bar, Y => w_1);
	N_4 : NAND_2 port map (A => A_bar, B => B, Y => w_2);
	N_5 : NAND_2 port map (A => w_1, B => w_2, Y => Y);
end struct;