library ieee;
use ieee.std_logic_1164.all;

entity mux_reg is
    port (
        reg_0, reg_1, reg_2, reg_3, reg_4, reg_5, reg_6, reg_7 : in std_logic_vector(15 downto 0);
        Sel : in std_logic_vector(2 downto 0);
        data_out : out std_logic_vector(15 downto 0)
    );
end entity;

architecture structural of mux_reg is
    signal sel_lines : std_logic_vector(7 downto 0);
    signal mux_output : std_logic_vector(15 downto 0);
begin
    sel_lines(0) <= not(Sel(2)) and not(Sel(1)) and not(Sel(0));
    sel_lines(1) <= not(Sel(2)) and not(Sel(1)) and Sel(0);
    sel_lines(2) <= not(Sel(2)) and Sel(1) and not(Sel(0));
    sel_lines(3) <= not(Sel(2)) and Sel(1) and Sel(0);
    sel_lines(4) <= Sel(2) and not(Sel(1)) and not(Sel(0));
    sel_lines(5) <= Sel(2) and not(Sel(1)) and Sel(0);
    sel_lines(6) <= Sel(2) and Sel(1) and not(Sel(0));
    sel_lines(7) <= Sel(2) and Sel(1) and Sel(0);

    -- Multiplexer implementation
    mux_output <= (reg_0 and (15 downto 0 => sel_lines(0))) or
                  (reg_1 and (15 downto 0 => sel_lines(1))) or
                  (reg_2 and (15 downto 0 => sel_lines(2))) or
                  (reg_3 and (15 downto 0 => sel_lines(3))) or
                  (reg_4 and (15 downto 0 => sel_lines(4))) or
                  (reg_5 and (15 downto 0 => sel_lines(5))) or
                  (reg_6 and (15 downto 0 => sel_lines(6))) or
                  (reg_7 and (15 downto 0 => sel_lines(7)));

    -- Assign the output
    data_out <= mux_output;
end structural;
