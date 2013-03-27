#!/usr/bin/env perl

use strict;
use warnings;

use Physics::UEMColumn alias => [qw':standard Pulse'];
use Physics::UEMColumn::Auxiliary ':constants';

my $n = shift or die "Please specify a number of electrons";

my $length = 0.15; # 15 cm
my $dE = '0.5 eV';
my $vol = (1e-3)**3;

my $for_xi = gen_xi_series( $n, $vol, $dE, $length );

for my $spec ( [ oblate => 1/3 ], [ sphere => 1.0001 ], [ prolate => 3 ] ) {
  my ( $shape, $xi ) = @$spec;
  my $file = "shape_${shape}_N$n.dat";
  open my $fh, '>', $file or die "Cannot open $file: $!\n";

  my $result = $for_xi->($xi);
  my ($st0, $sz0) = @{$result->[0]}[3,4];
  for (@$result) {
    print {$fh} $_->[1] . ' ' . sqrt( $_->[3] / $st0 ) . ' ' . sqrt( $_->[4] / $sz0 ) . "\n";
    last if $_->[1] >= $length;
  }
}

sub gen_xi_series {
  my ($n, $vol, $dE, $length) = @_; 

  return sub {
    my $xi = shift;

    my $wt = ( $vol / $xi ) ** (1/3);
    my $wz = ( $xi ** 2 * $vol ) ** (1/3);

    my $pulse = Pulse->new(
      velocity => '1e8 m/s',
      number   => $n,
      sigma_t  => $wt**2 / 2,
      sigma_z  => $wz**2 / 2,
      excess_photoemission_energy => $dE,
    );

    my $column = Column->new(
      length => $length, 
    );

    my $sim = Physics::UEMColumn->new(
      column => $column,
      pulse  => $pulse,
    );

    my $result = $sim->propagate;
    return $result;
  }
}

