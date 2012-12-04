set term tikz nopicenvironment
set output "power_seq_data.tex"
set xlabel "Laser Intensity (MW/cm$^2$)"
set ylabel "Electrons per pulse (a.u.)"
set xrange [0:46]
set yrange [0:1]
plot "power_seq.dat" using ($1*46):($2/199479568) title "" with lines lt 1 lw 2,\
     "power_seq.dat" using ($3*46):($4/199479568) title "" with lines lt 2 lw 2
