#!/usr/bin/env perl

use strict;
use warnings;

use Physics::UEMColumn alias => ':standard';
use Physics::UEMColumn::Auxiliary ':materials';
use PDL;

sub for_sharpness {
  my $laser = Laser->new(
    width    => '1 mm',
    duration => '1 ps',
    energy   => '4.75 eV',
  );

  my $acc = DCAccelerator->new(
    length  => '20 mm',
    voltage => '20 kilovolts',
    sharpness => shift || 10,
  );

  my $column = Column->new(
    length       => '25 mm', 
    laser        => $laser,
    accelerator  => $acc,
    photocathode => Photocathode->new(Ta),
  );

  my $sim = Physics::UEMColumn->new(
    column      => $column,
    number      => 1,
    debug       => 1,
  );

  my $result = $sim->propagate;

  return pdl $result;
}

for ( qw/ 5 10 20 / ) {
  my $pdl = for_sharpness($_)->dice([1,3,4])->sever;
  my $slice = $pdl->slice('1:2');
  $slice *= 2;
  $slice **= 0.5;
  $pdl->slice('0:1,') *= 1e3;
  $pdl->slice('2,') *= 1e6;
  $pdl->xchg(0,1)->wcols("sharpness$_.dat");
}

