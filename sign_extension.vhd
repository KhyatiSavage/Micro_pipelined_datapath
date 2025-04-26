library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sign_extension is
    Port (
        IR_6 : in STD_LOGIC_VECTOR(5 downto 0); -- 6-bit input
        IR_9 : in STD_LOGIC_VECTOR(8 downto 0); -- 9-bit input
        w13 : in STD_LOGIC;                          -- Control signal
        output_signal : out STD_LOGIC_VECTOR(15 downto 0) -- 16-bit sign-extended output
    );
end entity;

architecture Behavioral of sign_extension is
begin
    process(IR_6, IR_9, w13)
    begin
            if w13 = '1' then
                -- Sign-extend signal_one to 16 bits
                if IR_6(5) = '1' then
                    -- MSB is 1, extend with 1s
                    output_signal(15 downto 6) <= "1111111111";
						  output_signal(5 downto 0) <= IR_6;
                else
                    -- MSB is 0, extend with 0s
						  output_signal(15 downto 6) <= "0000000000";
                    output_signal(5 downto 0) <= IR_6;
                end if;
            else
                -- Sign-extend signal_two to 16 bits
                if IR_9(8) = '1' then
                    -- MSB is 1, extend with 1s
						  output_signal(15 downto 9) <= "1111111";
                    output_signal(8 downto 0) <= IR_9;
                else
                    -- MSB is 0, extend with 0s
                    output_signal(15 downto 9) <= "0000000";
                    output_signal(8 downto 0) <= IR_9;
                end if;
            end if;
    end process;
end Behavioral;
