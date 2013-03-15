set term tikz nopicenvironment
# need to set data variable `gnuplot -e 'profile="acc"' spacecharge.gp`

input="spacecharge_" . profile . ".dat"

set output "spacecharge_data_" . profile . ".tex"
set logscale x
set format x "%T"
set xlabel "Number of Electrons (log$_{10}$)"
set ylabel "HW1/eM Pulse Width, Length (mm)"
plot input using 1:2 with lines title "" linecolor rgb "black" lw 2,\
     input using 1:3 with lines title "" linecolor rgb "black" lw 2
