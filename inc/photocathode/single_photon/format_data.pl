#!/usr/bin/env perl

use strict;
use warnings;
use List::Util 'max';

my $file = 'data';
my $data = do $file or die "Cannot load $file";
my $pulse_energy = 0.2;

my $output = 'w_plot_data.dat';
open my $fh, '>', $output or die "Cannot open $output";

local $, = " ";

my $w_err = 0.1;

my ($bg, $yield_err);
for my $res (sort {$a->{laser} <=> $b->{laser}} values %$data ) {

  # lowest power considered background
  unless ($bg) {
    $bg = $res->{yield};
    $yield_err = $bg / 4;
    next;
  }

  my $w = $res->{w_av} / 1000;
  my $yield = $res->{yield} - $bg;

  print $fh join( " ", $res->{laser} * $pulse_energy, $w, $w*$w_err, $yield, $yield_err ) . "\n";  
}

