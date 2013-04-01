set term tikz nopicenvironment scale 0.7,0.7

set ytics nomirror
set y2tics

set xlabel "Pulse Location rel. to RF Cav. (cm)"
set ylabel "HW1/eM Beam Width (mm)"
set y2label "HW1/eM Beam Length ($\\mu$m)"

set xrange [-10:15]

do for [name in "rf_cav_N1 rf_cav_N1e5"] {
  set output name . ".tex"
  input = name . ".dat"

  plot input using (100*$1):(1e3*$2) with lines title "",\
       input using (100*$1):(1e6*$3) with lines title "" lt 1 linecolor rgb "green" axes x1y2
}

