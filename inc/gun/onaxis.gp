set term png
set output "onaxis.png"
f(x) = V/(2*xp)*(1-tanh((x-xp)/(xp/s)))
xp=0.24
V=9.6
s=20
set yrange [0:45]
#fit f(x) "onaxis.dat" using 1:3 via V,xp,s
plot f(x) with lines,\
     "onaxis.dat" using 1:3 with points
