vlib work
vlog REG_MUX.v DSP48A1_tb.v DSP48A1.v
vsim -voptargs=+acc work.DSP48A1_tb
add wave *
run -all
