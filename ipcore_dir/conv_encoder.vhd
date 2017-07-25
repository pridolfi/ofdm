--------------------------------------------------------------------------------
--     (c) Copyright 1995 - 2010 Xilinx, Inc. All rights reserved.            --
--                                                                            --
--     This file contains confidential and proprietary information            --
--     of Xilinx, Inc. and is protected under U.S. and                        --
--     international copyright and other intellectual property                --
--     laws.                                                                  --
--                                                                            --
--     DISCLAIMER                                                             --
--     This disclaimer is not a license and does not grant any                --
--     rights to the materials distributed herewith. Except as                --
--     otherwise provided in a valid license issued to you by                 --
--     Xilinx, and to the maximum extent permitted by applicable              --
--     law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND                --
--     WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES            --
--     AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING              --
--     BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-                 --
--     INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and               --
--     (2) Xilinx shall not be liable (whether in contract or tort,           --
--     including negligence, or under any other theory of                     --
--     liability) for any loss or damage of any kind or nature                --
--     related to, arising under or in connection with these                  --
--     materials, including for any direct, or any indirect,                  --
--     special, incidental, or consequential loss or damage                   --
--     (including loss of data, profits, goodwill, or any type of             --
--     loss or damage suffered as a result of any action brought              --
--     by a third party) even if such damage or loss was                      --
--     reasonably foreseeable or Xilinx had been advised of the               --
--     possibility of the same.                                               --
--                                                                            --
--     CRITICAL APPLICATIONS                                                  --
--     Xilinx products are not designed or intended to be fail-               --
--     safe, or for use in any application requiring fail-safe                --
--     performance, such as life-support or safety devices or                 --
--     systems, Class III medical devices, nuclear facilities,                --
--     applications related to the deployment of airbags, or any              --
--     other applications that could lead to death, personal                  --
--     injury, or severe property or environmental damage                     --
--     (individually and collectively, "Critical                              --
--     Applications"). Customer assumes the sole risk and                     --
--     liability of any use of Xilinx products in Critical                    --
--     Applications, subject only to applicable laws and                      --
--     regulations governing limitations on product liability.                --
--                                                                            --
--     THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS               --
--     PART OF THIS FILE AT ALL TIMES.                                        --
--------------------------------------------------------------------------------

--  Generated from component ID: xilinx.com:ip:convolution:7.0


-- You must compile the wrapper file conv_encoder.vhd when simulating
-- the core, conv_encoder. When compiling the wrapper file, be sure to
-- reference the XilinxCoreLib VHDL simulation library. For detailed
-- instructions, please refer to the "CORE Generator Help".

-- The synthesis directives "translate_off/translate_on" specified
-- below are supported by Xilinx, Mentor Graphics and Synplicity
-- synthesis tools. Ensure they are correct for your synthesis tool(s).

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- synthesis translate_off
Library XilinxCoreLib;
-- synthesis translate_on
ENTITY conv_encoder IS
	port (
	data_in: in std_logic;
	data_out_v: out std_logic_vector(1 downto 0);
	rdy: out std_logic;
	ce: in std_logic;
	sclr: in std_logic;
	clk: in std_logic);
END conv_encoder;

ARCHITECTURE conv_encoder_a OF conv_encoder IS
-- synthesis translate_off
component wrapped_conv_encoder
	port (
	data_in: in std_logic;
	data_out_v: out std_logic_vector(1 downto 0);
	rdy: out std_logic;
	ce: in std_logic;
	sclr: in std_logic;
	clk: in std_logic);
end component;

-- Configuration specification 
	for all : wrapped_conv_encoder use entity XilinxCoreLib.convolution_v7_0(behavioral)
		generic map(
			c_has_rffd => 0,
			c_output_rate => 2,
			c_constraint_length => 7,
			c_dual_channel => 0,
			c_punc_output_rate => 2,
			c_punc_input_rate => 1,
			c_has_rdy => 1,
			c_has_sclr => 1,
			c_has_nd => 0,
			c_punc_code1 => 0,
			c_punc_code0 => 0,
			c_has_rfd => 0,
			c_has_ce => 1,
			c_punctured => 0,
			c_has_fd => 0,
			c_convolution_code6 => 3,
			c_convolution_code5 => 3,
			c_convolution_code4 => 3,
			c_convolution_code3 => 3,
			c_convolution_code2 => 3,
			c_convolution_code1 => 91,
			c_convolution_code0 => 121);
-- synthesis translate_on
BEGIN
-- synthesis translate_off
U0 : wrapped_conv_encoder
		port map (
			data_in => data_in,
			data_out_v => data_out_v,
			rdy => rdy,
			ce => ce,
			sclr => sclr,
			clk => clk);
-- synthesis translate_on

END conv_encoder_a;

