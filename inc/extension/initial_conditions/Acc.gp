set term png
set output "Acc.png"

stats "Acc.dat" using 3 name "A"
s(x)=A_max*exp(-((x-A_index_max)**2/(2*s**2)))
fit s(x) "Acc.dat" using 1:3 via s

g(x)=g1+g2*x
fit g(x) "Acc.dat" using 1:4 via g1,g2

h(x)=h1
fit h(x) "Acc.dat" using 1:5 via h1

plot "Acc.dat" using 1:3 with lines,\
     s(x) with lines,\
     "Acc.dat" using 1:4 with lines,\
     g(x) with lines,\
     "Acc.dat" using 1:5 with lines,\
     h(x) with lines
