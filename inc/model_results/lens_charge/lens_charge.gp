set term tikz solid nopicenvironment scale 0.7,0.7

# need to set data variable `gnuplot -e 'length="60"' lens_charge.gp`

file = "lens_".length."mm"

set output file."_data.tex"

set logscale y

#set yrange [0.1:1.5]

set xlabel "Pulse location rel. to $f$=".length."mm lens"
set ylabel "HW1/eM beam width (mm)"

plot file."_n1e0.dat" using 1:2 with lines title "",\
     file."_n1e4.dat" using 1:2 with lines title "",\
     file."_n1e5.dat" using 1:2 with lines title "",\
     file."_n1e6.dat" using 1:2 with lines title "",\
     file."_n1e7.dat" using 1:2 with lines title ""
