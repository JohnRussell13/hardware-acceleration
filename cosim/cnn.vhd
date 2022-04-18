library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--use work.utils_pkg.all;

entity cnn is
    generic(
        WIDTH: integer := 32);
    port(
 --------------- Clocking and reset interface ---------------
        clk: in std_logic;
 --------------- Status interface ---------------
        start: in std_logic;
        ready: out std_logic;
 ------------------- Input data interface -------------------
 -- BRAM port A address and data
        addra: in std_logic_vector(31 downto 0);    -- Write address bus, width determined from RAM_DEPTH
        dina: in std_logic_vector(31 downto 0);    -- RAM input data
        wea: in std_logic_vector(2*WIDTH-1 downto 0);      -- Write enable
 ------------------- Output data interface ------------------
 -- Result interface
        r_o_0: out std_logic_vector(WIDTH-1 downto 0);
        r_o_1: out std_logic_vector(WIDTH-1 downto 0);
        r_o_2: out std_logic_vector(WIDTH-1 downto 0);
        r_o_3: out std_logic_vector(WIDTH-1 downto 0);
        r_o_4: out std_logic_vector(WIDTH-1 downto 0);
        r_o_5: out std_logic_vector(WIDTH-1 downto 0);
        r_o_6: out std_logic_vector(WIDTH-1 downto 0);
        r_o_7: out std_logic_vector(WIDTH-1 downto 0);
        r_o_8: out std_logic_vector(WIDTH-1 downto 0);
        r_o_9: out std_logic_vector(WIDTH-1 downto 0));
end entity;
architecture beh of cnn is


    
    function log2c (n: integer) return integer is
        variable m, p: integer;
        begin
        m := 0;
        p := 1;
        while p < n loop
            m := m + 1;
            p := p * 2;
        end loop;
        return m;
    end log2c;




    constant WHOLE: integer := 8;
    constant FRACT: integer := 11;
    constant BRAM_COUNT_0: integer := 34; -- 16 + 9 + 10 - 1
    constant BRAM_COUNT_1: integer := 25; -- 16 + 9 + 10 - 1
    constant BRAM_COUNT_2: integer := 35; -- 16 + 9 + 10 - 1

    constant AXI_WIDTH : integer := 32;    -- Specify RAM data width
    constant RAM_WIDTH : integer := 19;    -- Specify RAM data width
    constant RAM_DEPTH_0 : integer := 169; -- img: 13x13  
    constant RAM_DEPTH_1 : integer := 32; -- conv
    constant RAM_DEPTH_2 : integer := 5415; -- dense (13*13*32)*10 + 7 there are 7 stages before dense
 
    type adr_t is array (0 to BRAM_COUNT_0) of std_logic_vector((log2c(RAM_DEPTH_2)-1) downto 0);
    type data_t is array (0 to BRAM_COUNT_0) of std_logic_vector(RAM_WIDTH-1 downto 0);
    type sig_t is array (0 to BRAM_COUNT_0) of std_logic;

    type res_t is array (0 to 9) of std_logic_vector(AXI_WIDTH-1 downto 0);
    type pre_t is array (0 to 9) of std_logic_vector(RAM_WIDTH-1 downto 0);

    type conv_adr_t is array (16 to 24) of std_logic_vector((log2c(RAM_DEPTH_1)-1) downto 0);
    type w_adr_t is array (25 to 34) of std_logic_vector((log2c(RAM_DEPTH_2)-1) downto 0);





    signal stop  : std_logic;
    signal go : std_logic;
    
    signal res_p, res_d : std_logic;
    signal fl: std_logic;
    
    signal pipe_conn: std_logic_vector(RAM_WIDTH-1 downto 0);
    
    -- Read address bus, width determined from RAM_DEPTH
    signal img_adr  : std_logic_vector((log2c(RAM_DEPTH_0)-1) downto 0);
    signal conv_adr : conv_adr_t;
    signal w_adr    : w_adr_t;
    
    signal doutb : data_t;    -- RAM output data


    component pipeline
    generic(
        WIDTH: integer := 32;
        FRACT: integer := 11);
    port(
 --------------- Clocking and start interface ---------------
        clk: in std_logic;
        reset: in std_logic;
 ------------------- Input data interface -------------------
 -- Image window interface
        a_0_i: in std_logic_vector(WIDTH-1 downto 0);
        a_1_i: in std_logic_vector(WIDTH-1 downto 0);
        a_2_i: in std_logic_vector(WIDTH-1 downto 0);
        a_3_i: in std_logic_vector(WIDTH-1 downto 0);
        a_4_i: in std_logic_vector(WIDTH-1 downto 0);
        a_5_i: in std_logic_vector(WIDTH-1 downto 0);
        a_6_i: in std_logic_vector(WIDTH-1 downto 0);
        a_7_i: in std_logic_vector(WIDTH-1 downto 0);
        a_8_i: in std_logic_vector(WIDTH-1 downto 0);
        a_9_i: in std_logic_vector(WIDTH-1 downto 0);
        a_a_i: in std_logic_vector(WIDTH-1 downto 0);
        a_b_i: in std_logic_vector(WIDTH-1 downto 0);
        a_c_i: in std_logic_vector(WIDTH-1 downto 0);
        a_d_i: in std_logic_vector(WIDTH-1 downto 0);
        a_e_i: in std_logic_vector(WIDTH-1 downto 0);
        a_f_i: in std_logic_vector(WIDTH-1 downto 0);
 -- Kernel interface
        w_0_i: in std_logic_vector(WIDTH-1 downto 0);
        w_1_i: in std_logic_vector(WIDTH-1 downto 0);
        w_2_i: in std_logic_vector(WIDTH-1 downto 0);
        w_3_i: in std_logic_vector(WIDTH-1 downto 0);
        w_4_i: in std_logic_vector(WIDTH-1 downto 0);
        w_5_i: in std_logic_vector(WIDTH-1 downto 0);
        w_6_i: in std_logic_vector(WIDTH-1 downto 0);
        w_7_i: in std_logic_vector(WIDTH-1 downto 0);
        w_8_i: in std_logic_vector(WIDTH-1 downto 0);
 ------------------- Output data interface ------------------
 -- Result interface
        r_o: out std_logic_vector(WIDTH-1 downto 0));
    end component pipeline;
        
	
    component dense
    generic(
        WIDTH: integer := 32;
        FRACT: integer := 11);
    port(
 --------------- Clocking and start interface ---------------
        clk: in std_logic;
        reset: in std_logic;
 ------------------- Input data interface -------------------
 -- Previous result
        a_i: in std_logic_vector(WIDTH-1 downto 0);
 -- Weights interface
        w_0_i: in std_logic_vector(WIDTH-1 downto 0);
        w_1_i: in std_logic_vector(WIDTH-1 downto 0);
        w_2_i: in std_logic_vector(WIDTH-1 downto 0);
        w_3_i: in std_logic_vector(WIDTH-1 downto 0);
        w_4_i: in std_logic_vector(WIDTH-1 downto 0);
        w_5_i: in std_logic_vector(WIDTH-1 downto 0);
        w_6_i: in std_logic_vector(WIDTH-1 downto 0);
        w_7_i: in std_logic_vector(WIDTH-1 downto 0);
        w_8_i: in std_logic_vector(WIDTH-1 downto 0);
        w_9_i: in std_logic_vector(WIDTH-1 downto 0);
 ------------------- Output data interface ------------------        
        r_0_o: out std_logic_vector(WIDTH-1 downto 0);
        r_1_o: out std_logic_vector(WIDTH-1 downto 0);
        r_2_o: out std_logic_vector(WIDTH-1 downto 0);
        r_3_o: out std_logic_vector(WIDTH-1 downto 0);
        r_4_o: out std_logic_vector(WIDTH-1 downto 0);
        r_5_o: out std_logic_vector(WIDTH-1 downto 0);
        r_6_o: out std_logic_vector(WIDTH-1 downto 0);
        r_7_o: out std_logic_vector(WIDTH-1 downto 0);
        r_8_o: out std_logic_vector(WIDTH-1 downto 0);
        r_9_o: out std_logic_vector(WIDTH-1 downto 0));
    end component dense;

    component xilinx_simple_dual_port_1_clock_ram
generic (
    LOG : integer := 9;
    RAM_WIDTH : integer := 64;                      -- Specify RAM data width
    RAM_DEPTH : integer := 512;                    -- Specify RAM depth (number of entries)
    RAM_PERFORMANCE : string := "LOW_LATENCY";      -- Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
    INIT_FILE : string := "RAM_INIT.dat"                        -- Specify name/location of RAM initialization file if using one (leave blank if not)
    );

port (
        addra : in std_logic_vector((log2c(RAM_DEPTH)-1) downto 0);     -- Write address bus, width determined from RAM_DEPTH
        addrb : in std_logic_vector((log2c(RAM_DEPTH)-1) downto 0);     -- Read address bus, width determined from RAM_DEPTH
        dina  : in std_logic_vector(RAM_WIDTH-1 downto 0);		  -- RAM input data
        clka  : in std_logic;                       			  -- Clock
        wea   : in std_logic;                       			  -- Write enable
        enb   : in std_logic;                       			  -- RAM Enable, for additional power savings, disable port when not in use
        rstb  : in std_logic;                       			  -- Output reset (does not affect memory contents)
        regceb: in std_logic;                       			  -- Output register enable
        doutb : out std_logic_vector(RAM_WIDTH-1 downto 0)   			  -- RAM output data
    );

    end component xilinx_simple_dual_port_1_clock_ram;


begin    
    r_o_0(31 downto 19) <= (others => '0');
    r_o_1(31 downto 19) <= (others => '0');
    r_o_2(31 downto 19) <= (others => '0');
    r_o_3(31 downto 19) <= (others => '0');
    r_o_4(31 downto 19) <= (others => '0');
    r_o_5(31 downto 19) <= (others => '0');
    r_o_6(31 downto 19) <= (others => '0');
    r_o_7(31 downto 19) <= (others => '0');
    r_o_8(31 downto 19) <= (others => '0');
    r_o_9(31 downto 19) <= (others => '0');
    
    ready <= start and (not stop);
    go <= start and stop;
    
    clk_sync: process (clk)
        begin
            
        if(clk'event and clk = '1') then
            if(go = '0') then
                res_p <= '1';
                res_d <= '1';
                    
                img_adr <= conv_std_logic_vector(0, log2c(RAM_DEPTH_0));
                conv_adr <= (others => conv_std_logic_vector(0, log2c(RAM_DEPTH_1)));
                w_adr <= (others => conv_std_logic_vector(0, log2c(RAM_DEPTH_2)));
                
                stop <= not start;
                fl <= '0';
            else
                res_p <= '0';
                res_d <= '0';
            
                if (unsigned(img_adr) < 168) then -- ((28-2)/2) ^ 2 - 1
                    img_adr <= conv_std_logic_vector(unsigned(img_adr) + 1, log2c(RAM_DEPTH_0));
                    for i in 16 to 24 loop
                        conv_adr(i) <= conv_adr(i);
                    end loop;
                else
                    img_adr <= conv_std_logic_vector(0, log2c(RAM_DEPTH_0));
                    if (conv_adr(16) = 31) then -- next one can't be 32
                        conv_adr <= (others => conv_std_logic_vector(0, log2c(RAM_DEPTH_1)));
                    else
                    for i in 16 to 24 loop
                        conv_adr(i) <= conv_std_logic_vector(unsigned(conv_adr(i)) + 1, log2c(RAM_DEPTH_1));
                    end loop;
                    end if;
                end if;
                if(w_adr(25) = conv_std_logic_vector(5414, log2c(RAM_DEPTH_2))) then
                    w_adr <= (others => conv_std_logic_vector(0, log2c(RAM_DEPTH_2)));
                    --stop <= '0'; -- stop
                    fl <= '1';
                else
                    for i in 25 to 34 loop
                        w_adr(i) <= conv_std_logic_vector(unsigned(w_adr(i)) + 1, log2c(RAM_DEPTH_2));
                    end loop;
                    --stop <= '1'; -- don't stop
                    fl <= fl;
                end if;

                if(fl = '1' and w_adr(25) = conv_std_logic_vector(3, log2c(RAM_DEPTH_2))) then --pipe empty
                    stop <= '0'; -- stop
                else
                    stop <= '1'; -- don't stop
                end if;
            end if;
        end if; 
    end process;

    pl: pipeline
        generic map(
            WIDTH => RAM_WIDTH,
            FRACT => FRACT)
        port map(
            clk => clk,
            reset => res_p,
            a_0_i => doutb(0),
            a_1_i => doutb(1),
            a_2_i => doutb(2),
            a_3_i => doutb(3),
            a_4_i => doutb(4),
            a_5_i => doutb(5),
            a_6_i => doutb(6),
            a_7_i => doutb(7),
            a_8_i => doutb(8),
            a_9_i => doutb(9),
            a_a_i => doutb(10),
            a_b_i => doutb(11),
            a_c_i => doutb(12),
            a_d_i => doutb(13),
            a_e_i => doutb(14),
            a_f_i => doutb(15),
            w_0_i => doutb(16),
            w_1_i => doutb(17),
            w_2_i => doutb(18),
            w_3_i => doutb(19),
            w_4_i => doutb(20),
            w_5_i => doutb(21),
            w_6_i => doutb(22),
            w_7_i => doutb(23),
            w_8_i => doutb(24),
            r_o => pipe_conn);
        
    dns: dense
        generic map(
            WIDTH => RAM_WIDTH,
            FRACT => FRACT)
        port map(
            clk => clk,
            reset => res_d,
            a_i => pipe_conn,
            w_0_i => doutb(25),
            w_1_i => doutb(26),
            w_2_i => doutb(27),
            w_3_i => doutb(28),
            w_4_i => doutb(29),
            w_5_i => doutb(30),
            w_6_i => doutb(31),
            w_7_i => doutb(32),
            w_8_i => doutb(33),
            w_9_i => doutb(34),
            r_0_o => r_o_0(18 downto 0),
            r_1_o => r_o_1(18 downto 0),
            r_2_o => r_o_2(18 downto 0),
            r_3_o => r_o_3(18 downto 0),
            r_4_o => r_o_4(18 downto 0),
            r_5_o => r_o_5(18 downto 0),
            r_6_o => r_o_6(18 downto 0),
            r_7_o => r_o_7(18 downto 0),
            r_8_o => r_o_8(18 downto 0),
            r_9_o => r_o_9(18 downto 0));

    img_brams: for i in 0 to 15 generate
        bram: xilinx_simple_dual_port_1_clock_ram
            generic map(
                LOG => log2c(RAM_DEPTH_0),
                RAM_WIDTH => RAM_WIDTH,
                RAM_DEPTH => RAM_DEPTH_0,
                RAM_PERFORMANCE => "LOW_LATENCY",
                INIT_FILE => "")
            port map(
                addra  => addra(log2c(RAM_DEPTH_0)-1 downto 0),
                addrb  => img_adr,
                dina   => dina(RAM_WIDTH-1 downto 0),
                clka   => clk,
                wea    => wea(i),
                enb    => '1',
                rstb   => '0',
                regceb => '1',
                doutb  => doutb(i));
    end generate;

    conv_brams: for i in 16 to 24 generate
        bram: xilinx_simple_dual_port_1_clock_ram
            generic map(
                LOG => log2c(RAM_DEPTH_1),
                RAM_WIDTH => RAM_WIDTH,
                RAM_DEPTH => RAM_DEPTH_1,
                RAM_PERFORMANCE => "LOW_LATENCY",
                INIT_FILE => "")
            port map(
                addra  => addra(log2c(RAM_DEPTH_1)-1 downto 0),
                addrb  => conv_adr(i),
                dina   => dina(RAM_WIDTH-1 downto 0),
                clka   => clk,
                wea    => wea(i),
                enb    => '1',
                rstb   => '0',
                regceb => '1',
                doutb  => doutb(i));
    end generate;

    weight_brams: for i in 25 to 34 generate
        bram: xilinx_simple_dual_port_1_clock_ram
            generic map(
                LOG => log2c(RAM_DEPTH_2),
                RAM_WIDTH => RAM_WIDTH,
                RAM_DEPTH => RAM_DEPTH_2,
                RAM_PERFORMANCE => "LOW_LATENCY",
                INIT_FILE => "")
            port map(
                addra  => addra(log2c(RAM_DEPTH_2)-1 downto 0),
                addrb  => w_adr(i),
                dina   => dina(RAM_WIDTH-1 downto 0),
                clka   => clk,
                wea    => wea(i),
                enb    => '1',
                rstb   => '0',
                regceb => '1',
                doutb  => doutb(i));
    end generate;
    
end beh;
