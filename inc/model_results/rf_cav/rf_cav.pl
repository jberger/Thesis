#!/usr/bin/env perl

use strict;
use warnings;
use v5.10;

use Physics::UEMColumn alias => [qw/:standard Pulse/];
use Physics::UEMColumn::Auxiliary ':constants';

use PDL;
#use PDL::Graphics::Prima::Simple;

my $vel  = sqrt( 2 * qe * 20_000 / me );
my $freq = 3e9; # 3 GHz
my $d = $vel / (2 * $freq);

my @conditions = (
  ['rf_cav_N1.dat', 1, '450 kilovolts / m'],
  ['rf_cav_N1e5.dat', 1e5, '494 kilovolts / m'],
);

for my $cond (@conditions) {
  my ($file, $num, $strength) = @$cond;

  my $pulse = Pulse->new(
    number => $num,
    velocity => $vel,
    initial_width  => '100 um',
    initial_length => ($vel * 0.1) . 'ps m / s',
    excess_photoemission_energy => '0.5 eV',
  );

  my $column = Column->new(
    length => '250 mm',
  );

  my $sim = Physics::UEMColumn->new(
    column => $column,
    pulse => $pulse,
    steps => 200,
  );

  my $lens1 = RFCavity->new(
    location => '100 mm',
    length   => $d . 'm',
    frequency => $freq . 'Hz',
    strength => $strength,
  );

  $sim->add_element($lens1);

  my $result = pdl $sim->propagate;

  printf "\nNum: %d\n", $num;

  my $z  = $result->slice('(1),') - 100e-3;
  my $w = sqrt( 2 * $result->slice('(3),') );
  my $vt = sqrt( 2 * $result->slice('(4),') );

  #line_plot $z, $w;
  #line_plot $z, $vt;

  my $mask = $result->slice('1,') > 0.02;
  my $later = $result->transpose->whereND( $mask->transpose )->transpose;

  printf "Mask starts at %.2fmm\n", $later->at(1,0)/1e-3;

  # length
  my $min_sz_ind = $later->slice('(4),')->minimum_ind;
  my $min_length = sqrt( 2 * $later->at(4,$min_sz_ind) );
  my $min_duration = $min_length / $later->at(2,$min_sz_ind);
  printf "Min Length: %.2fum (%.2ffs) at %.2fmm\n", $min_length/1e-6, $min_duration/1e-15, $later->at(1,$min_sz_ind)/1e-3;
  printf "Width at min length: %.2fmm\n", sqrt( 2 * $later->at(3,$min_sz_ind) )/1e-3;

  wcols $z, $w, $vt, $file;
}

