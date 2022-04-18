library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

use work.utils_pkg.all;

entity dense is
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
end entity;
architecture beh of dense is
    type DEC_T is array (0 to 9) of signed(WIDTH-1 downto 0);
    type P_T is array (0 to 9) of signed(2*WIDTH-1 downto 0);
    
    signal a_in:signed(WIDTH-1 downto 0);
    signal w_in: DEC_T;
    signal p_in: P_T;
    signal r_in, r_out: DEC_T;    
begin
    -- LOGIC
    a_in <= signed(a_i);
    
    w_in(0) <= signed(w_0_i);
    w_in(1) <= signed(w_1_i);
    w_in(2) <= signed(w_2_i);
    w_in(3) <= signed(w_3_i);
    w_in(4) <= signed(w_4_i);
    w_in(5) <= signed(w_5_i);
    w_in(6) <= signed(w_6_i);
    w_in(7) <= signed(w_7_i);
    w_in(8) <= signed(w_8_i);
    w_in(9) <= signed(w_9_i);

    p_in(0)(10 downto 0) <= (others => '0');
    p_in(1)(10 downto 0) <= (others => '0');
    p_in(2)(10 downto 0) <= (others => '0');
    p_in(3)(10 downto 0) <= (others => '0');
    p_in(4)(10 downto 0) <= (others => '0');
    p_in(5)(10 downto 0) <= (others => '0');
    p_in(6)(10 downto 0) <= (others => '0');
    p_in(7)(10 downto 0) <= (others => '0');
    p_in(8)(10 downto 0) <= (others => '0');
    p_in(9)(10 downto 0) <= (others => '0');
    
    p_in(0)(29 downto 11) <= r_out(0);
    p_in(1)(29 downto 11) <= r_out(1);
    p_in(2)(29 downto 11) <= r_out(2);
    p_in(3)(29 downto 11) <= r_out(3);
    p_in(4)(29 downto 11) <= r_out(4);
    p_in(5)(29 downto 11) <= r_out(5);
    p_in(6)(29 downto 11) <= r_out(6);
    p_in(7)(29 downto 11) <= r_out(7);
    p_in(8)(29 downto 11) <= r_out(8);
    p_in(9)(29 downto 11) <= r_out(9);

    p_in(0)(37 downto 30) <= (others => '0');
    p_in(1)(37 downto 30) <= (others => '0');
    p_in(2)(37 downto 30) <= (others => '0');
    p_in(3)(37 downto 30) <= (others => '0');
    p_in(4)(37 downto 30) <= (others => '0');
    p_in(5)(37 downto 30) <= (others => '0');
    p_in(6)(37 downto 30) <= (others => '0');
    p_in(7)(37 downto 30) <= (others => '0');
    p_in(8)(37 downto 30) <= (others => '0');
    p_in(9)(37 downto 30) <= (others => '0');
    
    r_in(0) <= signed(conv_std_logic_vector(a_in * w_in(0) + p_in(0), 2*WIDTH)(29 downto 11));
    r_in(1) <= signed(conv_std_logic_vector(a_in * w_in(1) + p_in(1), 2*WIDTH)(29 downto 11));
    r_in(2) <= signed(conv_std_logic_vector(a_in * w_in(2) + p_in(2), 2*WIDTH)(29 downto 11));
    r_in(3) <= signed(conv_std_logic_vector(a_in * w_in(3) + p_in(3), 2*WIDTH)(29 downto 11));
    r_in(4) <= signed(conv_std_logic_vector(a_in * w_in(4) + p_in(4), 2*WIDTH)(29 downto 11));
    r_in(5) <= signed(conv_std_logic_vector(a_in * w_in(5) + p_in(5), 2*WIDTH)(29 downto 11));
    r_in(6) <= signed(conv_std_logic_vector(a_in * w_in(6) + p_in(6), 2*WIDTH)(29 downto 11));
    r_in(7) <= signed(conv_std_logic_vector(a_in * w_in(7) + p_in(7), 2*WIDTH)(29 downto 11));
    r_in(8) <= signed(conv_std_logic_vector(a_in * w_in(8) + p_in(8), 2*WIDTH)(29 downto 11));
    r_in(9) <= signed(conv_std_logic_vector(a_in * w_in(9) + p_in(9), 2*WIDTH)(29 downto 11));
    -- FF SET
    process (clk, reset)
        begin
        if(reset = '1') then
            for i in 0 to 9 loop
                r_out(i) <= signed(conv_std_logic_vector(0, WIDTH));
            end loop;
        end if;
        
        if (clk'event and clk = '1') then
            for i in 0 to 9 loop
                r_out(i) <= r_in(i);
            end loop;
        end if;
    end process;
    -- SEND TO PORT
    r_0_o <= conv_std_logic_vector(r_out(0), WIDTH);
    r_1_o <= conv_std_logic_vector(r_out(1), WIDTH);
    r_2_o <= conv_std_logic_vector(r_out(2), WIDTH);
    r_3_o <= conv_std_logic_vector(r_out(3), WIDTH);
    r_4_o <= conv_std_logic_vector(r_out(4), WIDTH);
    r_5_o <= conv_std_logic_vector(r_out(5), WIDTH);
    r_6_o <= conv_std_logic_vector(r_out(6), WIDTH);
    r_7_o <= conv_std_logic_vector(r_out(7), WIDTH);
    r_8_o <= conv_std_logic_vector(r_out(8), WIDTH);
    r_9_o <= conv_std_logic_vector(r_out(9), WIDTH);
end beh;
