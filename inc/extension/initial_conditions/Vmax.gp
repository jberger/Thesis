set term png
set output "Vmax.png"
file="Vmax.dat"

stats file using 3 name "A"
s(x)=A_max*exp(-((x-A_index_max)**2/(2*s1**2)))
s1=15
fit s(x) file using 1:3 via s1

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
