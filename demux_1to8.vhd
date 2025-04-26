library ieee;
use ieee.std_logic_1164.all;

entity demux_1to8 is
    port (
        data_in : in std_logic;                 -- Single input
        Sel : in std_logic_vector(2 downto 0); -- 3-bit selector
        Y : out std_logic_vector(7 downto 0)   -- 8 outputs
    );
end entity;

architecture structural of demux_1to8 is
    -- Internal signals for decoded selection lines
    signal sel_lines : std_logic_vector(7 downto 0);
begin
    -- Decode the 3-bit selection into 8 one-hot lines using AND gates
    sel_lines(0) <= not(Sel(2)) and not(Sel(1)) and not(Sel(0));
    sel_lines(1) <= not(Sel(2)) and not(Sel(1)) and Sel(0);
    sel_lines(2) <= not(Sel(2)) and Sel(1) and not(Sel(0));
    sel_lines(3) <= not(Sel(2)) and Sel(1) and Sel(0);
    sel_lines(4) <= Sel(2) and not(Sel(1)) and not(Sel(0));
    sel_lines(5) <= Sel(2) and not(Sel(1)) and Sel(0);
    sel_lines(6) <= Sel(2) and Sel(1) and not(Sel(0));
    sel_lines(7) <= Sel(2) and Sel(1) and Sel(0);

    -- Route data_in to the selected output using AND gates
    Y(0) <= data_in and sel_lines(0);
    Y(1) <= data_in and sel_lines(1);
    Y(2) <= data_in and sel_lines(2);
    Y(3) <= data_in and sel_lines(3);
    Y(4) <= data_in and sel_lines(4);
    Y(5) <= data_in and sel_lines(5);
    Y(6) <= data_in and sel_lines(6);
    Y(7) <= data_in and sel_lines(7);
end structural;
