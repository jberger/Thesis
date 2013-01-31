set term tikz nopicenvironment
set output "spacecharge_data.tex"
set logscale x
set format x "%T"
set xlabel "Number of Electrons (log$_{10}$)"
set ylabel "HW1/eM Pulse Width, Length (mm)"
plot "spacecharge.dat" using 1:2 with lines title "" linecolor rgb "black" lw 2,\
     "spacecharge.dat" using 1:3 with lines title "" linecolor rgb "black" lw 2
