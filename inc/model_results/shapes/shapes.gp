set term png

prolate = "shape_prolate.dat"
sphere  = "shape_sphere.dat"
oblate  = "shape_oblate.dat"

set output "Transverse.png"

plot prolate using 1:2 with lines title "Prolate",\
     sphere  using 1:2 with lines title "Sphere",\
     oblate  using 1:2 with lines title "Oblate"

set output "Longitudinal.png"

plot prolate using 1:3 with lines title "Prolate",\
     sphere  using 1:3 with lines title "Sphere",\
     oblate  using 1:3 with lines title "Oblate"

