library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file is
    port (
        clk : in std_logic;                       
        rst : in std_logic;                        -- Reset signal
        en  : in std_logic;                        -- Enable signal for writing
        addr_w : in std_logic_vector(2 downto 0);  -- 3-bit write address
        addr_r1 : in std_logic_vector(2 downto 0); -- 3-bit read address 1
        addr_r2 : in std_logic_vector(2 downto 0); -- 3-bit read address 2
        data_in : in std_logic_vector(15 downto 0); -- Data to be written/ D3
        data_out1 : out std_logic_vector(15 downto 0); -- Data read from addr_r1/ D1
        data_out2 : out std_logic_vector(15 downto 0)  -- Data read from addr_r2/ D2
    );
end entity register_file;

architecture struct of register_file is

    type reg_array_type is array (0 to 7) of std_logic_vector(15 downto 0);	 
    signal reg_outputs : reg_array_type; 
	 signal enable : std_logic_vector(7 downto 0);

begin

	demux : entity work.demux_1to8 
		port map (
			data_in => en,
			Sel => addr_w,
			Y => enable);
	
    -- Generate 8 registers
    gen_regs : for i in 0 to 7 generate
        reg_inst : entity work.reg16
            port map (
                D => data_in,
                clk => clk,
                rst => rst,
                en => enable(i),
                Q => reg_outputs(i)
            );
    end generate gen_regs;

	 data_D1 : entity work.mux_reg
		port map (
				reg_0 => reg_outputs(0),
				reg_1 => reg_outputs(1),
				reg_2 => reg_outputs(2),
				reg_3 => reg_outputs(3),
				reg_4 => reg_outputs(4),
				reg_5 => reg_outputs(5),
				reg_6 => reg_outputs(6),
				reg_7 => reg_outputs(7),
				sel => addr_r1,
				data_out => data_out1);
			
		
	 data_D2 : entity work.mux_reg
		port map (
				reg_0 => reg_outputs(0),
				reg_1 => reg_outputs(1),
				reg_2 => reg_outputs(2),
				reg_3 => reg_outputs(3),
				reg_4 => reg_outputs(4),
				reg_5 => reg_outputs(5),
				reg_6 => reg_outputs(6),
				reg_7 => reg_outputs(7),
				sel => addr_r2,
				data_out => data_out2);	
				
end architecture struct;
