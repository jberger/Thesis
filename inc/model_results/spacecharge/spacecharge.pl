#!/usr/bin/env perl

use strict;
use warnings;

use Getopt::Long;
GetOptions( accelerator => \my $use_acc );

use Physics::UEMColumn alias => [qw/:standard Pulse/];
use Physics::UEMColumn::Auxiliary qw/:materials :constants/;

sub for_number {
  my ($num, $use_acc) = @_;

  my $sim;
  if ( $use_acc ) {
    my $laser = Laser->new(
      width    => '1 mm',
      duration => '1 ps',
      energy   => '4.75 eV',
    );

    my $acc = DCAccelerator->new(
      length  => '20 mm',
      voltage => '30 kilovolts',
    );

    my $column = Column->new(
      length       => '15 cm', 
      laser        => $laser,
      accelerator  => $acc,
      photocathode => Photocathode->new(Ta),
    );

    $sim = Physics::UEMColumn->new(
      column => $column,
      number => $num,
    );

  } else {

    $sim = Physics::UEMColumn->new(
      column => Column->new( length => '15 cm' ),
      pulse  => Pulse->new(
        number => $num,
        initial_width => '1 mm',
        initial_length => ( vc / 3 * 1e-12 ) . ' m',
        velocity => vc / 3,
      ),
    );

  }

  my $result = $sim->propagate;
  return $result;
}

my $outfilename = $use_acc ? 'spacecharge_acc.dat' : 'spacecharge_noacc.dat';
open my $fh, '>', $outfilename or die "Cannot open $outfilename for writing";

my @nums = map { ("1e$_", "2.2e$_", "4.6e$_") } (0..8);
pop @nums for 1..2;

for my $num ( @nums ) {
  my $result = for_number($num, $use_acc);
  for (@$result) {
    next unless $_->[1] >= 0.15;
    print {$fh} $num . ' ' . sqrt( 2 * $_->[3] ) * 1e3 . ' ' . sqrt( 2 * $_->[4] ) * 1e3 . "\n";
    last;
  }
}

