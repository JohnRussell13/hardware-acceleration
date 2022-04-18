library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.utils_pkg.all;

entity dense is
    generic(
        WIDTH: integer := 32;
        FRACT: integer := 11);
    port(
 --------------- Clocking and reset interface ---------------
        clk: in std_logic;
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
 -- Result interface
        p_0_i: in std_logic_vector(WIDTH-1 downto 0);
        p_1_i: in std_logic_vector(WIDTH-1 downto 0);
        p_2_i: in std_logic_vector(WIDTH-1 downto 0);
        p_3_i: in std_logic_vector(WIDTH-1 downto 0);
        p_4_i: in std_logic_vector(WIDTH-1 downto 0);
        p_5_i: in std_logic_vector(WIDTH-1 downto 0);
        p_6_i: in std_logic_vector(WIDTH-1 downto 0);
        p_7_i: in std_logic_vector(WIDTH-1 downto 0);
        p_8_i: in std_logic_vector(WIDTH-1 downto 0);
        p_9_i: in std_logic_vector(WIDTH-1 downto 0);
        
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
    type DEC_T is array (0 to 9) of unsigned(WIDTH-1 downto 0);
    
    signal a_in: unsigned(WIDTH-1 downto 0);
    signal w_in: DEC_T;
    signal p_in: DEC_T;
    signal r_in, r_out: DEC_T;    
begin
    a_in <= unsigned(a_i);
    
    w_in(0) <= unsigned(w_0_i);
    w_in(1) <= unsigned(w_1_i);
    w_in(2) <= unsigned(w_2_i);
    w_in(3) <= unsigned(w_3_i);
    w_in(4) <= unsigned(w_4_i);
    w_in(5) <= unsigned(w_5_i);
    w_in(6) <= unsigned(w_6_i);
    w_in(7) <= unsigned(w_7_i);
    w_in(8) <= unsigned(w_8_i);
    w_in(9) <= unsigned(w_9_i);
    
    p_in(0) <= unsigned(p_0_i);
    p_in(1) <= unsigned(p_1_i);
    p_in(2) <= unsigned(p_2_i);
    p_in(3) <= unsigned(p_3_i);
    p_in(4) <= unsigned(p_4_i);
    p_in(5) <= unsigned(p_5_i);
    p_in(6) <= unsigned(p_6_i);
    p_in(7) <= unsigned(p_7_i);
    p_in(8) <= unsigned(p_8_i);
    p_in(9) <= unsigned(p_9_i);
    
    r_in(0) <= unsigned(conv_std_logic_vector(a_in * w_in(0) + p_in(0), WIDTH));
    r_in(1) <= unsigned(conv_std_logic_vector(a_in * w_in(1) + p_in(1), WIDTH));
    r_in(2) <= unsigned(conv_std_logic_vector(a_in * w_in(2) + p_in(2), WIDTH));
    r_in(3) <= unsigned(conv_std_logic_vector(a_in * w_in(3) + p_in(3), WIDTH));
    r_in(4) <= unsigned(conv_std_logic_vector(a_in * w_in(4) + p_in(4), WIDTH));
    r_in(5) <= unsigned(conv_std_logic_vector(a_in * w_in(5) + p_in(5), WIDTH));
    r_in(6) <= unsigned(conv_std_logic_vector(a_in * w_in(6) + p_in(6), WIDTH));
    r_in(7) <= unsigned(conv_std_logic_vector(a_in * w_in(7) + p_in(7), WIDTH));
    r_in(8) <= unsigned(conv_std_logic_vector(a_in * w_in(8) + p_in(8), WIDTH));
    r_in(9) <= unsigned(conv_std_logic_vector(a_in * w_in(9) + p_in(9), WIDTH));
    
    process (clk)
        begin
        if (clk'event and clk = '1') then
            for i in 0 to 9 loop
                r_out(i) <= r_in(i);
            end loop;
            
            r_0_o <= std_logic_vector(r_out(0));
            r_1_o <= std_logic_vector(r_out(1));
            r_2_o <= std_logic_vector(r_out(2));
            r_3_o <= std_logic_vector(r_out(3));
            r_4_o <= std_logic_vector(r_out(4));
            r_5_o <= std_logic_vector(r_out(5));
            r_6_o <= std_logic_vector(r_out(6));
            r_7_o <= std_logic_vector(r_out(7));
            r_8_o <= std_logic_vector(r_out(8));
            r_9_o <= std_logic_vector(r_out(9));
        end if;
    end process;
    
end beh;
