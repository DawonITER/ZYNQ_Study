onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib Zybo_opt

do {wave.do}

view wave
view structure
view signals

do {Zybo.udo}

run -all

quit -force
