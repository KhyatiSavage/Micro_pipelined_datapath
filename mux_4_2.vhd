library ieee;
use ieee.std_logic_1164.all;

library work;
use work.Gates.all;

entity mux_4_2 is
port ( In4, In3, In2, In1, S2, S1 : in std_logic; Y : out std_logic);
end entity mux_4_2;

architecture struct of mux_4_2 is
	signal w_1, w_2 : std_logic;
	component mux_2_1 is
		port ( I1, I0, S : in std_logic; Y : out std_logic);
	end component;
begin

M0 : mux_2_1 port map (I0 => In1, I1 => In2, S => S1, Y => w_1);
M1 : mux_2_1 port map (I0 => In3, I1 => In4, S => S1, Y => w_2);
M2 : mux_2_1 port map (I0 => w_1, I1 => w_2, S => S2, Y => Y);

end struct;