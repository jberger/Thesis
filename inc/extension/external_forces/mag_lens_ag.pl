#!/usr/bin/env perl

use strict;
use warnings;
use v5.10;

use Physics::UEMColumn alias => [qw/:standard Pulse/];
use Physics::UEMColumn::Auxiliary ':constants';

use PDL;

my $a = 1/4 * 0.001 * 25.4;
my $num = 1;
my $lens_position = 10 * $a;
my $strength = 2.55e-10;

my $column_length = 2 * $lens_position;

my $pulse = Pulse->new(
  number => $num,
  velocity => vc / 3,
  sigma_t => (500**2/2) . 'um^2',
  sigma_z => ((0.5*1e8)**2/2) . ' (ps m / s)^2',
  eta_t => (me * 0.114 / 3) . 'kg eV',
);

my $column = Column->new(
  length => $column_length . 'm',
);

my $sim = Physics::UEMColumn->new(
  column => $column,
  pulse => $pulse,
  steps => 200,
);

my $lens1 = MagneticLens->new(
  location => $lens_position . 'm',
  length   => $a / 10 . 'm',
  strength => $strength,
);

$sim->add_element($lens1);

my $result = pdl $sim->propagate;

my $z = $result->slice('(1),') - ( $lens_position );
my $w = sqrt( 2 * $result->slice('(3),') );

use PDL::Graphics::Prima::Simple;
line_plot $z, $w;

wcols $z, $w, "mag_lens_ag.csv", { COLSEP => ',' };

my $min_ind = $w->minimum_ind;
say "\t" . $w->at($min_ind) . 'm at z = ' . $z->at($min_ind) . 'f';

