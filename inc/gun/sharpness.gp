set term tikz nopicenvironment
set output "sharpness_data.tex"
set ytics nomirror
set y2tics
set xlabel "Position in column (mm)"
set ylabel "HW1/eM pulse width (mm) (solid)"
set y2label "HW1/eM pulse length ($\\mu$m) (dashed)"
set xrange [0:10]
set y2range [0:75]
plot "sharpness5.dat" using 1:2 with lines linecolor rgb "red" lt 1 title "",\
     "sharpness5.dat" using 1:3 axes x1y2 with lines linecolor rgb "red" lt 2 title "",\
     "sharpness10.dat" using 1:2 with lines linecolor rgb "green" lt 1 title "",\
     "sharpness10.dat" using 1:3 axes x1y2 with lines linecolor rgb "green" lt 2 title "",\
     "sharpness20.dat" using 1:2 with lines linecolor rgb "blue" lt 1 title "",\
     "sharpness20.dat" using 1:3 axes x1y2 with lines linecolor rgb "blue" lt 2 title ""
