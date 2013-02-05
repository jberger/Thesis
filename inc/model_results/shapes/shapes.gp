set term tikz
# need to set data variable `gnuplot -e 'num="1"' shapes.gp`

prolate = "shape_prolate_N". num . ".dat"
sphere  = "shape_sphere_N" . num . ".dat"
oblate  = "shape_oblate_N" . num . ".dat"

set output "shapes_N" . num . ".tex"

set xlabel "Position in Column (cm)"
set ylabel "Normalized Pulse Width, Length (A.U.)"

set xrange [0:15]
set yrange [1:1.14]

plot prolate using ($1*100):2 with lines title "" lt 1 linecolor rgb "red",\
     prolate using ($1*100):3 with lines title "" lt 2 linecolor rgb "red",\
     sphere  using ($1*100):2 with lines title "" lt 1 linecolor rgb "green",\
     sphere  using ($1*100):3 with lines title "" lt 2 linecolor rgb "green",\
     oblate  using ($1*100):2 with lines title "" lt 1 linecolor rgb "blue",\
     oblate  using ($1*100):3 with lines title "" lt 2 linecolor rgb "blue

