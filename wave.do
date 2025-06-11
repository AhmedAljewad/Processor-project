onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testProcessor/Clk
add wave -noupdate /testProcessor/ResetN
add wave -noupdate /testProcessor/IR_Out
add wave -noupdate /testProcessor/PC_Out
add wave -noupdate /testProcessor/State
add wave -noupdate /testProcessor/NextState
add wave -noupdate /testProcessor/ALU_A
add wave -noupdate /testProcessor/ALU_B
add wave -noupdate /testProcessor/ALU_Out
add wave -noupdate /testProcessor/DUT/RF_Ra_Addr
add wave -noupdate /testProcessor/DUT/RF_Rb_Addr
add wave -noupdate /testProcessor/DUT/RF_W_Addr
add wave -noupdate /testProcessor/DUT/D_Addr
add wave -noupdate /testProcessor/DUT/D_Wr
add wave -noupdate /testProcessor/DUT/RF_W_en
add wave -noupdate /testProcessor/DUT/RF_s
add wave -noupdate /testProcessor/DUT/ALU_s0
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1 ns}
