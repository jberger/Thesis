#!/usr/bin/env perl

use strict;
use warnings;
use v5.10;

use Physics::UEMColumn alias => [qw/:standard Pulse/];
use Physics::UEMColumn::Auxiliary ':constants';

use PDL;

sub gen_sim {
  my ($lens_position, $strength, $is_prolate) = @_;
  my $column_length = 4 * $lens_position;

  return sub {
    my $num = shift;

    my $pulse = Pulse->new(
      number => $num,
      velocity => vc / 3,
      initial_width  => $is_prolate ? '500 um' : '107.7 um',
      initial_length => $is_prolate ? '50 um'  : '1077 um',
      excess_photoemission_energy => '0.5 eV',
    );

    my $column = Column->new(
      length => $column_length . 'mm',
    );

    my $sim = Physics::UEMColumn->new(
      column => $column,
      pulse => $pulse,
      steps => 200,
    );

    my $lens1 = MagneticLens->new(
      location => $lens_position . 'mm',
      length   => '0.1 in',
      strength => $strength,
    );

    $sim->add_element($lens1);

    return pdl $sim->propagate;
  }
}

use Tie::Array::CSV;

my @charges = qw/ 1e0 1e4 1e5 1e6 1e7 /;

my @sets = (
  [ 6,  730e-12, 1, \@charges ],
  [ 60, 675e-13, 1, \@charges ],
  [ 6,  730e-12, 0, \@charges ],
  [ 60, 920e-13, 0, [ @charges[0..$#charges-1] ] ],
);

foreach my $set ( @sets ) {
  my $lens = $set->[0];
  my $charges = pop @$set;

  my $filename = "lens_${lens}mm_" . ( $set->[2] ? 'prolate' : 'oblate' ) . '.dat';
  tie my @out, 'Tie::Array::CSV', $filename, sep_char => ' ';
  my $column = 0;

  say "$lens mm";
  my $sim = gen_sim( @$set );

  for ( @$charges ) {
    print "\t$_:";

    my $result = $sim->($_);
    my $z  = $result->slice('(1),') / ( $lens * 1e-3 ) - 1;
    my $w = sqrt( 2 * $result->slice('(3),') ) * 1000;

    #wcols $z, $w, "lens_${lens}mm_n$_.dat";
    my $i = 0;
    $out[$i++][$column] = $_ for $z->list;
    $i = 0;
    $out[$i++][$column+1] = $_ for $w->list;
    $column += 2;

    my $min_ind = $w->minimum_ind;
    say "\t" . $w->at($min_ind) . 'mm at z = ' . $z->at($min_ind) . 'f';

  }

}

