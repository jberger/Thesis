set term png
set output "onaxis.png"

set xlabel "Position in column (mm)"
set ylabel "Electric field (kV/mm)"

f(x,s) = V/2*(1-tanh((x-xp)/(xp/s)))
xp=6.09455
V=3.15865
set xrange [0:10]
set yrange [0:3.5]

# Use 20kV (rather than 10) also convert in -> mm
#fit f(x,20) "onaxis.dat" using ($1*25.4):(2*$3/25.4) via V,xp
plot f(x,5)  with lines linecolor rgb "red"   lt 1 title "",\
     f(x,10) with lines linecolor rgb "green" lt 1 title "",\
     f(x,20) with lines linecolor rgb "blue"  lt 1 title "",\
     "onaxis.dat" using ($1*25.4):(2*$3/25.4) with points linecolor rgb "black" lt 4 title ""
