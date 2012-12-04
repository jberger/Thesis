set term tikz nopicenvironment
set output "fig1data.tex"
set xlabel "Position in column (cm)"
set ylabel "Spot Size ($\\Delta x/\\Delta x_0$)"
set datafile separator ","
plot "ExptFocus.csv" using 1:2 every 100 title "" with lines ls 2 linecolor rgb "red" lw 2,\
     "ExptFP.csv"    using 1:2 every 100 title "" with lines ls 1 linecolor rgb "black" lw 2

