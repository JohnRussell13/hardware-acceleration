library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.utils_pkg.all;

entity pipeline_tb is
end entity;

architecture beh of pipeline_tb is
    constant DATA_WIDTH_c: integer := 6;
    constant DATA_FRACT_c: integer := 11;
    type mem_a_t is array (0 to 15) of std_logic_vector(DATA_WIDTH_c-1 downto 0);
    type mem_b_t is array (0 to 8) of std_logic_vector(DATA_WIDTH_c-1 downto 0);
    type DEC_T is array (0 to 9) of std_logic_vector(DATA_WIDTH_c-1 downto 0);
     
    constant MEM_A_CONTENT_c: mem_a_t := 
        (conv_std_logic_vector(0, DATA_WIDTH_c),
        conv_std_logic_vector(1, DATA_WIDTH_c),
        conv_std_logic_vector(2, DATA_WIDTH_c),
        conv_std_logic_vector(3, DATA_WIDTH_c),
        conv_std_logic_vector(4, DATA_WIDTH_c),
        conv_std_logic_vector(5, DATA_WIDTH_c),
        conv_std_logic_vector(6, DATA_WIDTH_c),
        conv_std_logic_vector(7, DATA_WIDTH_c),
        conv_std_logic_vector(8, DATA_WIDTH_c),
        conv_std_logic_vector(9, DATA_WIDTH_c),
        conv_std_logic_vector(10, DATA_WIDTH_c),
        conv_std_logic_vector(11, DATA_WIDTH_c),
        conv_std_logic_vector(12, DATA_WIDTH_c),
        conv_std_logic_vector(13, DATA_WIDTH_c),
        conv_std_logic_vector(14, DATA_WIDTH_c),
        conv_std_logic_vector(15, DATA_WIDTH_c));
        
    constant MEM_B_CONTENT_c: mem_b_t := 
        (conv_std_logic_vector(0, DATA_WIDTH_c),
        conv_std_logic_vector(1, DATA_WIDTH_c),
        conv_std_logic_vector(0, DATA_WIDTH_c),
        conv_std_logic_vector(1, DATA_WIDTH_c),
        conv_std_logic_vector(2, DATA_WIDTH_c),
        conv_std_logic_vector(1, DATA_WIDTH_c),
        conv_std_logic_vector(0, DATA_WIDTH_c),
        conv_std_logic_vector(1, DATA_WIDTH_c),
        conv_std_logic_vector(0, DATA_WIDTH_c));
        
    constant MEM_P_CONTENT_c: DEC_T := 
        (conv_std_logic_vector(0, DATA_WIDTH_c),
        conv_std_logic_vector(0, DATA_WIDTH_c),
        conv_std_logic_vector(0, DATA_WIDTH_c),
        conv_std_logic_vector(0, DATA_WIDTH_c),
        conv_std_logic_vector(0, DATA_WIDTH_c),
        conv_std_logic_vector(0, DATA_WIDTH_c),
        conv_std_logic_vector(0, DATA_WIDTH_c),
        conv_std_logic_vector(0, DATA_WIDTH_c),
        conv_std_logic_vector(1, DATA_WIDTH_c),
        conv_std_logic_vector(0, DATA_WIDTH_c));
        
    constant MEM_T_CONTENT_c: DEC_T := 
        (conv_std_logic_vector(0, DATA_WIDTH_c),
        conv_std_logic_vector(1, DATA_WIDTH_c),
        conv_std_logic_vector(0, DATA_WIDTH_c),
        conv_std_logic_vector(1, DATA_WIDTH_c),
        conv_std_logic_vector(2, DATA_WIDTH_c),
        conv_std_logic_vector(1, DATA_WIDTH_c),
        conv_std_logic_vector(0, DATA_WIDTH_c),
        conv_std_logic_vector(0, DATA_WIDTH_c),
        conv_std_logic_vector(1, DATA_WIDTH_c),
        conv_std_logic_vector(0, DATA_WIDTH_c));
        
    signal clk_s: std_logic;
    signal reset_s: std_logic;
    signal start_s: std_logic;
    signal ready_s: std_logic;
    
    signal conv_res_s: std_logic_vector(DATA_WIDTH_c-1 downto 0);
    signal dense_res_s: DEC_T;
begin
    clk_gen: process
        begin
        clk_s <= '0', '1' after 100 ns;
        wait for 200 ns;
    end process;
        
 -- DUT CONV
    pipeline_core: entity work.pipeline(beh)
    generic map(
        WIDTH => DATA_WIDTH_c,
        FRACT => DATA_FRACT_c)
    port map(
 --------------- Clocking and reset interface ---------------
        clk => clk_s,
        reset => reset_s,
 ------------------- Input data interface -------------------
 -- Matrix A memory interface
        a_0_i => MEM_A_CONTENT_c(0),
        a_1_i => MEM_A_CONTENT_c(1),
        a_2_i => MEM_A_CONTENT_c(2),
        a_3_i => MEM_A_CONTENT_c(3),
        a_4_i => MEM_A_CONTENT_c(4),
        a_5_i => MEM_A_CONTENT_c(5),
        a_6_i => MEM_A_CONTENT_c(6),
        a_7_i => MEM_A_CONTENT_c(7),
        a_8_i => MEM_A_CONTENT_c(8),
        a_9_i => MEM_A_CONTENT_c(9),
        a_a_i => MEM_A_CONTENT_c(10),
        a_b_i => MEM_A_CONTENT_c(11),
        a_c_i => MEM_A_CONTENT_c(12),
        a_d_i => MEM_A_CONTENT_c(13),
        a_e_i => MEM_A_CONTENT_c(14),
        a_f_i => MEM_A_CONTENT_c(15),
 -- Matrix B memory interface
        w_0_i => MEM_B_CONTENT_c(0),
        w_1_i => MEM_B_CONTENT_c(1),
        w_2_i => MEM_B_CONTENT_c(2),
        w_3_i => MEM_B_CONTENT_c(3),
        w_4_i => MEM_B_CONTENT_c(4),
        w_5_i => MEM_B_CONTENT_c(5),
        w_6_i => MEM_B_CONTENT_c(6),
        w_7_i => MEM_B_CONTENT_c(7),
        w_8_i => MEM_B_CONTENT_c(8),
 ------------------- Output data interface ------------------
 -- Matrix C memory interface
        r_o => conv_res_s);
        
 -- DUT DENSE
    dense_core: entity work.dense(beh)
    generic map(
        WIDTH => DATA_WIDTH_c,
        FRACT => DATA_FRACT_c)
    port map(
 --------------- Clocking and reset interface ---------------
        clk => clk_s,
        reset => reset_s,
 ------------------- Input data interface -------------------
 -- Main input A interface
        a_i => conv_res_s,
 -- Weights interface
        w_0_i => MEM_T_CONTENT_c(0),
        w_1_i => MEM_T_CONTENT_c(1),
        w_2_i => MEM_T_CONTENT_c(2),
        w_3_i => MEM_T_CONTENT_c(3),
        w_4_i => MEM_T_CONTENT_c(4),
        w_5_i => MEM_T_CONTENT_c(5),
        w_6_i => MEM_T_CONTENT_c(6),
        w_7_i => MEM_T_CONTENT_c(7),
        w_8_i => MEM_T_CONTENT_c(8),
        w_9_i => MEM_T_CONTENT_c(9),
 ------------------- Output data interface ------------------
 -- Previous results interface
        p_0_i => MEM_P_CONTENT_c(0),
        p_1_i => MEM_P_CONTENT_c(1),
        p_2_i => MEM_P_CONTENT_c(2),
        p_3_i => MEM_P_CONTENT_c(3),
        p_4_i => MEM_P_CONTENT_c(4),
        p_5_i => MEM_P_CONTENT_c(5),
        p_6_i => MEM_P_CONTENT_c(6),
        p_7_i => MEM_P_CONTENT_c(7),
        p_8_i => MEM_P_CONTENT_c(8),
        p_9_i => MEM_P_CONTENT_c(9),
 -- Results interface
        r_0_o => dense_res_s(0),
        r_1_o => dense_res_s(1),
        r_2_o => dense_res_s(2),
        r_3_o => dense_res_s(3),
        r_4_o => dense_res_s(4),
        r_5_o => dense_res_s(5),
        r_6_o => dense_res_s(6),
        r_7_o => dense_res_s(7),
        r_8_o => dense_res_s(8),
        r_9_o => dense_res_s(9));
end architecture beh;