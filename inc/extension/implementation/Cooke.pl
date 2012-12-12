#!/usr/bin/env perl

use strict;
use warnings;

use Physics::UEMColumn alias => ':standard';
use Physics::UEMColumn::Auxiliary ':materials';

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
  length       => '400 mm', 
  laser        => $laser,
  accelerator  => $acc,
  photocathode => Photocathode->new(Ta),
);

my $sim = Physics::UEMColumn->new(
  column      => $column,
  number      => 1,
  debug       => 1,
);

my $z_rf       = 20; #cm
my $l_mag_lens = '1 in';
my $cooke_sep  = 5; #cm
my $str_mag    = 33e-13;

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
  strength  => '230 kilovolts / m',
  frequency => '3 gigahertz',
);
$sim->add_element($rf_cav);

my $result = $sim->propagate;

