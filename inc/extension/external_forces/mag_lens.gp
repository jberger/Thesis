set term tikz solid
set output "mag_lens_plot.tex"
set datafile separator ","

set multiplot

set xlabel "Position in column (cm)"
set ylabel "Radial Ray Position, Beam Width ($\\mu$m)"

plot for [i=2:19] 'mag_lens_kinematic.csv' using (100*$1):(1e6 * column(i)) with lines lt 2 title "",\
                  'mag_lens_ag.csv' using (100*$1):(1e6 * $2) with lines lt 1 lw 3 title ""


