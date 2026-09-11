#Nexys4 DDR (xc7a100tcsg324-1) constraint, ported from the Loongson local FPGA board

#set_property SEVERITY {Warning} [get_drc_checks RTSTAT-2]
set_property SEVERITY {Warning} [get_drc_checks NSTD-1]
set_property SEVERITY {Warning} [get_drc_checks UCIO-1]

#clock signal: 100MHz on pin E3 (dedicated MRCC clock input)
set_property -dict { PACKAGE_PIN E3 IOSTANDARD LVCMOS33 } [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.000 -waveform {0.000 5.000} [get_ports clk]

#reset
set_property -dict { PACKAGE_PIN C12 IOSTANDARD LVCMOS33 } [get_ports resetn]


#LED
set_property PACKAGE_PIN H17 [get_ports {led[0]}]
set_property PACKAGE_PIN K15 [get_ports {led[1]}]
set_property PACKAGE_PIN J13 [get_ports {led[2]}]
set_property PACKAGE_PIN N14 [get_ports {led[3]}]
set_property PACKAGE_PIN R18 [get_ports {led[4]}]
set_property PACKAGE_PIN V17 [get_ports {led[5]}]
set_property PACKAGE_PIN U17 [get_ports {led[6]}]
set_property PACKAGE_PIN U16 [get_ports {led[7]}]
set_property PACKAGE_PIN V16 [get_ports {led[8]}]
set_property PACKAGE_PIN T15 [get_ports {led[9]}]
set_property PACKAGE_PIN U14 [get_ports {led[10]}]
set_property PACKAGE_PIN T16 [get_ports {led[11]}]
set_property PACKAGE_PIN V15 [get_ports {led[12]}]
set_property PACKAGE_PIN V14 [get_ports {led[13]}]
set_property PACKAGE_PIN V12 [get_ports {led[14]}]
set_property PACKAGE_PIN V11 [get_ports {led[15]}]

#NUM: 7-segment display, anodes low active
set_property PACKAGE_PIN U13 [get_ports {num_csn[7]}]
set_property PACKAGE_PIN K2  [get_ports {num_csn[6]}]
set_property PACKAGE_PIN T14 [get_ports {num_csn[5]}]
set_property PACKAGE_PIN P14 [get_ports {num_csn[4]}]
set_property PACKAGE_PIN J14 [get_ports {num_csn[3]}]
set_property PACKAGE_PIN T9  [get_ports {num_csn[2]}]
set_property PACKAGE_PIN J18 [get_ports {num_csn[1]}]
set_property PACKAGE_PIN J17 [get_ports {num_csn[0]}]

set_property PACKAGE_PIN T10 [get_ports {num_a_g[0]}]
set_property PACKAGE_PIN R10 [get_ports {num_a_g[1]}]
set_property PACKAGE_PIN K16 [get_ports {num_a_g[2]}]
set_property PACKAGE_PIN K13 [get_ports {num_a_g[3]}]
set_property PACKAGE_PIN P15 [get_ports {num_a_g[4]}]
set_property PACKAGE_PIN T11 [get_ports {num_a_g[5]}]
set_property PACKAGE_PIN L18 [get_ports {num_a_g[6]}]

#switch
set_property PACKAGE_PIN J15 [get_ports {switch[0]}]
set_property PACKAGE_PIN L16 [get_ports {switch[1]}]
set_property PACKAGE_PIN M13 [get_ports {switch[2]}]
set_property PACKAGE_PIN R15 [get_ports {switch[3]}]
set_property PACKAGE_PIN R17 [get_ports {switch[4]}]
set_property PACKAGE_PIN T18 [get_ports {switch[5]}]
set_property PACKAGE_PIN U18 [get_ports {switch[6]}]
set_property PACKAGE_PIN R13 [get_ports {switch[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {num_a_g[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {num_csn[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {switch[*]}]
