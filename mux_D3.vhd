library ieee;
use ieee.std_logic_1164.all;

entity mux_D3 is
    port (
        pc_q : in std_logic_vector(15 downto 0);
        t1_q : in std_logic_vector(15 downto 0);
        se_out : in std_logic_vector(15 downto 0);
        Sel : in std_logic_vector(1 downto 0);
        RF_D3 : out std_logic_vector(15 downto 0)
    );
end entity;

architecture structural of mux_D3 is
    signal sel_lines : std_logic_vector(3 downto 0); -- One-hot signals for selection
    signal mux_output : std_logic_vector(15 downto 0);
begin
    -- Decode Sel into one-hot encoding
    sel_lines(0) <= not Sel(1) and not Sel(0);
    sel_lines(1) <= not Sel(1) and Sel(0);
    sel_lines(2) <= Sel(1) and not Sel(0);
    sel_lines(3) <= Sel(1) and Sel(0);
	 
    -- Structural multiplexer implementation
    mux_output <= (pc_q and (others => sel_lines(3))) or
                  (t1_q and (others => sel_lines(2))) or
                  (se_out and (others => sel_lines(1))) or
                  (others => sel_lines(0)); -- "00" case (default zeroes)

    -- Assign to output
    RF_D3 <= mux_output;
end structural;
