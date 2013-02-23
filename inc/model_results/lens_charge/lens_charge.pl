#!/usr/bin/env perl

use strict;
use warnings;
use v5.10;

use Physics::UEMColumn alias => [qw/:standard Pulse/];
use Physics::UEMColumn::Auxiliary ':constants';

use PDL;
use PDL::Graphics::Prima::Simple;

sub gen_sim {
  my ($lens_position, $strength) = @_;
  my $column_length = 4 * $lens_position;

  return sub {
    my $num = shift;
#    my $laser = Laser->new(
#      width    => '1 mm',
#      duration => '1 ps',
#      energy   => '4.75 eV',
#    );

#    my $acc = DCAccelerator->new(
#      length  => '20 mm',
#      voltage => '20 kilovolts',
#    );

    my $pulse = Pulse->new(
      number => $num,
      velocity => vc / 3,
      sigma_t => (500**2/2) . 'um^2',
      sigma_z => ((0.5*1e8)**2/2) . ' (ps m / s)^2',
      eta_t => (me * 0.5 / 3) . 'kg eV',
    );

    my $column = Column->new(
      length       => $column_length . 'mm',
#      laser        => $laser,
#      accelerator  => $acc,
#      photocathode => Photocathode->new( work_function => '4.25 eV' ), # Ta
    );

    my $sim = Physics::UEMColumn->new(
      column => $column,
      pulse => $pulse,
#      number => $num,
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

my @sets = (
  [ 6,  730e-12 ],
  [ 60, 675e-13 ],
);

foreach my $set ( @sets ) {
  my $lens = $set->[0];

  say "$lens mm";
  my $sim = gen_sim( @$set );

  for ( qw/ 1e0 1e4 1e5 1e6 1e7 / ) {
    print "\t$_:";

    my $result = $sim->($_);
    my $z  = $result->slice('(1),') / ( $lens * 1e-3 ) - 1;
    my $w = sqrt( 2 * $result->slice('(3),') ) * 1000;

    wcols $z, $w, "lens_${lens}mm_n$_.dat";

    my $min_ind = $w->minimum_ind;
    say "\t" . $w->at($min_ind) . 'mm at z = ' . $z->at($min_ind) . 'f';
  }

}

#line_plot $z, $st;

