library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Testbench is
end entity Testbench;

architecture bhv of Testbench is
    -- Component declaration for the memory module
    component top is
	port (
		clk, reset, init : in std_logic;
		mem_init_data, mem_init_addr : in std_logic_vector(15 downto 0);
		c_out, z_out : out std_logic;
		y_presentt : out std_logic_vector(4 downto 0);
		T1_qt, T2_qt, IR_qt, PC_qt, SE_outt, RF_d1t, RF_d2t, RF_d3t, ALU_at, ALU_bt, ALU_ct, mem_data_outt : out std_logic_vector(15 downto 0)
		) ;
end component top;

    -- Signals to connect to the DUT
    signal clk_t, reset_t, init_t, c_out_t, z_out_t : std_logic;
    signal mem_init_data_t, mem_init_addr_t : std_logic_vector(15 downto 0);
    signal T1_qt_t, T2_qt_t, IR_qt_t, PC_qt_t, SE_outt_t : std_logic_vector(15 downto 0);
    signal RF_d1t_t, RF_d2t_t, RF_d3t_t : std_logic_vector(15 downto 0);
	 signal y_presentt_t : std_logic_vector(4 downto 0);
    signal ALU_at_t, ALU_bt_t, ALU_ct_t, mem_data_outt_t : std_logic_vector(15 downto 0);

begin
    -- Instantiate the memory module
    DUT : top
        port map (
            clk => clk_t, 
            reset => reset_t, 
            init => init_t, 
            mem_init_data => mem_init_data_t, 
            mem_init_addr => mem_init_addr_t, 
            c_out => c_out_t, 
            z_out => z_out_t,
            T1_qt => T1_qt_t, 
            T2_qt => T2_qt_t, 
            IR_qt => IR_qt_t, 
            PC_qt => PC_qt_t, 
            SE_outt => SE_outt_t, 
            RF_d1t => RF_d1t_t, 
            RF_d2t => RF_d2t_t, 
            RF_d3t => RF_d3t_t, 
            ALU_at => ALU_at_t, 
            ALU_bt => ALU_bt_t, 
            ALU_ct => ALU_ct_t, 
            mem_data_outt => mem_data_outt_t,
				y_presentt => y_presentt_t
        );

    -- Clock generation process
    clk_gen: process
    begin
        while true loop
            clk_t <= '0';
            wait for 10 ns;
            clk_t <= '1';
            wait for 10 ns;
        end loop;
    end process;

    -- Stimulus process for testing the memory
    stimulus: process
    begin
        -- Step 1: Reset the memory
        reset_t <= '1';
		  init_t <= '1';
		  mem_init_data_t <= x"0000";
		  mem_init_addr_t <= x"0000";
        wait for 20 ns;
        reset_t <= '0';
		  wait for 20 ns;
		  mem_init_data_t <= "1110000000010000"; --  j 16 -- jump 16 places
		  mem_init_addr_t <= x"0000";
		  wait for 20 ns;
        mem_init_data_t <= "0101010001100001"; -- 21601
		  mem_init_addr_t <= x"0001";
		  wait for 20 ns;
        mem_init_data_t <= "0110000000001011"; -- 24587 
		  mem_init_addr_t <= x"0002";
		  wait for 20 ns; 															-- reg 7 contains 0 on reset by default
        mem_init_data_t <= "1010000111000001"; -- lw reg 0, reg 7, 1 -- load 21601 in reg 0
		  mem_init_addr_t <= x"0010";
		  wait for 20 ns;
        mem_init_data_t <= "1010001111000010"; -- lw reg 1, reg 7, 2 -- load 24587 in reg 1
		  mem_init_addr_t <= x"0011";
		  wait for 20 ns;
		  mem_init_data_t <= "0000000001010000"; -- add reg 2, reg 0, reg 1 -- 1011010001101100
		  mem_init_addr_t <= x"0012";
		  wait for 20 ns;
		  mem_init_data_t <= "0001111011000111"; -- adi reg 3, reg 7, 7 -- reg 3 will contain 7 + contents of reg 7
		  mem_init_addr_t <= x"0013";
		  wait for 20 ns;
		  mem_init_data_t <= "0100011010100000"; -- and reg 4, reg 3, reg 2 -- 0000000000000111 and 111010001101100
		  mem_init_addr_t <= x"0014";													  -- reg 4 will contain 100
		  wait for 20 ns;
		  mem_init_data_t <= "1011100111000001"; --  sw reg 4, reg 7, 1 -- store data of reg 4 in mem address reg 7 + 1 
		  mem_init_addr_t <= x"0015";
		  wait for 20 ns;
		  mem_init_data_t <= "0010011100101000"; --  sub reg 5, reg 3, reg 4 -- reg 5 = reg 3 - reg 4 i.e. 3
		  mem_init_addr_t <= x"0016";
		  wait for 20 ns;
		  mem_init_data_t <= "1011101111000010"; --  sw reg 5, reg 7, 2 -- store data of reg 5 in mem address reg 7 + 2
		  mem_init_addr_t <= x"0017";
		  wait for 20 ns;
		  mem_init_data_t <= "0110000111110000"; --  imp reg 6, reg 0, reg 7 -- reg 6 = reg 0 => reg 7 i.e. 1010101110011110
		  mem_init_addr_t <= x"0018";
		  wait for 20 ns;
		  mem_init_data_t <= "0100110101100000"; --  and reg 4, reg 6, reg5 -- reg 4 = reg 6 and reg 5 i.e. 0000000000000010
		  mem_init_addr_t <= x"0019";
		  wait for 20 ns;
		  mem_init_data_t <= "1011100111000011"; --  sw reg 4, reg 7, 3  -- store data of reg 4 in mem address reg 7 + 3
		  mem_init_addr_t <= x"001A";
		  wait for 20 ns;
		  mem_init_data_t <= "0101001000000000"; --  ora reg 0, reg 1, reg 0 -- reg 0 = reg 1 or reg 0
		  mem_init_addr_t <= x"001B";
		  wait for 20 ns;
		  mem_init_data_t <= "0011001100000000"; --  mul reg 0, reg 1, reg 4 -- reg 0 = reg 1 * reg 4
		  mem_init_addr_t <= x"001C";
		  wait for 20 ns;
		  mem_init_data_t <= "1000001000000000"; --  lhi reg 1, F0H -- store 11110000 in upper 8 bits of reg 1 and 00000000 in lower 8 bits
		  mem_init_addr_t <= x"001D";
		  wait for 20 ns;
		  mem_init_data_t <= "1001000000000001"; --  lli reg 0, 01H -- store 00000001 in lower 8 bits of reg 0 and 00000000 in upper 8 bits
		  mem_init_addr_t <= x"001E";
		  wait for 20 ns;
		  mem_init_data_t <= "1011000111000100"; --  sw reg 0, reg 7, 4 -- store data of reg 0 in mem address reg 7 + 4
		  mem_init_addr_t <= x"001F";
		  wait for 20 ns;
		  mem_init_data_t <= "0001000001000010"; --  adi reg 1, reg 0, 2 -- store reg 0 (1) + 2 in reg 1 ie 3 (no. of times a loop has to run)
		  mem_init_addr_t <= x"0020";
		  wait for 20 ns;
		  mem_init_data_t <= "0001001010000001"; --  adi reg 2, reg 1, 1 -- store reg 1 (3) + 1 in reg 2 ie 4
		  mem_init_addr_t <= x"0021";
		  wait for 20 ns;
		  mem_init_data_t <= "1101110000000010"; --  jal reg 6, 2 -- 0022H will get stored in reg 6 and PC will be incremented by 2
		  mem_init_addr_t <= x"0022";
		  wait for 20 ns;
		  mem_init_data_t <= "0000001000001000"; --  add reg 1, reg 1, reg 0 -- will be SKIPPED always
		  mem_init_addr_t <= x"0023";
		  wait for 20 ns;
		  mem_init_data_t <= "1010100001000001"; --  lw reg 4, reg 1, 1 -- reg 4 will contain data in mem[4]
		  mem_init_addr_t <= x"0024";
		  wait for 20 ns;
		  mem_init_data_t <= "1011100010000001"; --  sw reg 4, reg 2, 1 -- mem[5] will now contain data in reg 4 ie mem[4]
		  mem_init_addr_t <= x"0025";
		  wait for 20 ns;
		  mem_init_data_t <= "1100001111000100"; --  beq reg 1, reg 7, 4 -- if reg 1 == reg 7 jump 4 places ie break
		  mem_init_addr_t <= x"0026";
		  wait for 20 ns;
		  mem_init_data_t <= "0000010000010000"; --  add reg 2, reg 2, reg 0 -- incrementing reg 2 
		  mem_init_addr_t <= x"0027";
		  wait for 20 ns;
		  mem_init_data_t <= "0010001000001000"; --  sub reg 1, reg 1, reg 0 -- decrement reg 1
		  mem_init_addr_t <= x"0028";
		  wait for 20 ns;
		  mem_init_data_t <= "1111101110000000"; --  jlr reg 5, reg 6 -- jump to location in reg 6
		  mem_init_addr_t <= x"0029";
		  wait for 20 ns;
		  init_t <= '0';
        wait;
    end process;
end bhv;
