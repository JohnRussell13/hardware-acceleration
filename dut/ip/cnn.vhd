library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.utils_pkg.all;

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
        wea: in std_logic_vector(2*AXI_WIDTH-1 downto 0);      -- Write enable
 ------------------- Output data interface ------------------
 -- Result interface
        r_o_0: out std_logic_vector(AXI_WIDTH-1 downto 0);
        r_o_1: out std_logic_vector(AXI_WIDTH-1 downto 0);
        r_o_2: out std_logic_vector(AXI_WIDTH-1 downto 0);
        r_o_3: out std_logic_vector(AXI_WIDTH-1 downto 0);
        r_o_4: out std_logic_vector(AXI_WIDTH-1 downto 0);
        r_o_5: out std_logic_vector(AXI_WIDTH-1 downto 0);
        r_o_6: out std_logic_vector(AXI_WIDTH-1 downto 0);
        r_o_7: out std_logic_vector(AXI_WIDTH-1 downto 0);
        r_o_8: out std_logic_vector(AXI_WIDTH-1 downto 0);
        r_o_9: out std_logic_vector(AXI_WIDTH-1 downto 0));
end entity;
architecture beh of cnn is
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

    pipeline: entity work.pipeline(beh)
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
        
    dense: entity work.dense(beh)
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
        bram: entity work.xilinx_simple_dual_port_1_clock_ram(rtl)
            generic map(
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
        bram: entity work.xilinx_simple_dual_port_1_clock_ram(rtl)
            generic map(
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
        bram: entity work.xilinx_simple_dual_port_1_clock_ram(rtl)
            generic map(
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
