set term tikz nopicenvironment
set output "au_plot_data.tex"
set xrange [0:14.1]
set xlabel "Incident Laser Pulse Energy (nJ)"
set y2range [0:2.5e7]
set ylabel "HWe$^{-1}$M Beam Size($\\mu$m)"
set y2label "Electron Yield (a.u.)"
set format y2 ""
set style data errorbars
f(x) = a*x**2+b*x
fit f(x) "yield.dat" using 1:2 via a,b
plot 	"sim.dat" using 1:3 title "" with lines lt 1,\
	"sim.dat" using 1:2 title "" with lines lt 2 linecolor rgb "red",\
	"sim.dat" using 1:4 title "" with lines lt 2 linecolor rgb "red",\
	"data.dat" using 1:2:3 title "" with yerrorbars lt 5 linecolor rgb "black",\
	f(x) axes x1y2 with lines title "" lt 1 linecolor rgb "green",\
	"yield.dat" using 1:2 axes x1y2 title "" with points lt 7 linecolor rgb "black"
