set term png
set output 'gun.png'
set contour base
set cntrparam levels discrete -10,-9.6,-9.2,-8.8,-8.4,-8,-7.6,-7.2,-6.8,-6.4,-6,-5.6,-5.2,-4.8,-4.4,-4,-3.6,-3.2,-2.8,-2.4,-2,-1.6,-1.2,-0.8,-0.4
splot 'output.dat' with lines
