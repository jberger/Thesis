#!/usr/bin/env perl

use strict;
use warnings;

use Physics::UEMColumn alias => ':standard';

use PDL;
use PDL::Graphics::Prima::Simple [700,500];

my $laser = Laser->new(
  width    => '100 um',
  duration => '0.1 ps',
  energy   => '4.75 eV',
);

my $acc = DCAccelerator->new(
  length  => '20 mm',
  voltage => '20 kilovolts',
);

my $column = Column->new(
  length       => '350 mm', 
  laser        => $laser,
  accelerator  => $acc,
  photocathode => Photocathode->new( work_function => '4.25 eV' ), # Ta
);

my $sim = Physics::UEMColumn->new(
  column => $column,
  number => 1e6,
  steps  => 200,
  solver_opts => {
    h_max => 5e-13,
    h_init => 5e-14,
  },
);

my $z_rf       = 20; #cm
my $l_mag_lens = '1 in';
my $cooke_sep  = 5; #cm
my $str_mag    = 43e-13;

my $lens1 = MagneticLens->new(
  location => ($z_rf - $cooke_sep) . 'cm',
  length   => $l_mag_lens,
  strength => $str_mag,
);
my $lens2 = MagneticLens->new(
  location => ($z_rf + $cooke_sep) . 'cm',
  length   => $l_mag_lens,
  strength => $str_mag,
);
$sim->add_element($lens1);
$sim->add_element($lens2);

my $rf_cav = RFCavity->new(
  location  => $z_rf . 'cm',
  length    => '2 cm',
  strength  => '335 kilovolts / m',
  frequency => '3 gigahertz',
);
$sim->add_element($rf_cav);

my $result = pdl( $sim->propagate );

my $z  = $result->slice('(1),');
my $st = $result->slice('(3),');
my $sz = $result->slice('(4),');

plot(
  -st => ds::Pair( 
    $z, sqrt( $st / maximum($st) ),
    colors => pdl(255,0,0)->rgb_to_color,
    plotType => ppair::Lines,
    lineWidths => 3,
  ),
  -sz => ds::Pair( 
    $z, sqrt( $sz / maximum($sz) ),
    colors => pdl(0,255,0)->rgb_to_color,
    plotType => ppair::Lines,
    lineWidths => 3,
  ),
  x => { label => 'Position (m)' },
);

