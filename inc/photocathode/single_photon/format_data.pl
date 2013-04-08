#!/usr/bin/env perl

use strict;
use warnings;

my $file = 'data';
my $data = do $file or die "Cannot load $file";
my $pulse_energy = 0.2;
my $err = 0.1;

my $output = 'w_plot_data.dat';
open my $fh, '>', $output or die "Cannot open $output";

local $, = " ";

my $bg;
for my $res (sort {$a->{laser} <=> $b->{laser}} values %$data ) {

  # lowest power considered background
  unless ($bg) {
    $bg = $res->{yield};
    next;
  }

  $res->{yield} -= $bg;
  my $w = $res->{w_av};
  my $yield = $res->{yield};

  print $fh join( " ", $res->{laser} * $pulse_energy, $w, $w*$err, $yield, $yield*$err ) . "\n";  
}

