library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

--use work.utils_pkg.all;

entity pipeline is
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
end entity;
architecture beh of pipeline is
    type DUB_T is array (0 to 1) of signed(WIDTH-1 downto 0);
    type TRIP_T is array (0 to 2) of signed(WIDTH-1 downto 0);
    type QUAD_T is array (0 to 3) of signed(WIDTH-1 downto 0);
    
    type MULTY_0_T is array (0 to 8) of QUAD_T;
    type ADD_0_T is array (0 to 4) of QUAD_T;
    type ADD_1_T is array (0 to 2) of QUAD_T;
    type ADD_2_T is array (0 to 1) of QUAD_T;
    type WINDOW_T is array (0 to 3) of QUAD_T;
    type WEIGHT_T is array (0 to 2) of TRIP_T;
    
    signal a_in: WINDOW_T;
    signal w_in: WEIGHT_T;
    
    signal mult_in, mult_out: MULTY_0_T;
    signal add_0_in, add_0_out: ADD_0_T;
    signal add_1_in, add_1_out: ADD_1_T;
    signal add_2_in, add_2_out: ADD_2_T;
    signal add_3_in, add_3_out: QUAD_T;
    signal comp_0_in, comp_0_out: DUB_T;
    signal comp_1_in, comp_1_out: signed(WIDTH-1 downto 0);
    signal comp_2_in, comp_2_out: signed(WIDTH-1 downto 0);
    
begin
    --LOGIC
    a_in(0)(0) <= signed(a_0_i);
    a_in(0)(1) <= signed(a_1_i);
    a_in(0)(2) <= signed(a_2_i);
    a_in(0)(3) <= signed(a_3_i);
    a_in(1)(0) <= signed(a_4_i);
    a_in(1)(1) <= signed(a_5_i);
    a_in(1)(2) <= signed(a_6_i);
    a_in(1)(3) <= signed(a_7_i);
    a_in(2)(0) <= signed(a_8_i);
    a_in(2)(1) <= signed(a_9_i);
    a_in(2)(2) <= signed(a_a_i);
    a_in(2)(3) <= signed(a_b_i);
    a_in(3)(0) <= signed(a_c_i);
    a_in(3)(1) <= signed(a_d_i);
    a_in(3)(2) <= signed(a_e_i);
    a_in(3)(3) <= signed(a_f_i);
    
    w_in(0)(0) <= signed(w_0_i);
    w_in(0)(1) <= signed(w_1_i);
    w_in(0)(2) <= signed(w_2_i);
    w_in(1)(0) <= signed(w_3_i);
    w_in(1)(1) <= signed(w_4_i);
    w_in(1)(2) <= signed(w_5_i);
    w_in(2)(0) <= signed(w_6_i);
    w_in(2)(1) <= signed(w_7_i);
    w_in(2)(2) <= signed(w_8_i);
    
    mult_in(0)(0) <= signed(conv_std_logic_vector(a_in(0)(0) * w_in(0)(0), 2*WIDTH)(29 downto 11)); -- (8,11)*(8,11) = (16,22)
    mult_in(1)(0) <= signed(conv_std_logic_vector(a_in(0)(1) * w_in(0)(1), 2*WIDTH)(29 downto 11));
    mult_in(2)(0) <= signed(conv_std_logic_vector(a_in(0)(2) * w_in(0)(2), 2*WIDTH)(29 downto 11));
    mult_in(3)(0) <= signed(conv_std_logic_vector(a_in(1)(0) * w_in(1)(0), 2*WIDTH)(29 downto 11));
    mult_in(4)(0) <= signed(conv_std_logic_vector(a_in(1)(1) * w_in(1)(1), 2*WIDTH)(29 downto 11));
    mult_in(5)(0) <= signed(conv_std_logic_vector(a_in(1)(2) * w_in(1)(2), 2*WIDTH)(29 downto 11));
    mult_in(6)(0) <= signed(conv_std_logic_vector(a_in(2)(0) * w_in(2)(0), 2*WIDTH)(29 downto 11));
    mult_in(7)(0) <= signed(conv_std_logic_vector(a_in(2)(1) * w_in(2)(1), 2*WIDTH)(29 downto 11));
    mult_in(8)(0) <= signed(conv_std_logic_vector(a_in(2)(2) * w_in(2)(2), 2*WIDTH)(29 downto 11));
    
    mult_in(0)(1) <= signed(conv_std_logic_vector(a_in(0)(1) * w_in(0)(0), 2*WIDTH)(29 downto 11));
    mult_in(1)(1) <= signed(conv_std_logic_vector(a_in(0)(2) * w_in(0)(1), 2*WIDTH)(29 downto 11));
    mult_in(2)(1) <= signed(conv_std_logic_vector(a_in(0)(3) * w_in(0)(2), 2*WIDTH)(29 downto 11));
    mult_in(3)(1) <= signed(conv_std_logic_vector(a_in(1)(1) * w_in(1)(0), 2*WIDTH)(29 downto 11));
    mult_in(4)(1) <= signed(conv_std_logic_vector(a_in(1)(2) * w_in(1)(1), 2*WIDTH)(29 downto 11));
    mult_in(5)(1) <= signed(conv_std_logic_vector(a_in(1)(3) * w_in(1)(2), 2*WIDTH)(29 downto 11));
    mult_in(6)(1) <= signed(conv_std_logic_vector(a_in(2)(1) * w_in(2)(0), 2*WIDTH)(29 downto 11));
    mult_in(7)(1) <= signed(conv_std_logic_vector(a_in(2)(2) * w_in(2)(1), 2*WIDTH)(29 downto 11));
    mult_in(8)(1) <= signed(conv_std_logic_vector(a_in(2)(3) * w_in(2)(2), 2*WIDTH)(29 downto 11));
    
    mult_in(0)(2) <= signed(conv_std_logic_vector(a_in(1)(0) * w_in(0)(0), 2*WIDTH)(29 downto 11));
    mult_in(1)(2) <= signed(conv_std_logic_vector(a_in(1)(1) * w_in(0)(1), 2*WIDTH)(29 downto 11));
    mult_in(2)(2) <= signed(conv_std_logic_vector(a_in(1)(2) * w_in(0)(2), 2*WIDTH)(29 downto 11));
    mult_in(3)(2) <= signed(conv_std_logic_vector(a_in(2)(0) * w_in(1)(0), 2*WIDTH)(29 downto 11));
    mult_in(4)(2) <= signed(conv_std_logic_vector(a_in(2)(1) * w_in(1)(1), 2*WIDTH)(29 downto 11));
    mult_in(5)(2) <= signed(conv_std_logic_vector(a_in(2)(2) * w_in(1)(2), 2*WIDTH)(29 downto 11));
    mult_in(6)(2) <= signed(conv_std_logic_vector(a_in(3)(0) * w_in(2)(0), 2*WIDTH)(29 downto 11));
    mult_in(7)(2) <= signed(conv_std_logic_vector(a_in(3)(1) * w_in(2)(1), 2*WIDTH)(29 downto 11));
    mult_in(8)(2) <= signed(conv_std_logic_vector(a_in(3)(2) * w_in(2)(2), 2*WIDTH)(29 downto 11));
    
    mult_in(0)(3) <= signed(conv_std_logic_vector(a_in(1)(1) * w_in(0)(0), 2*WIDTH)(29 downto 11));
    mult_in(1)(3) <= signed(conv_std_logic_vector(a_in(1)(2) * w_in(0)(1), 2*WIDTH)(29 downto 11));
    mult_in(2)(3) <= signed(conv_std_logic_vector(a_in(1)(3) * w_in(0)(2), 2*WIDTH)(29 downto 11));
    mult_in(3)(3) <= signed(conv_std_logic_vector(a_in(2)(1) * w_in(1)(0), 2*WIDTH)(29 downto 11));
    mult_in(4)(3) <= signed(conv_std_logic_vector(a_in(2)(2) * w_in(1)(1), 2*WIDTH)(29 downto 11));
    mult_in(5)(3) <= signed(conv_std_logic_vector(a_in(2)(3) * w_in(1)(2), 2*WIDTH)(29 downto 11));
    mult_in(6)(3) <= signed(conv_std_logic_vector(a_in(3)(1) * w_in(2)(0), 2*WIDTH)(29 downto 11));
    mult_in(7)(3) <= signed(conv_std_logic_vector(a_in(3)(2) * w_in(2)(1), 2*WIDTH)(29 downto 11));
    mult_in(8)(3) <= signed(conv_std_logic_vector(a_in(3)(3) * w_in(2)(2), 2*WIDTH)(29 downto 11));
    
    add_0_in(0)(0) <= mult_out(0)(0) + mult_out(1)(0);
    add_0_in(1)(0) <= mult_out(2)(0) + mult_out(3)(0);
    add_0_in(2)(0) <= mult_out(4)(0) + mult_out(5)(0);
    add_0_in(3)(0) <= mult_out(6)(0) + mult_out(7)(0);
    add_0_in(4)(0) <= mult_out(8)(0);
    
    add_0_in(0)(1) <= mult_out(0)(1) + mult_out(1)(1);
    add_0_in(1)(1) <= mult_out(2)(1) + mult_out(3)(1);
    add_0_in(2)(1) <= mult_out(4)(1) + mult_out(5)(1);
    add_0_in(3)(1) <= mult_out(6)(1) + mult_out(7)(1);
    add_0_in(4)(1) <= mult_out(8)(1);
    
    add_0_in(0)(2) <= mult_out(0)(2) + mult_out(1)(2);
    add_0_in(1)(2) <= mult_out(2)(2) + mult_out(3)(2);
    add_0_in(2)(2) <= mult_out(4)(2) + mult_out(5)(2);
    add_0_in(3)(2) <= mult_out(6)(2) + mult_out(7)(2);
    add_0_in(4)(2) <= mult_out(8)(2);
    
    add_0_in(0)(3) <= mult_out(0)(3) + mult_out(1)(3);
    add_0_in(1)(3) <= mult_out(2)(3) + mult_out(3)(3);
    add_0_in(2)(3) <= mult_out(4)(3) + mult_out(5)(3);
    add_0_in(3)(3) <= mult_out(6)(3) + mult_out(7)(3);
    add_0_in(4)(3) <= mult_out(8)(3);
    
    add_1_in(0)(0) <= add_0_out(0)(0) + add_0_out(1)(0);
    add_1_in(1)(0) <= add_0_out(2)(0) + add_0_out(3)(0);
    add_1_in(2)(0) <= add_0_out(4)(0);
    
    add_1_in(0)(1) <= add_0_out(0)(1) + add_0_out(1)(1);
    add_1_in(1)(1) <= add_0_out(2)(1) + add_0_out(3)(1);
    add_1_in(2)(1) <= add_0_out(4)(1);
    
    add_1_in(0)(2) <= add_0_out(0)(2) + add_0_out(1)(2);
    add_1_in(1)(2) <= add_0_out(2)(2) + add_0_out(3)(2);
    add_1_in(2)(2) <= add_0_out(4)(2);
    
    add_1_in(0)(3) <= add_0_out(0)(3) + add_0_out(1)(3);
    add_1_in(1)(3) <= add_0_out(2)(3) + add_0_out(3)(3);
    add_1_in(2)(3) <= add_0_out(4)(3);
    
    add_2_in(0)(0) <= add_1_out(0)(0) + add_1_out(1)(0);
    add_2_in(1)(0) <= add_1_out(2)(0);
    
    add_2_in(0)(1) <= add_1_out(0)(1) + add_1_out(1)(1);
    add_2_in(1)(1) <= add_1_out(2)(1);
    
    add_2_in(0)(2) <= add_1_out(0)(2) + add_1_out(1)(2);
    add_2_in(1)(2) <= add_1_out(2)(2);
    
    add_2_in(0)(3) <= add_1_out(0)(3) + add_1_out(1)(3);
    add_2_in(1)(3) <= add_1_out(2)(3);
    
    add_3_in(0) <= add_2_out(0)(0) + add_2_out(1)(0);
    add_3_in(1) <= add_2_out(0)(1) + add_2_out(1)(1);
    add_3_in(2) <= add_2_out(0)(2) + add_2_out(1)(2);
    add_3_in(3) <= add_2_out(0)(3) + add_2_out(1)(3);
    
    comp_0_in(0) <= add_3_out(0) when add_3_out(0) > add_3_out(1) else
                    add_3_out(1);
    
    comp_0_in(1) <= add_3_out(2) when add_3_out(2) > add_3_out(3) else
                    add_3_out(3);
    
    comp_1_in <= comp_0_out(0) when comp_0_out(0) > comp_0_out(1) else
                    comp_0_out(1);
                    
    comp_1_out <= comp_1_in;
    
    comp_2_in <= comp_1_out when comp_1_out > 0 else
                    signed(conv_std_logic_vector(0, WIDTH));
    -- FF SET
    process (clk, reset)
        begin
        
        if(reset = '1') then
            for i in 0 to 8 loop
                for j in 0 to 3 loop
                    mult_out(i)(j) <= signed(conv_std_logic_vector(0, WIDTH));
                end loop;
            end loop;
            
            for i in 0 to 4 loop
                for j in 0 to 3 loop
                    add_0_out(i)(j) <= signed(conv_std_logic_vector(0, WIDTH));
                end loop;
            end loop;
            
            for i in 0 to 2 loop
                for j in 0 to 3 loop
                    add_1_out(i)(j) <= signed(conv_std_logic_vector(0, WIDTH));
                end loop;
            end loop;
            
            for i in 0 to 1 loop
                for j in 0 to 3 loop
                    add_2_out(i)(j) <= signed(conv_std_logic_vector(0, WIDTH));
                end loop;
            end loop;
            
            for i in 0 to 3 loop
                add_3_out(i) <= signed(conv_std_logic_vector(0, WIDTH));
            end loop;
            
            comp_0_out(0) <= signed(conv_std_logic_vector(0, WIDTH));
            comp_0_out(1) <= signed(conv_std_logic_vector(0, WIDTH));
            
            comp_2_out <= signed(conv_std_logic_vector(0, WIDTH));
        end if;
        
        if (clk'event and clk = '1') then
            for i in 0 to 8 loop
                for j in 0 to 3 loop
                    mult_out(i)(j) <= mult_in(i)(j);
                end loop;
            end loop;
            
            for i in 0 to 4 loop
                for j in 0 to 3 loop
                    add_0_out(i)(j) <= add_0_in(i)(j);
                end loop;
            end loop;
            
            for i in 0 to 2 loop
                for j in 0 to 3 loop
                    add_1_out(i)(j) <= add_1_in(i)(j);
                end loop;
            end loop;
            
            for i in 0 to 1 loop
                for j in 0 to 3 loop
                    add_2_out(i)(j) <= add_2_in(i)(j);
                end loop;
            end loop;
            
            for i in 0 to 3 loop
                add_3_out(i) <= add_3_in(i);
            end loop;
            
            comp_0_out(0) <= comp_0_in(0);
            comp_0_out(1) <= comp_0_in(1);
            
            comp_2_out <= comp_2_in;
        end if;
    end process;
    -- SEND TO PORT
    r_o <= conv_std_logic_vector(comp_2_out, WIDTH);
end beh;
