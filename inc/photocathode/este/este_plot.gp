set term tikz solid
set output "este_plot.tex"

set xlabel "UV Laser Pulse Energy (nJ)"
set ylabel "HWe$^{-1}$M Beam Size ($\\mu$m)"
set y2label "Electrons / Pulse"
set yrange [0:1000]
set y2tics
show y2tics
set style data errorbars

f1(x) = a1*x
f2(x) = a2*x
fit f1(x) "GaSb.dat" using 1:2 via a1
fit f2(x) "InSb.dat" using 1:2 via a2

# The CCD binned in twos, so a factor of two needs to be added to width
plot 'width.dat' using 1:($2*2):($3*2) title "" with yerrorbars lt 5 linecolor rgb "black",\
     f1(x)                  with lines      title "" lt 1  linecolor rgb "green" axes x1y2,\
     "GaSb.dat" using 1:2:3 with yerrorbars title "" lt 7  linecolor rgb "black" axes x1y2,\
     f2(x)                  with lines      title "" lt 1  linecolor rgb "blue"  axes x1y2,\
     "InSb.dat" using 1:2:3 with yerrorbars title "" lt 21 linecolor rgb "black" axes x1y2
     
