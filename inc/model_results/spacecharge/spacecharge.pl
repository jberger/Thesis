#!/usr/bin/env perl

use strict;
use warnings;

use Physics::UEMColumn alias => ':standard';
use Physics::UEMColumn::Auxiliary ':materials';

sub for_number {
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
    length       => '15 cm', 
    laser        => $laser,
    accelerator  => $acc,
    photocathode => Photocathode->new(Ta),
  );

  my $sim = Physics::UEMColumn->new(
    column      => $column,
    number      => $num,
  );

  my $result = $sim->propagate;
  return $result;
}

open my $fh, '>', 'spacecharge.dat';

my @nums = map { ("1e$_", "2.2e$_", "4.6e$_") } (0..8);
pop @nums for 1..2;

for my $num ( @nums ) {
  my $result = for_number($num);
  for (@$result) {
    next unless $_->[1] >= 0.15;
    print {$fh} $num . ' ' . sqrt( 2 * $_->[3] ) * 1e3 . ' ' . sqrt( 2 * $_->[4] ) * 1e3 . "\n";
    last;
  }
}

