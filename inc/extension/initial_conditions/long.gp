set term png
set output "long_sigma.png"

set logscale x
set logscale y
set logscale xy

set xtics format "%.0e"
set ytics format "%.0e"

set xrange [1e-15:1e-12]

file="long.dat"
es1=8.79e10
es2=1.93e33
sigma(x) = s1*es1*x**2 + s2*es2*x**4
s1=1
s2=100
fit sigma(x) file using 1:3 via s1,s2
plot file using 1:2 with points lt 1 title "",\
     file using 1:3 with points lt 2 title "",\
     sigma(x) with lines lt 3 title ""

set output "long_gamma.png"

eg1=3.82e-25
eg2=1.13e-13
gam(x) = sqrt(sigma(x)) * ( g1*eg1 + g2*eg2*x )
g1=1
g2=1
fit gam(x) file using 1:7 via g1,g2
plot file using 1:6 with points lt 1,\
     file using 1:7 with points lt 2,\
     gam(x) with lines lt 3 title ""

set output "long_eta.png"
plot file using 1:4 with lines lt 1,\
     file using 1:5 with lines lt 2
