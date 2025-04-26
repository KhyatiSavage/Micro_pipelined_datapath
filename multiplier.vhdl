library ieee;
use ieee.std_logic_1164.all;

library work;
use work.Gates.all;

entity multiplier_4x4 is
    port (
        a, b : in std_logic_vector(3 downto 0);  
        m    : out std_logic_vector(15 downto 0)  
    );
end entity multiplier_4x4;

architecture struct of multiplier_4x4 is

	component FullAdder_NAND is 
		port (A, B, C_i : in std_logic; S, C_o : out std_logic);
	end component FullAdder_NAND;

    signal par_pro : std_logic_vector(15 downto 0);  
    signal c : std_logic_vector(14 downto 0);   
    signal s : std_logic_vector(14 downto 0); 
	 
begin
    -- partial products
    par_pro(0)  <= a(0) and b(0);
    par_pro(1)  <= a(1) and b(0);
    par_pro(2)  <= a(2) and b(0);
    par_pro(3)  <= a(3) and b(0);
    par_pro(4)  <= a(0) and b(1);
    par_pro(5)  <= a(1) and b(1);
    par_pro(6)  <= a(2) and b(1);
    par_pro(7)  <= a(3) and b(1);
    par_pro(8)  <= a(0) and b(2);
    par_pro(9)  <= a(1) and b(2);
    par_pro(10) <= a(2) and b(2);
    par_pro(11) <= a(3) and b(2);
    par_pro(12) <= a(0) and b(3);
    par_pro(13) <= a(1) and b(3);
    par_pro(14) <= a(2) and b(3);
    par_pro(15) <= a(3) and b(3);

    m(0) <= par_pro(0);  

    ha1 : HALF_ADDER port map (A => par_pro(1), B => par_pro(4), S => m(1), C => c(0));
    fa1 : FullAdder_NAND port map (A => par_pro(2), B => par_pro(5), C_i => c(0), S => s(0), C_o => c(1));
	 fa2 : FullAdder_NAND port map (A => par_pro(3), B => par_pro(6), C_i => c(1), S => s(1), C_o => c(2));
	 fa3 : FullAdder_NAND port map (A => par_pro(7), B => par_pro(6), C_i => c(2), S => s(2), C_o => c(3));
	 
    ha2 : HALF_ADDER port map (A => s(0), B => par_pro(8), S => m(2), C => c(4));
    fa4 : FullAdder_NAND port map (A => s(1), B => par_pro(9), C_i => c(4), S => s(3), C_o => c(5));
    fa5 : FullAdder_NAND port map (A => s(2), B => par_pro(10), C_i => c(5), S => s(4), C_o => c(6));
    fa6 : FullAdder_NAND port map (A => c(3), B => par_pro(11), C_i => c(6), S => s(5), C_o => c(7));

	 ha3 : HALF_ADDER port map (A => par_pro(12), B => s(3), S => m(3), C => c(8));
    fa7 : FullAdder_NAND port map (A => par_pro(13), B => s(4), C_i => c(8), S => m(4), C_o => c(9));
    fa8 : FullAdder_NAND port map (A => par_pro(14), B => s(5), C_i => c(9), S => m(5), C_o => c(10));
    fa9 : FullAdder_NAND port map (A => par_pro(15), B => c(7), C_i => c(10), S => m(6), C_o => m(7));

	 m(15 downto 8) <= "00000000";

end architecture struct;