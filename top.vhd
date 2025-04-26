library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.Gates.all;

entity top is
	port (
		clk, reset, init : in std_logic;
		mem_init_data, mem_init_addr : in std_logic_vector(15 downto 0);
		c_out, z_out : out std_logic;
		y_presentt : out std_logic_vector(4 downto 0);
		T1_qt, T2_qt, IR_qt, PC_qt, SE_outt, RF_d1t, RF_d2t, RF_d3t, ALU_at, ALU_bt, ALU_ct, mem_data_outt : out std_logic_vector(15 downto 0)
		) ;
end top;
	
	
architecture bhv of top is
	type state is (s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19); 
	signal y_present,y_next: state:=s0;
	signal w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, mem_write, mem_read,
				RF_enable, T1_enable, T2_enable, PC_enable, IR_enable, c, z, pro_clock : std_logic;
	signal mem_data_out, mem_addr, T1_d, T1_q, PC_d, PC_q, T2_d, T2_q, ALU_a,
				ALU_b, ALU_c, RF_d1, RF_d2, RF_d3, IR_q, SE_out : std_logic_vector(15 downto 0);
	signal ALU_ctrl, RF_a3 : std_logic_vector(2 downto 0);
	
	component memory is 
	port (
		mem_addr, mem_addr_init, mem_data_in, mem_data_init : in std_logic_vector(15 downto 0); 
		mem_data_out : out std_logic_vector(15 downto 0); 
		mem_read, mem_write, mem_clk, rst, init : in std_logic
	); 
end component memory;

	component D_flop is
    Port (clk, rst, D, en : in  std_logic; Q : out std_logic);
end component D_flop;

	component register_file is
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
end component register_file;

	component sign_extension is
    Port (
        IR_6 : in STD_LOGIC_VECTOR(5 downto 0); -- 6-bit input
        IR_9 : in STD_LOGIC_VECTOR(8 downto 0); -- 9-bit input
        w13 : in STD_LOGIC;                          -- Control signal
        output_signal : out STD_LOGIC_VECTOR(15 downto 0) -- 16-bit sign-extended output
    );
end component;
	component mux_16_4_1 is
	port (
	d,c,b,a : in std_logic_vector(15 downto 0); 
	sel : in std_logic_vector(1 downto 0); 
	Y : out std_logic_vector(15 downto 0)
	);
end component mux_16_4_1;

	component mux_16_2_1 is
	port (
	b,a : in std_logic_vector(15 downto 0); 
	sel : in std_logic; 
	Y : out std_logic_vector(15 downto 0)
	);
end component mux_16_2_1;

	component mux_3_4_1 is
	port (
	d,c,b,a : in std_logic_vector(2 downto 0); 
	sel : in std_logic_vector(1 downto 0); 
	Y : out std_logic_vector(2 downto 0)
	);	
end component mux_3_4_1;

	component reg16 is
	port (
	D : in std_logic_vector(15 downto 0); 
	clk, rst, en : in std_logic; 
	Q : out std_logic_vector(15 downto 0)
	);
end component reg16;

	component alu is
    port (
        a        : in  std_logic_vector(15 downto 0); 
        b        : in  std_logic_vector(15 downto 0); 
        alu_ctrl : in  std_logic_vector(2 downto 0);  -- Control signals 
        result   : out std_logic_vector(15 downto 0);
		  c,z      : out std_logic
    );
end component alu;
	
begin
	
	mem: memory port map (mem_addr => mem_addr, mem_addr_init => mem_init_addr, mem_data_in => T2_q, 
								mem_data_init => mem_init_data, mem_data_out => mem_data_out, mem_read => mem_read, 
								mem_write => mem_write, mem_clk => clk, init => init, rst => reset);
	M0: mux_16_2_1 port map (b => T1_q, a => PC_q, Y => mem_addr, sel => w0);
	T1: reg16 port map (clk => pro_clock, rst => reset, en => T1_enable, D => T1_d, Q => T1_q);
	T2: reg16 port map (clk => pro_clock, rst => reset, en => T2_enable, D => T2_d, Q => T2_q);
	PC: reg16 port map (clk => pro_clock, rst => reset, en => PC_enable, D => PC_d, Q => PC_q);
	M1: mux_16_4_1 port map (d => RF_d1, c => mem_data_out, b => ALU_c, a => SE_out, Y => T1_d, 
								sel(1) => w1, sel(0) => w2);
	M2: mux_16_2_1 port map (b => RF_d2, a => ALU_c, Y => PC_d, sel => w3);
	M3: mux_16_2_1 port map (b => RF_d2, a => RF_d1, Y => T2_d, sel => w10);
	M4: mux_16_4_1 port map (d => PC_q, c => T1_q, b => SE_out, a => x"0000", Y => RF_d3, 
								sel(1) => w4, sel(0) => w5);
	M5: mux_16_4_1 port map (d => PC_q, c => x"0007", b => T2_q, a => T1_q, Y => ALU_a, 
								sel(1) => w6, sel(0) => w7);
	M6: mux_16_4_1 port map (d => x"0001", c => T1_q, b => SE_out, a => T2_q, Y => ALU_b, 
								sel(1) => w8, sel(0) => w9);
	RF: Register_File port map (en => RF_enable, addr_r1 => IR_q(11 downto 9), addr_r2 => IR_q(8 downto 6),
								addr_w => RF_a3, data_out1 => RF_d1, data_out2 => RF_d2, data_in => RF_d3, clk => pro_clock, 
								rst => reset);
	M7: mux_3_4_1 port map (d => IR_q(11 downto 9), c => IR_q(8 downto 6), b => IR_q(5 downto 3), a => "000", 
								Y => RF_a3, sel(1) => w11, sel(0) => w12);
	IR: reg16 port map (clk => pro_clock, rst => reset, en => IR_enable, D => mem_data_out, Q => IR_q);
	SE16: sign_extension port map (IR_6 => IR_q(5 downto 0), IR_9 => IR_q(8 downto 0), w13 => w13, 
								output_signal => SE_out);
	alu_m: alu port map (a => ALU_a, b => ALU_b, alu_ctrl => ALU_ctrl, result => ALU_c, c => c, z => z);
	
	pro_clock <= (not init) and clk;
	c_out <= c;
	z_out <= z;
	T1_qt <= T1_q;
	T2_qt <= T2_q;
	IR_qt <= IR_q;
	PC_qt <= PC_q;
	SE_outt <= SE_out;
	RF_d1t <= RF_d1;
	RF_d2t <= RF_d2;
	RF_d3t <= RF_d3;
	ALU_at <= ALU_a;
	ALU_bt <= ALU_b;
	ALU_ct <= ALU_c;
	y_presentt <= "00000" when y_present = s0 else
                 "00001" when y_present = s1 else
                 "00010" when y_present = s2 else
                 "00011" when y_present = s3 else
                 "00100" when y_present = s4 else
                 "00101" when y_present = s5 else
                 "00110" when y_present = s6 else
                 "00111" when y_present = s7 else
                 "01000" when y_present = s8 else
                 "01001" when y_present = s9 else
                 "01010" when y_present = s10 else
                 "01011" when y_present = s11 else
                 "01100" when y_present = s12 else
                 "01101" when y_present = s13 else
                 "01110" when y_present = s14 else
                 "01111" when y_present = s15 else
                 "10000" when y_present = s16 else
                 "10001" when y_present = s17 else
                 "10010" when y_present = s18 else
                 "10011";
	mem_data_outt <= mem_data_out;
	
	pro_clock_proc:process(pro_clock,reset)
   begin
		if(pro_clock='1' and pro_clock' event) then
			if(reset='1') then
				y_present<=s0;
			else
				y_present<=y_next;
			end if;
		end if;
	end process;
	
	
	state_transition_proc:process(y_present,IR_q(15 downto 12), mem_data_out(15 downto 12),z)
	begin
	case y_present is
	
	 when S0 =>
	   if (mem_data_out(15 downto 12)="0000" or mem_data_out(15 downto 12)="1100" or mem_data_out(15 downto 12)="0010" or mem_data_out(15 downto 12)="0011" or mem_data_out(15 downto 12)="0100" or mem_data_out(15 downto 12)="0101" or mem_data_out(15 downto 12)="0110") then --addsub
			y_next<=s1;
		elsif (mem_data_out(15 downto 12)="0001") then --adi
			y_next<=s4;
		elsif (mem_data_out(15 downto 12)="1001") then --lli
			y_next<=s7;
		elsif (mem_data_out(15 downto 12)="1000") then --lhi
			y_next<=s8;
		elsif (mem_data_out(15 downto 12)="1010") then --lw
			y_next<=s10;
		elsif (mem_data_out(15 downto 12)="1011") then --sw
			y_next<=s10;
		elsif (mem_data_out(15 downto 12)="1110") then --j
			y_next<=s16;
		elsif (mem_data_out(15 downto 12)="1101") then --jal
			y_next<=s16;
		elsif (mem_data_out(15 downto 12)="1111") then --jlr
			y_next<=s19;
		else y_next<=s0;
		end if;
		
	 when s1 =>
		if (IR_q(15 downto 12)="1100") then
			y_next <= s14;
	    else y_next<=s2;
		 end if;
		 
	 when s2 =>
	    y_next<=s3;
		 
	 when s3 =>
	    y_next<=s0;
		 
	 when s4 =>
	    y_next<=s5;
		 
	 when s5 =>
	   if(IR_q(15 downto 12)="0001") then
			y_next<=s6;
		elsif(IR_q(15 downto 12)="1010") then
			y_next<=s11;
		elsif(IR_q(15 downto 12)="1011") then
			y_next<=s12;
		else y_next <= s0;
		end if;
		 
	 when s6 =>
	    y_next<=s0;
		 
	 when s7 =>
	    y_next<=s0;		 
		 
	 when s8 =>
	    y_next<=s9;		 
		 
	 when s9 =>
	    y_next<=s0;
		 
	 when s10 =>
	    y_next<=s5;

	 when s11 =>
	    y_next<=s9;		 
		 
	 when s12 =>
	    y_next<=s0;

	 when s13 =>
	    y_next<=s14;

	 when s14 =>
		if(z='1') then
			y_next<=s16;
		else
			y_next<=s0;
		end if;

	 when s15 =>
	    y_next<=s0;

	 when s16 => -- left
	   if(IR_q(15 downto 12)="1110") then
			y_next<=s17;
		elsif(IR_q(15 downto 12)="1100") then
			y_next<=s15;
		elsif(IR_q(15 downto 12)="1101") then
			y_next<=s18;
		else y_next<=s0;
		end if;

	 when s17 =>
	    y_next<=s0;

	 when s18 =>
	    y_next<=s0;

	 when s19 =>
	    y_next<=s0;

	end case;
	end process;
	
	
	
	
	
output_proc: process(y_present)
begin
    case y_present is

        when S0 =>
        mem_write <= '0';
        RF_enable <= '0';
        T1_enable <= '0';
        T2_enable <= '0';
        w0 <= '0';
        w1 <= '0';
        w2 <= '0';
        w3 <= '0';
        w4 <= '0';
        w5 <= '0';
        w10 <= '0';
        w11 <= '0';
        w12 <= '0';
        w13 <= '0';
            mem_read <= '1';
            IR_enable <= '1';
            ALU_ctrl <= "000";
            PC_enable <= '1';
            w6 <= '1';
            w7 <= '1';
            w8 <= '1';
            w9 <= '1';

        when S1 =>
		  mem_read <= '0';
        mem_write <= '0';
        IR_enable <= '0';
        PC_enable <= '0';
        RF_enable <= '0';
        w0 <= '0';
        w3 <= '0';
        w4 <= '0';
        w5 <= '0';
        w6 <= '0';
        w7 <= '0';
        w8 <= '0';
        w9 <= '0';
        w11 <= '0';
        w12 <= '0';
        w13 <= '0';
        ALU_ctrl <= "000";
            T1_enable <= '1';
            T2_enable <= '1';
            w1 <= '1';
            w2 <= '1';
            w10 <= '1';

        when S2 =>
		  mem_read <= '0';
        mem_write <= '0';
        IR_enable <= '0';
        PC_enable <= '0';
        RF_enable <= '0';
        T2_enable <= '0';
        w0 <= '0';
        w1 <= '0';
        w3 <= '0';
        w4 <= '0';
        w5 <= '0';
        w6 <= '0';
        w9 <= '0';
        w10 <= '0';
        w11 <= '0';
        w12 <= '0';
        w13 <= '0';
            T1_enable <= '1';
            w7 <= '0';
            w8 <= '0';
            w2 <= '1';
            ALU_ctrl <= IR_q(14 downto 12);  -- Add the specific ALU control value

        when S3 =>
		  mem_read <= '0';
        mem_write <= '0';
        IR_enable <= '0';
        PC_enable <= '0';
        T1_enable <= '0';
        T2_enable <= '0';
        w0 <= '0';
        w1 <= '0';
        w2 <= '0';
        w3 <= '0';
        w5 <= '0';
        w6 <= '0';
        w7 <= '0';
        w8 <= '0';
        w9 <= '0';
        w10 <= '0';
        w11 <= '0';
        w13 <= '0';
        ALU_ctrl <= "000";
            RF_enable <= '1';
            w4 <= '1';
            w12 <= '1';

        when S4 =>
		  mem_read <= '0';
        mem_write <= '0';
        IR_enable <= '0';
        PC_enable <= '0';
        RF_enable <= '0';
        w0 <= '0';
        w1 <= '0';
        w2 <= '0';
        w3 <= '0';
        w4 <= '0';
        w5 <= '0';
        w6 <= '0';
        w7 <= '0';
        w8 <= '0';
        w9 <= '0';
        w10 <= '0';
        w11 <= '0';
        w12 <= '0';
        ALU_ctrl <= "000";
            T1_enable <= '1';
            T2_enable <= '1';
            w13 <= '1';

        when S5 =>
		  mem_read <= '0';
        mem_write <= '0';
        IR_enable <= '0';
        PC_enable <= '0';
        RF_enable <= '0';
        w0 <= '0';
        w1 <= '0';
        w3 <= '0';
        w4 <= '0';
        w5 <= '0';
        w6 <= '0';
        w9 <= '0';
        w10 <= '0';
        w11 <= '0';
        w12 <= '0';
        w13 <= '0';
            T1_enable <= '1';
            T2_enable <= '1';
            ALU_ctrl <= "000";  -- Add ALU control value
            w7 <= '1';
            w8 <= '1';
            w2 <= '1';

        when S6 =>
		  mem_read <= '0';
        mem_write <= '0';
        IR_enable <= '0';
        PC_enable <= '0';
        T1_enable <= '0';
        T2_enable <= '0';
        w0 <= '0';
        w1 <= '0';
        w2 <= '0';
        w3 <= '0';
        w5 <= '0';
        w6 <= '0';
        w7 <= '0';
        w8 <= '0';
        w9 <= '0';
        w10 <= '0';
        w12 <= '0';
        w13 <= '0';
        ALU_ctrl <= "000";
            RF_enable <= '1';
            w4 <= '1';
            w11 <= '1';

        when S7 =>
		  mem_read <= '0';
        mem_write <= '0';
        IR_enable <= '0';
        PC_enable <= '0';
        T1_enable <= '0';
        T2_enable <= '0';
        w0 <= '0';
        w1 <= '0';
        w2 <= '0';
        w3 <= '0';
        w4 <= '0';
        w6 <= '0';
        w7 <= '0';
        w8 <= '0';
        w9 <= '0';
        w10 <= '0';
        w13 <= '0';
        ALU_ctrl <= "000";
            RF_enable <= '1';
            w5 <= '1';
            w11 <= '1';
            w12 <= '1';

        when S8 =>
		  mem_read <= '0';
        mem_write <= '0';
        IR_enable <= '0';
        PC_enable <= '0';
        RF_enable <= '0';
        T2_enable <= '0';
        w0 <= '0';
        w1 <= '0';
        w3 <= '0';
        w4 <= '0';
        w5 <= '0';
        w7 <= '0';
        w8 <= '0';
        w10 <= '0';
        w11 <= '0';
        w12 <= '0';
        w13 <= '0';
            T1_enable <= '1';
            ALU_ctrl <= "111";  -- Add ALU control value
            w2 <= '1';
            w6 <= '1';
            w9 <= '1';

        when S9 =>
		  mem_read <= '0';
        mem_write <= '0';
        IR_enable <= '0';
        PC_enable <= '0';
        T1_enable <= '0';
        T2_enable <= '0';
        w0 <= '0';
        w1 <= '0';
        w2 <= '0';
        w3 <= '0';
        w5 <= '0';
        w6 <= '0';
        w7 <= '0';
        w8 <= '0';
        w9 <= '0';
        w10 <= '0';
        w13 <= '0';
        ALU_ctrl <= "000";
            RF_enable <= '1';
            w4 <= '1';
            w11 <= '1';
            w12 <= '1';

        when S10 =>
		  mem_read <= '0';
        mem_write <= '0';
        IR_enable <= '0';
        PC_enable <= '0';
        RF_enable <= '0';
        w0 <= '0';
        w1 <= '0';
        w2 <= '0';
        w3 <= '0';
        w4 <= '0';
        w5 <= '0';
        w6 <= '0';
        w7 <= '0';
        w8 <= '0';
        w9 <= '0';
        w11 <= '0';
        w12 <= '0';
        ALU_ctrl <= "000";
            T1_enable <= '1';
            T2_enable <= '1';
            w10 <= '1';
            w13 <= '1';

        when S11 =>
        mem_write <= '0';
        IR_enable <= '0';
        PC_enable <= '0';
        RF_enable <= '0';
        T2_enable <= '0';
        w2 <= '0';
        w3 <= '0';
        w4 <= '0';
        w5 <= '0';
        w6 <= '0';
        w7 <= '0';
        w8 <= '0';
        w9 <= '0';
        w10 <= '0';
        w11 <= '0';
        w12 <= '0';
        w13 <= '0';
        ALU_ctrl <= "000";
            mem_read <= '1';
            T1_enable <= '1';
            w0 <= '1';
            w1 <= '1';

        when S12 =>
		  mem_read <= '0';
        IR_enable <= '0';
        PC_enable <= '0';
        RF_enable <= '0';
        T1_enable <= '0';
        T2_enable <= '0';
        w1 <= '0';
        w2 <= '0';
        w3 <= '0';
        w4 <= '0';
        w5 <= '0';
        w6 <= '0';
        w7 <= '0';
        w8 <= '0';
        w9 <= '0';
        w10 <= '0';
        w11 <= '0';
        w12 <= '0';
        w13 <= '0';
        ALU_ctrl <= "000";
            mem_write <= '1';
            w0 <= '1';

        when S13 =>
		  mem_read <= '0';
        mem_write <= '0';
        IR_enable <= '0';
        PC_enable <= '1';
        RF_enable <= '0';
        w0 <= '0';
        w3 <= '0';
        w4 <= '0';
        w5 <= '0';
        w10 <= '1';
        w11 <= '0';
        w12 <= '0';
        w13 <= '0';
            T1_enable <= '1';
            T2_enable <= '1';
            w1 <= '1';
            w2 <= '1';
            w6 <= '1';
            w7 <= '1';
            w8 <= '1';
            w9 <= '1';
            ALU_ctrl <= "010";  -- Add ALU control value

        when S14 =>
		  mem_read <= '0';
        mem_write <= '0';
        IR_enable <= '0';
        PC_enable <= '0';
        RF_enable <= '0';
        T1_enable <= '0';
        T2_enable <= '0';
        w0 <= '0';
        w1 <= '0';
        w2 <= '0';
        w3 <= '0';
        w4 <= '0';
        w5 <= '0';
        w6 <= '0';
        w9 <= '0';
        w10 <= '0';
        w11 <= '0';
        w12 <= '0';
        w13 <= '0';
            w7 <= '1';
            w8 <= '1';
            ALU_ctrl <= "000";  -- Add ALU control value

        when S15 =>
		  mem_read <= '0';
        mem_write <= '0';
        IR_enable <= '0';
        RF_enable <= '0';
        T1_enable <= '0';
        T2_enable <= '0';
        w0 <= '0';
        w1 <= '0';
        w2 <= '0';
        w3 <= '0';
        w4 <= '0';
        w5 <= '0';
        w8 <= '0';
        w10 <= '0';
        w11 <= '0';
        w12 <= '0';
            PC_enable <= '1';
            w6 <= '1';
            w7 <= '1';
            w9 <= '1';
            w13 <= '1';
            ALU_ctrl <= "000";  -- Add ALU control value

        when S16 =>
		  mem_read <= '0';
        mem_write <= '0';
        IR_enable <= '0';
        RF_enable <= '0';
        T1_enable <= '0';
        T2_enable <= '0';
        w0 <= '0';
        w1 <= '0';
        w2 <= '0';
        w3 <= '0';
        w4 <= '0';
        w5 <= '0';
        w10 <= '0';
        w11 <= '0';
        w12 <= '0';
        w13 <= '0';
            PC_enable <= '1';
            w6 <= '1';
            w7 <= '1';
            w8 <= '1';
            w9 <= '1';
            ALU_ctrl <= "010";  -- Add ALU control value

        when S17 =>
		  mem_read <= '0';
        mem_write <= '0';
        IR_enable <= '0';
        RF_enable <= '0';
        T1_enable <= '0';
        T2_enable <= '0';
        w0 <= '0';
        w1 <= '0';
        w2 <= '0';
        w3 <= '0';
        w4 <= '0';
        w5 <= '0';
        w8 <= '0';
        w10 <= '0';
        w11 <= '0';
        w12 <= '0';
        w13 <= '0';
            PC_enable <= '1';
            w6 <= '1';
            w7 <= '1';
            w9 <= '1';
            ALU_ctrl <= "000";  -- Add ALU control value

        when S18 =>
		  mem_read <= '0';
        mem_write <= '0';
        IR_enable <= '0';
        T1_enable <= '0';
        T2_enable <= '0';
        w0 <= '0';
        w1 <= '0';
        w2 <= '0';
        w3 <= '0';
        w8 <= '0';
        w10 <= '0';
        w13 <= '0';
            RF_enable <= '1';
            PC_enable <= '1';
            w4 <= '1';
            w5 <= '1';
            w6 <= '1';
            w7 <= '1';
            w9 <= '1';
            w11 <= '1';
            w12 <= '1';
            ALU_ctrl <= "000";  -- Add ALU control value

        when S19 =>
		  mem_read <= '0';
        mem_write <= '0';
        IR_enable <= '0';
        PC_enable <= '1';
        T1_enable <= '0';
        T2_enable <= '0';
        w0 <= '0';
        w1 <= '0';
        w2 <= '0';
        w6 <= '0';
        w7 <= '0';
        w8 <= '0';
        w9 <= '0';
        w10 <= '0';
        w13 <= '0';
        ALU_ctrl <= "000";
            RF_enable <= '1';
            w4 <= '1';
            w5 <= '1';
            w11 <= '1';
            w12 <= '1';
            w3 <= '1';

    end case;
end process;

end bhv;