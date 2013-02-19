set term png

# need to set data variable `gnuplot -e 'length="65"' shapes.gp`

file = "lens_" . length . "mm"

set output file . ".png"

set logscale y

#set yrange [0.1:1.5]

plot file . "_n1e0.dat" using 1:2 with lines title "",\
     file . "_n1e4.dat" using 1:2 with lines title "",\
     file . "_n1e5.dat" using 1:2 with lines title "",\
     file . "_n1e6.dat" using 1:2 with lines title "",\
     file . "_n1e7.dat" using 1:2 with lines title ""

