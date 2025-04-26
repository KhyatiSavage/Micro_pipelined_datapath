library ieee;
use ieee.std_logic_1164.all;

library work;
use work.Gates.all;

entity reg16 is
	port (
	D : in std_logic_vector(15 downto 0); 
	clk, rst, en : in std_logic; 
	Q : out std_logic_vector(15 downto 0)
	);
	
end entity reg16;

architecture struct of reg16 is
	component D_flop is
    Port (clk, rst, D, en : in  std_logic; Q : out std_logic);
end component D_flop;
begin

n16_bit : for i in 0 to 15 generate
	lsb: if i < 16 generate
		b2: D_flop port map (clk => clk, rst => rst, en => en, D => D(i), Q => Q(i));
	end generate lsb;
end generate ;
end struct;