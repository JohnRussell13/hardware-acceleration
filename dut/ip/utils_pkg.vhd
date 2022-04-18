-- package declaration
library ieee;
use ieee.std_logic_1164.all;

package utils_pkg is
    function log2c (n: integer) return integer;

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
end utils_pkg;

--package body
package body utils_pkg is
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
end utils_pkg;
