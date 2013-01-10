set term png
# need to set data variable `gnuplot -e 'data="Vmax"' plot.gp

set output data.".png"
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
set yrange [0:1]
plot file using 1:3 with lines,\
     s(x) with lines,\
     file using 1:4 with lines,\
     g(x) with lines,\
     file using 1:5 with lines,\
     h(x) with lines
