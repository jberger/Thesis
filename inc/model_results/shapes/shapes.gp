set term tikz

prolate = "shape_prolate.dat"
sphere  = "shape_sphere.dat"
oblate  = "shape_oblate.dat"

set output "figure_shapes.tex"

plot prolate using 1:2 with lines title "Prolate" lt 1 linecolor rgb "red",\
     prolate using 1:3 with lines title ""        lt 2 linecolor rgb "red",\
     sphere  using 1:2 with lines title "Sphere"  lt 1 linecolor rgb "green",\
     sphere  using 1:3 with lines title ""        lt 2 linecolor rgb "green",\
     oblate  using 1:2 with lines title "Oblate"  lt 1 linecolor rgb "blue",\
     oblate  using 1:3 with lines title ""        lt 2 linecolor rgb "blue

