#!/usr/bin/env perl

use strict;
use warnings;

use Physics::UEMColumn alias => ':standard';
use Physics::UEMColumn::Auxiliary ':constants';

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

my $length = 0.15; # 15 cm
my $eta_t = me * qe * (0.5) / 3; # 0.5 eV excess energy
my $vol = (1e-3)**3;

my $for_xi = gen_xi_series( 1, $vol, $eta_t, $length );

for my $xi ( 1/3, 1, 3 ) {
  my $result = $for_xi($xi);
  for (@$result) {
    next unless $_->[1] >= $length;
    print {$fh} $num . ' ' . sqrt( 2 * $_->[3] ) * 1e3 . ' ' . sqrt( 2 * $_->[4] ) * 1e3 . "\n";
    last;
  }
}
