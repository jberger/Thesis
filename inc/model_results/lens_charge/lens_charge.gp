set term tikz solid nopicenvironment scale 0.7,0.7

# need to set data variable `gnuplot -e 'length="60"' lens_charge.gp`

# common plot settings
set ylabel "HW1/eM beam width (mm)"
set logscale y
shape="prolate"


do for [length in "6 60"] {

  file = "lens_" . length . "mm_" . shape

  set output file."_data.tex"

  #set yrange [0.1:1.5]

  set xlabel "Pulse location rel. to $f$=".length."mm lens"

  plot for [i=1:10:2] file.".dat" using i:i+1 with lines title ""
}

