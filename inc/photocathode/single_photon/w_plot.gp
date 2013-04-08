set term tikz scale 0.7,0.7

set output "w_plot.tex"
file = "w_plot_data.dat"

yield(x) = a*x
fit yield(x) file using 1:4 via a

set ytics nomirror
#set y2tics

set xrange [0:0.2]
set yrange [0:1.2]
set y2range [0:8000]

set style data errorbars
set xlabel  "UV Laser Pulse Energy (nJ)"
set ylabel  "HW1/eM Pulse Width (mm)"
set y2label "Electron Yield (a.u.)"

plot file using 1:2:3 with yerrorbars lt 5 linecolor rgb "black" title "",\
     file using 1:4:5 with yerrorbars lt 7 linecolor rgb "black" title "" axes x1y2,\
     yield(x)         with lines      lt 1 linecolor rgb "green" title "" axes x1y2

