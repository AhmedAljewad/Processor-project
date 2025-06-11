onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ControlUnit_tb/Clock
add wave -noupdate /ControlUnit_tb/Reset
add wave -noupdate /ControlUnit_tb/PC_out
add wave -noupdate /ControlUnit_tb/IR_out
add wave -noupdate /ControlUnit_tb/OutState
add wave -noupdate /ControlUnit_tb/NextState
add wave -noupdate /ControlUnit_tb/Dmem_addr
add wave -noupdate /ControlUnit_tb/D_wr_en
add wave -noupdate /ControlUnit_tb/RF_sel
add wave -noupdate /ControlUnit_tb/RF_wr_addr
add wave -noupdate /ControlUnit_tb/RF_wr_en
add wave -noupdate /ControlUnit_tb/RF_RA_addr
add wave -noupdate /ControlUnit_tb/RF_RB_addr
add wave -noupdate /ControlUnit_tb/ALU_sel0
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
