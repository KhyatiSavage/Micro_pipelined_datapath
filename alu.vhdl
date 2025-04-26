library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;

entity alu is
    port (
        a        : in  std_logic_vector(15 downto 0); 
        b        : in  std_logic_vector(15 downto 0); 
        alu_ctrl : in  std_logic_vector(2 downto 0);  -- Control signals 
        result   : out std_logic_vector(15 downto 0); 
		  c,z      : out std_logic
    );
end alu;

architecture behavioral of alu is

    function logic_and(x, y : in std_logic_vector(15 downto 0)) return std_logic_vector is
        variable res : std_logic_vector(15 downto 0);
    begin
        for i in 0 to 15 loop
            res(i) := x(i) and y(i);
        end loop;
        return res;
    end function;

    function logic_or(x, y : std_logic_vector(15 downto 0)) return std_logic_vector is
        variable res : std_logic_vector(15 downto 0);
    begin
        for i in 0 to 15 loop
            res(i) := x(i) or y(i);
        end loop;
        return res;
    end function;

    function logic_imp(x, y : std_logic_vector(15 downto 0)) return std_logic_vector is
        variable res : std_logic_vector(15 downto 0);
    begin
        for i in 0 to 15 loop
            res(i) := not x(i) or y(i);
        end loop;
        return res;
    end function;

    function shift(x : std_logic_vector(15 downto 0)) return std_logic_vector is
        variable res : std_logic_vector(15 downto 0);
    begin
        for i in 0 to 7 loop
            res(i + 8) := x(i);
        end loop;
        res(7 downto 0) := "00000000";  
        return res;
    end function;

    component n_bit_adder_subtractor is
		port (
			a, b : in std_logic_vector(15 downto 0);
			m : in std_logic;
			s : out std_logic_vector(15 downto 0);
			c_out : out std_logic
		);
end component n_bit_adder_subtractor;

	component multiplier_4x4 is
    port (
        a, b : in std_logic_vector(3 downto 0);  
        m    : out std_logic_vector(15 downto 0)  
    );
end component multiplier_4x4;

	component mux_16_8_1 is
	port (
		h,g,f,e,d,c,b,a : in std_logic_vector(15 downto 0); 
		sel : in std_logic_vector(2 downto 0); 
		Y : out std_logic_vector(15 downto 0)
	);
	end component mux_16_8_1;

	signal t1, t2, t3, t4, t5, t6, t7, result_t : std_logic_vector(15 downto 0);
	signal c_temp : std_logic;
begin
	
	t1 <= logic_and(a,b);
	t2 <= logic_or(a,b);
	t3 <= logic_imp(a,b);
	t4 <= shift(a);
	t7 <= t5;
	result <= result_t;
	
	RCAS : n_bit_adder_subtractor port map (a => a, b => b, m => alu_ctrl(1), s => t5, c_out => c_temp);
	c <= c_temp and (not (alu_ctrl(2) or alu_ctrl(0)));
	Mult : multiplier_4x4 port map (a => a(3 downto 0), b => b(3 downto 0), m => t6);
	
	mux : mux_16_8_1 port map(a => t5, b => x"0000", c => t7, d => t6, e => t1, f => t2, g => t3, h => t4, sel => alu_ctrl, Y => result_t);
	z <= not (
        result_t(0) or
        result_t(1) or
        result_t(2) or
        result_t(3) or
        result_t(4) or
        result_t(5) or
        result_t(6) or
        result_t(7) or
        result_t(8) or
        result_t(9) or
        result_t(10) or
        result_t(11) or
        result_t(12) or
        result_t(13) or
        result_t(14) or 
		  result_t(15)
    );
	
end behavioral;
