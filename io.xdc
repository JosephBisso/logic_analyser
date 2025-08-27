# clk
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property PACKAGE_PIN Y9 [get_ports clk]
create_clock -period 100.000 -name clk -waveform {0.000 50.000} [get_ports clk]

# reset
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
set_property PACKAGE_PIN R16 [get_ports rst_n]

# PMOD Data_in (JB) 
set_property IOSTANDARD LVCMOS33 [get_ports JB[0]]
set_property IOSTANDARD LVCMOS33 [get_ports JB[1]]
set_property IOSTANDARD LVCMOS33 [get_ports JB[2]]
set_property IOSTANDARD LVCMOS33 [get_ports JB[3]]
set_property IOSTANDARD LVCMOS33 [get_ports JB[4]]
set_property IOSTANDARD LVCMOS33 [get_ports JB[5]]
set_property IOSTANDARD LVCMOS33 [get_ports JB[6]]
set_property IOSTANDARD LVCMOS33 [get_ports JB[7]]

set_property PACKAGE_PIN W12    [get_ports JB[0]]
set_property PACKAGE_PIN W11    [get_ports JB[1]]
set_property PACKAGE_PIN V10    [get_ports JB[2]]
set_property PACKAGE_PIN W8    [get_ports JB[3]]
set_property PACKAGE_PIN V12   [get_ports JB[4]]
set_property PACKAGE_PIN W10   [get_ports JB[5]]
set_property PACKAGE_PIN V9    [get_ports JB[6]]
set_property PACKAGE_PIN V8    [get_ports JB[7]]

# PMOD Tester_Out (JA)
set_property IOSTANDARD LVCMOS33 [get_ports TST[0]]
set_property IOSTANDARD LVCMOS33 [get_ports TST[1]]
set_property IOSTANDARD LVCMOS33 [get_ports TST[2]]
set_property IOSTANDARD LVCMOS33 [get_ports TST[3]]
set_property IOSTANDARD LVCMOS33 [get_ports TST[4]]
set_property IOSTANDARD LVCMOS33 [get_ports TST[5]]
set_property IOSTANDARD LVCMOS33 [get_ports TST[6]]

set_property PACKAGE_PIN Y11    [get_ports TST[0]]
set_property PACKAGE_PIN AA11   [get_ports TST[1]]
set_property PACKAGE_PIN AA9    [get_ports TST[2]]
set_property PACKAGE_PIN AB11   [get_ports TST[3]]
set_property PACKAGE_PIN AB10   [get_ports TST[4]]
set_property PACKAGE_PIN AB9    [get_ports TST[5]]
set_property PACKAGE_PIN AA8    [get_ports TST[6]]

#SWITCH Trigger
set_property IOSTANDARD LVCMOS33 [get_ports T_SW[0]]
set_property IOSTANDARD LVCMOS33 [get_ports T_SW[1]]
set_property IOSTANDARD LVCMOS33 [get_ports T_SW[2]]
set_property IOSTANDARD LVCMOS33 [get_ports T_SW[3]]

set_property PACKAGE_PIN F22 [get_ports T_SW[0]]
set_property PACKAGE_PIN G22 [get_ports T_SW[1]]
set_property PACKAGE_PIN H22 [get_ports T_SW[2]]
set_property PACKAGE_PIN F21 [get_ports T_SW[3]]

#SWITCH Flanke
set_property IOSTANDARD LVCMOS33 [get_ports F_SW[0]]
set_property IOSTANDARD LVCMOS33 [get_ports F_SW[1]]
set_property IOSTANDARD LVCMOS33 [get_ports F_SW[2]]
set_property IOSTANDARD LVCMOS33 [get_ports F_SW[3]]

set_property PACKAGE_PIN H19 [get_ports F_SW[0]]
set_property PACKAGE_PIN H18 [get_ports F_SW[1]]
set_property PACKAGE_PIN H17 [get_ports F_SW[2]]
set_property PACKAGE_PIN M15 [get_ports F_SW[3]]

#BTN start
set_property IOSTANDARD LVCMOS33 [get_ports BTNC]
set_property PACKAGE_PIN P16 [get_ports BTNC]

#VGA_RED
set_property IOSTANDARD LVCMOS33 [get_ports RED[0]]
set_property IOSTANDARD LVCMOS33 [get_ports RED[1]]
set_property IOSTANDARD LVCMOS33 [get_ports RED[2]]
set_property IOSTANDARD LVCMOS33 [get_ports RED[3]]
set_property PACKAGE_PIN V20 [get_ports RED[0]]
set_property PACKAGE_PIN U20 [get_ports RED[1]]
set_property PACKAGE_PIN V19 [get_ports RED[2]]
set_property PACKAGE_PIN V18 [get_ports RED[3]]

#VGA_GREEN
set_property IOSTANDARD LVCMOS33 [get_ports GREEN[0]]
set_property IOSTANDARD LVCMOS33 [get_ports GREEN[1]]
set_property IOSTANDARD LVCMOS33 [get_ports GREEN[2]]
set_property IOSTANDARD LVCMOS33 [get_ports GREEN[3]]
set_property PACKAGE_PIN AB22 [get_ports GREEN[0]]
set_property PACKAGE_PIN AA22 [get_ports GREEN[1]]
set_property PACKAGE_PIN AB21 [get_ports GREEN[2]]
set_property PACKAGE_PIN AA21 [get_ports GREEN[3]]

#VGA_BLUE
set_property IOSTANDARD LVCMOS33 [get_ports BLUE[0]]
set_property IOSTANDARD LVCMOS33 [get_ports BLUE[1]]
set_property IOSTANDARD LVCMOS33 [get_ports BLUE[2]]
set_property IOSTANDARD LVCMOS33 [get_ports BLUE[3]]
set_property PACKAGE_PIN Y21 [get_ports BLUE[0]]
set_property PACKAGE_PIN Y20 [get_ports BLUE[1]]
set_property PACKAGE_PIN AB20 [get_ports BLUE[2]]
set_property PACKAGE_PIN AB19 [get_ports BLUE[3]]

#VGA_HSYNC
set_property IOSTANDARD LVCMOS33 [get_ports HS]
set_property PACKAGE_PIN AA19 [get_ports HS]

#VGA_VSYNC
set_property IOSTANDARD LVCMOS33 [get_ports VS]
set_property PACKAGE_PIN Y19 [get_ports VS]

