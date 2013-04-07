#!/usr/bin/env perl

use strict;
use warnings;

my $file = 'data';
my $data = do $file or die "Cannot load $file";

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
  print $fh "@{$res}{qw/laser w_av yield/}\n";  
}

