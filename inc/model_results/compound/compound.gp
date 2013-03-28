set term tikz nopicenvironment
set output "compound_data.tex"

file = "compound.dat"

set ytics nomirror
set y2tics

set xlabel "Position in Column (cm)"
set ylabel "HW1/eM Beam Width (mm)"
set y2label "HW1/eM Beam Length (mm)"

set xrange [0:32]

plot file using (1e2*$1):(1e3*$2) with lines title "",\
     file using (1e2*$1):(1e3*$3) with lines title "" lt 1 linecolor rgb "green" axes x1y2

