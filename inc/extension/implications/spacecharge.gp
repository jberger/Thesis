set term png
set output "spacecharge.png"
set logscale x
set format x "%T"
set xlabel "Number of Electrons (log_10)"
set ylabel "Pulse Diameter, Length (mm)"
plot "spacecharge.dat" using 1:2 with lines title "",\
     "spacecharge.dat" using 1:3 with lines title ""
