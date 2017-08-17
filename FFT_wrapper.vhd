----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:10:13 08/16/2017 
-- Design Name: 
-- Module Name:    FFT_wrapper - FFT_wrapper_arch 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FFT_wrapper is

PORT (
 clk : IN STD_LOGIC;
 ce : IN STD_LOGIC;
 sclr : IN STD_LOGIC;
 start : IN STD_LOGIC;
 unload : IN STD_LOGIC;
 xn_re : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
 xn_im : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
 fwd_inv : IN STD_LOGIC;
 fwd_inv_we : IN STD_LOGIC;
 rfd : OUT STD_LOGIC;
 xn_index : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
 busy : OUT STD_LOGIC;
 edone : OUT STD_LOGIC;
 done : OUT STD_LOGIC;
 dv : OUT STD_LOGIC;
 xk_index : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
 xk_re : OUT STD_LOGIC_VECTOR(14 DOWNTO 0);
 xk_im : OUT STD_LOGIC_VECTOR(14 DOWNTO 0)
);

end FFT_wrapper;

architecture FFT_wrapper_arch of FFT_wrapper is

COMPONENT FFT_mod
  PORT (
    clk : IN STD_LOGIC;
    ce : IN STD_LOGIC;
    sclr : IN STD_LOGIC;
    start : IN STD_LOGIC;
    unload : IN STD_LOGIC;
    xn_re : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    xn_im : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    fwd_inv : IN STD_LOGIC;
    fwd_inv_we : IN STD_LOGIC;
    rfd : OUT STD_LOGIC;
    xn_index : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
    busy : OUT STD_LOGIC;
    edone : OUT STD_LOGIC;
    done : OUT STD_LOGIC;
    dv : OUT STD_LOGIC;
    xk_index : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
    xk_re : OUT STD_LOGIC_VECTOR(14 DOWNTO 0);
    xk_im : OUT STD_LOGIC_VECTOR(14 DOWNTO 0)
  );
END COMPONENT;

begin

fft0 : FFT_mod
  PORT MAP (
    clk => clk,
    ce => ce,
    sclr => sclr,
    start => start,
    unload => unload,
    xn_re => xn_re,
    xn_im => xn_im,
    fwd_inv => fwd_inv,
    fwd_inv_we => fwd_inv_we,
    rfd => rfd,
    xn_index => xn_index,
    busy => busy,
    edone => edone,
    done => done,
    dv => dv,
    xk_index => xk_index,
    xk_re => xk_re,
    xk_im => xk_im
  );

end FFT_wrapper_arch;

