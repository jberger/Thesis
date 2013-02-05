#!/usr/bin/env perl

use strict;
use warnings;

use Physics::UEMColumn alias => [qw':standard Pulse'];
use Physics::UEMColumn::Auxiliary ':constants';

my $n = shift or die "Please specify a number of electrons";

my $length = 0.15; # 15 cm
my $eta_t = me * qe * (0.5) / 3; # 0.5 eV excess energy
my $vol = (1e-3)**3;

my $for_xi = gen_xi_series( $n, $vol, $eta_t, $length );

for my $spec ( [1/3, 'prolate' ], [1.0001, 'sphere'], [3, 'oblate'] ) {
  my ( $xi, $shape ) = @$spec;
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
  my ($n, $vol, $eta_t, $length) = @_; 

  return sub {
    my $xi = shift;

    my $wt = ( $vol / $xi ) ** (1/3);
    my $wz = ( $xi ** 2 * $vol ) ** (1/3);

    my $pulse = Pulse->new(
      velocity => '1e8 m/s',
      number   => $n,
      gamma_t  => 0,
      gamma_z  => 0,
      eta_t    => $eta_t,
      eta_z    => $eta_t / 4,
      sigma_t  => $wt**2 / 2,
      sigma_z  => $wz**2 / 2,
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

