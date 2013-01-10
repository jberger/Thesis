set term tikz nopicenvironment scale 0.7,0.7
# need to set data variable `gnuplot -e 'data="Vmax"' plot.gp`

set output data.".tex"
file=data.".dat"

stats file using 3 name "A"
s(x)=s0*exp(-((x-s1)**2/(2*s2**2)))
s2=15
fit s(x) file using 1:3 via s0,s1,s2

g(x)=g1+g2*x
fit g(x) file using 1:4 via g1,g2

h(x)=h1
fit h(x) file using 1:5 via h1

set xlabel "Position Inside Pulse (\\%)"
set yrange [0:1.05]
set ylabel "Arbitrary Units"
plot file using 1:3 with lines title "" lt 1 linecolor rgb "red",\
     s(x) with lines title "" lt 2 linecolor rgb "red",\
     file using 1:4 title "" with lines lt 1 linecolor rgb "green",\
     g(x) with lines title "" lt 2 linecolor rgb "green",\
     file using 1:5 title "" with lines lt 1 linecolor rgb "blue",\
     h(x) with lines title "" lt 2 linecolor rgb "blue"
