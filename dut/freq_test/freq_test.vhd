library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity test_design is
generic(FIXED_WIDTH:positive:=18);
   port(clk : in std_logic;
        data_in : in std_logic_vector(FIXED_WIDTH-1 downto 0);
        data_out : out std_logic_vector(FIXED_WIDTH-1 downto 0)
        );
end test_design;

architecture Behavioral of test_design is
 signal  b_reg_in, b_reg_out: std_logic_vector(FIXED_WIDTH-1 downto 0);
 signal  c_reg_in, c_reg_out: std_logic_vector(FIXED_WIDTH-1 downto 0);
 signal  d_reg_in, d_reg_out: std_logic_vector(FIXED_WIDTH-1 downto 0);
 signal  e_reg_in, e_reg_out: std_logic_vector(FIXED_WIDTH-1 downto 0);
 signal  f_reg_in, f_reg_out: std_logic_vector(FIXED_WIDTH-1 downto 0);
 signal  h_reg_in, h_reg_out: std_logic_vector(FIXED_WIDTH-1 downto 0);
 signal  i_reg_in, i_reg_out: std_logic_vector(FIXED_WIDTH-1 downto 0);
 signal  j_reg_in, j_reg_out: std_logic_vector(FIXED_WIDTH-1 downto 0);
 signal  k_reg_in, k_reg_out: std_logic_vector(FIXED_WIDTH-1 downto 0);
 signal  l_reg_in, l_reg_out: std_logic_vector(FIXED_WIDTH-1 downto 0);
 signal  m_reg_in, m_reg_out: std_logic_vector(FIXED_WIDTH-1 downto 0);
 signal  temp1: std_logic_vector(FIXED_WIDTH*2-1 downto 0);
 signal  temp2: std_logic_vector(FIXED_WIDTH*2-1 downto 0);
 begin
 b_reg_in <= data_in;
 temp1 <= b_reg_out * b_reg_out;
 c_reg_in <= temp1(FIXED_WIDTH-1 downto 0);
 d_reg_in <= c_reg_out + b_reg_out;
 e_reg_in <= d_reg_out + b_reg_out;
 f_reg_in <= e_reg_out + b_reg_out;
 h_reg_in <= f_reg_out + b_reg_out;
 
 comp1: process(h_reg_in, b_reg_in) is
 begin
    if (h_reg_in < b_reg_in) then
        i_reg_in <= b_reg_in;
    else
        i_reg_in <= h_reg_in;
    end if;
 end process;   
 
 comp2: process(i_reg_in, c_reg_in) is
 begin
    if (i_reg_in < c_reg_in) then
        j_reg_in <= c_reg_in;
    else
        j_reg_in <= i_reg_in;
    end if;
 end process;
 
 comp3: process(j_reg_in) is
 begin
    if (j_reg_in > 0) then
        k_reg_in <= j_reg_in;
    else
        k_reg_in <= ( others => '0');
    end if;
 end process;
 
 temp2 <= k_reg_out * b_reg_out;
 l_reg_in <= temp2(FIXED_WIDTH-1 downto 0);
 m_reg_in <= m_reg_out + l_reg_out;
 data_out <= m_reg_out;
 
 reg: process(clk) is              
 begin
    if (clk'event and clk = '1') then
        b_reg_out <= b_reg_in;
        c_reg_out <= c_reg_in;
        d_reg_out <= d_reg_in;
        e_reg_out <= e_reg_in;
        f_reg_out <= f_reg_in;
        h_reg_out <= h_reg_in;
        i_reg_out <= i_reg_in;
        j_reg_out <= j_reg_in;
        k_reg_out <= k_reg_in;
        m_reg_out <= m_reg_in;
        l_reg_out <= l_reg_in;
    end if;
 end process;  

 end Behavioral;
