set term tikz scale 0.7,0.7

set output "w_plot.tex"
file = "w_plot_data.dat"

yield(x) = a*x
fit yield(x) file using 1:3 via a

set ytics nomirror
#set y2tics

set xrange [0:1]
set yrange [0:600]
set y2range [0:8000]

set ylabel "HW1/eM Pulse Width ($\\mu m$)"
set y2label "Electron Yield (a.u.)"

plot file using 1:2 with points lt 5 linecolor rgb "black" title "",\
     file using 1:3 with points lt 7 linecolor rgb "black" title "" axes x1y2,\
     yield(x)       with lines  lt 1 linecolor rgb "green" title "" axes x1y2

