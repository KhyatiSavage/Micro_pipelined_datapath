library ieee;
use ieee.std_logic_1164.all;

library work;
use work.Gates.all;

entity mux_2_1 is
port ( I1, I0, S : in std_logic; Y : out std_logic);

end entity mux_2_1;

architecture struct of mux_2_1 is 
	signal S_1, I0_1, I1_1 : std_logic;
begin
N1 : INVERTER port map(A => S, Y => S_1);
A1 : AND_2 port map(A => I0, B => S_1, Y => I0_1);
A2 : AND_2 port map(A => I1, B => S, Y => I1_1);
O1 : OR_2 port map(A => I0_1, B => I1_1, Y => Y);
end struct;