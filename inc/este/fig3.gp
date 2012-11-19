set term tikz solid nopicenvironment
set output "fig3data.tex"
set xlabel "UV Laser Pulse Energy (nJ)"
set ylabel "Electrons / Pulse"
set y2label "HWe$^{-1}$M Beam Size ($\\mu$m)"
set y2range [0:500]
set y2tics format "%.0f"
show y2tics
set style data errorbars
f1(x) = a1*x
f2(x) = a2*x
fit f1(x) "GaSb.dat" using 1:2 via a1
fit f2(x) "InSb.dat" using 1:2 via a2
plot f1(x) with lines title "" linecolor rgb "black" lw 2,\
     "GaSb.dat" using 1:2:3 title "" with yerrorbars lt 4,\
     f2(x) with lines title "" linecolor rgb "black" lw 2,\
     "InSb.dat" using 1:2:3 title "" with yerrorbars lt 7,\
     'width.dat' using 1:2:3 axes x1y2 title "" with yerrorbars lt 4 linecolor rgb "black"
