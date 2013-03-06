set term png
set output "mag_lens_kinematic.png"
set datafile separator ","

plot for [i=2:16] 'mag_lens_kinematic.csv' using 1:(column(i)) with lines lt 1 title "" 
