#!/usr/bin/env perl

use strict;
use warnings;
use v5.10;

use Physics::UEMColumn alias => ':standard';

use PDL;
use PDL::Graphics::Prima::Simple;

sub gen_sim {
  my ($lens_position, $strength) = @_;
  my $column_length = 3 * $lens_position;

  return sub {
    my $num = shift;
    my $laser = Laser->new(
      width    => '1 mm',
      duration => '1 ps',
      energy   => '4.75 eV',
    );

    my $acc = DCAccelerator->new(
      length  => '20 mm',
      voltage => '20 kilovolts',
    );

    my $column = Column->new(
      length       => $column_length, 
      laser        => $laser,
      accelerator  => $acc,
      photocathode => Photocathode->new( work_function => '4.25 eV' ), # Ta
    );

    my $sim = Physics::UEMColumn->new(
      column => $column,
      number => $num,
    );

    my $lens1 = MagneticLens->new(
      location => $lens_position,
      length   => '1 in',
      strength => $strength,
    );

    $sim->add_element($lens1);

    return pdl $sim->propagate;
  }
}

my $out;
my $sim = gen_sim( 0.20, 26.5e-13 );

for ( qw/ 1e0 1e4 1e5 1e6 1e7 / ) {
  my $result = $sim->($_);
  my $z  = $result->slice('(1),');
  my $st = $result->slice('(3),');

  wcols $z, $st, "lens_20cm_n$_.dat";

  my $min_ind = $st->minimum_ind;
  say $z->at($min_ind) / 0.40;
}

#line_plot $z, $st;

