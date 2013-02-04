set term png
set output "lens_20cm.png"

file = "lens_20cm_n1e"

set logscale y

plot "lens_20cm_n1e0.dat" using 1:2 with lines title "",\
     "lens_20cm_n1e4.dat" using 1:2 with lines title "",\
     "lens_20cm_n1e5.dat" using 1:2 with lines title "",\
     "lens_20cm_n1e6.dat" using 1:2 with lines title "",\
     "lens_20cm_n1e7.dat" using 1:2 with lines title ""
