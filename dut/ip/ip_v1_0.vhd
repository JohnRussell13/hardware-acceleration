library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.utils_pkg.all;

entity ip_v1_0 is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 6
	);
	port (
		-- Users to add ports here
        addra: in std_logic_vector(31 downto 0);
        dina: in std_logic_vector(31 downto 0);
		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: out std_logic;
		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: out std_logic;
		s00_axi_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_bvalid	: out std_logic;
		s00_axi_bready	: in std_logic;
		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: out std_logic;
		s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_rvalid	: out std_logic;
		s00_axi_rready	: in std_logic
	);
end ip_v1_0;

architecture arch_imp of ip_v1_0 is
signal start_s, ready_s: std_logic;
signal reg0_s, reg1_s, reg2_s, reg3_s, reg4_s, reg5_s, reg6_s, reg7_s, reg8_s, reg9_s: std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
signal wea_s: std_logic_vector(2*C_S00_AXI_DATA_WIDTH-1 downto 0);
	-- component declaration
	component ip_v1_0_S00_AXI is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 6
		);
		port (
		start_o: out std_logic;
        ready_i: in std_logic;
		r_i: in res_t;
	    wea : out std_logic_vector(2*AXI_WIDTH-1 downto 0);

		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component ip_v1_0_S00_AXI;
    
    component cnn is
        port(
        clk: in std_logic;
        start: in std_logic;
        ready: out std_logic;
        addra: in std_logic_vector(31 downto 0);
        dina: in std_logic_vector(31 downto 0);
        wea: in std_logic_vector(2*AXI_WIDTH-1 downto 0);
        r_o_0: out std_logic_vector(AXI_WIDTH-1 downto 0);
        r_o_1: out std_logic_vector(AXI_WIDTH-1 downto 0);
        r_o_2: out std_logic_vector(AXI_WIDTH-1 downto 0);
        r_o_3: out std_logic_vector(AXI_WIDTH-1 downto 0);
        r_o_4: out std_logic_vector(AXI_WIDTH-1 downto 0);
        r_o_5: out std_logic_vector(AXI_WIDTH-1 downto 0);
        r_o_6: out std_logic_vector(AXI_WIDTH-1 downto 0);
        r_o_7: out std_logic_vector(AXI_WIDTH-1 downto 0);
        r_o_8: out std_logic_vector(AXI_WIDTH-1 downto 0);
        r_o_9: out std_logic_vector(AXI_WIDTH-1 downto 0)
        );
    end component;

begin

-- Instantiation of Axi Bus Interface S00_AXI
ip_v1_0_S00_AXI_inst : ip_v1_0_S00_AXI
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
		S_AXI_ACLK	=> s00_axi_aclk,
		S_AXI_ARESETN	=> s00_axi_aresetn,
		S_AXI_AWADDR	=> s00_axi_awaddr,
		S_AXI_AWPROT	=> s00_axi_awprot,
		S_AXI_AWVALID	=> s00_axi_awvalid,
		S_AXI_AWREADY	=> s00_axi_awready,
		S_AXI_WDATA	=> s00_axi_wdata,
		S_AXI_WSTRB	=> s00_axi_wstrb,
		S_AXI_WVALID	=> s00_axi_wvalid,
		S_AXI_WREADY	=> s00_axi_wready,
		S_AXI_BRESP	=> s00_axi_bresp,
		S_AXI_BVALID	=> s00_axi_bvalid,
		S_AXI_BREADY	=> s00_axi_bready,
		S_AXI_ARADDR	=> s00_axi_araddr,
		S_AXI_ARPROT	=> s00_axi_arprot,
		S_AXI_ARVALID	=> s00_axi_arvalid,
		S_AXI_ARREADY	=> s00_axi_arready,
		S_AXI_RDATA	=> s00_axi_rdata,
		S_AXI_RRESP	=> s00_axi_rresp,
		S_AXI_RVALID	=> s00_axi_rvalid,
		S_AXI_RREADY	=> s00_axi_rready,
		start_o => start_s,
		ready_i => ready_s,
		wea => wea_s,
	    r_i(0) => reg0_s,
        r_i(1) => reg1_s,
        r_i(2) => reg2_s, 
        r_i(3) => reg3_s,
        r_i(4) => reg4_s,
        r_i(5) => reg5_s,
        r_i(6) => reg6_s,
        r_i(7) => reg7_s,
        r_i(8) => reg8_s,
        r_i(9) => reg9_s
	);

	-- Add user logic here
 cnn_inst: cnn
     port map(
        clk => s00_axi_aclk,
        start => start_s,
        ready => ready_s,
        wea => wea_s,
        r_o_0 => reg0_s,
        r_o_1 => reg1_s,
        r_o_2 => reg2_s, 
        r_o_3 => reg3_s,
        r_o_4 => reg4_s,
        r_o_5 => reg5_s,
        r_o_6 => reg6_s,
        r_o_7 => reg7_s,
        r_o_8 => reg8_s,
        r_o_9 => reg9_s,
        addra => addra,
        dina => dina
    );
	-- User logic ends

end arch_imp;
