#!/usr/bin/env perl

use strict;
use warnings;

use PDL;
use PDL::Image2D;
use PDL::Fit::Gaussian;

use Prima;
use PDL::Graphics::Prima::Simple;# -sequential;

use File::chdir;

use List::Util;

use constant { 
  pi => 4*atan2(1,1),
  wconv => 1 / ( 2 * sqrt( log(2) ) ),
};

my $folder = shift;
local $CWD = $folder;

my $cache_name = 'data';
my $tag = 'fourier';
my $nd_tag = qr/nd(\d+)/;
my $handle_backgrounds = 0;
my $too_large = 900;
my $laser = sub{ cos(pi / 180 * 2 * shift)**2 };

my $files;
if ( not -e $cache_name ) {
  $files = analyze_folder();

  # cache data
  require Data::Dumper;
  open my $fh, '>', $cache_name;
  print $fh Data::Dumper::Dumper($files);
} else {
  $files = do $cache_name;
}

# print for humans
use Data::Printer;
p $files;

line_plot(make_piddles($files));

sub analyze_folder {

  # find all fit(s) files
  my %files = map { $_, { file => $_ } } do {
    opendir( my $dh, $CWD );

    grep { /\.fits?/ }
    readdir $dh;
  };

  # keep only certain tags (e.g. fourier)
  if ($tag) {
    my @wrong_tag = grep { not /$tag/i } keys %files;
    delete @files{@wrong_tag};
  }

  # remove background images
  unless ($handle_backgrounds) {
    my @bg = grep { /bg/ } keys %files;
    delete @files{@bg};
  }

  # parse filenames
  foreach (keys %files) {
    # polarizer info
    my $re_angle = /deg/ ? qr/(m?)(\d+)deg/ : qr/(m?)(\d{2,})/;

    if ( $_ =~ $re_angle ) {
      $files{$_}{polarizer} = $2 * ($1 ? -1 : 1); # m indicates negative number
      $files{$_}{laser} = $laser->($files{$_}{polarizer});
    } 

    # nd info
    if ( $_ =~ $nd_tag ) {
      $files{$_}{nd} = $1;
    } else {
      $files{$_}{nd} = 0;
    }
  }

  foreach my $file (sort {$files{$a}{laser} <=> $files{$b}{laser}} keys %files) {
    next unless $file =~ /\.fits?$/;

    print "processing file: $file\n";

    my $pdl = rfits $file;
    my @w = analyze($pdl);
    $files{$file}{w} = \@w;
    $files{$file}{w_av} = 0.5 * List::Util::sum @w;
    $files{$file}{yield} = $pdl->float->sum / $pdl->nelem;
  }

  return handle_nd(\%files);
}

sub make_piddles {
  my $files = shift;

  my (@laser, @w_av);
  foreach (sort {$files->{$a}{laser} <=> $files->{$b}{laser}} keys %$files) {
    next if $files->{$_}{w_av} > $too_large;

    push @laser, $files->{$_}{laser};
    push @w_av, $files->{$_}{w_av};
  }

  my $pdl_laser = pdl \@laser;
  my $pdl_w_av = pdl \@w_av;

  return $pdl_laser, $pdl_w_av;
}

sub analyze {
  my $pdl = shift;
  my ($x_dim, $y_dim) = $pdl->dims;
  my ($val, $max_x, $max_y) = $pdl->max2d_ind;

  my ($wx, $wy);

  plot(
    -data => ds::Grid(
      $pdl, 
      x_bounds => [1,$x_dim],
      y_bounds => [1,$y_dim],
      plotType => pgrid::Matrix(
        palette => pal::BlackToWhite,
      ),
    ),
    -max => ds::Pair(
      $max_x, $max_y,
      plotTypes => ppair::Crosses,
      colors => pdl(255, 0, 0)->rgb_to_color,
    ),
    onMouseClick => sub {
      my ($self, $button, undef, $x, $y) = @_;
      my $left = $button & mb::Left;
      my $right = $button & mb::Right;

      return unless ($left or $right);
      
      if ( $left ) {
        $x = int $self->x->pixels_to_reals($x);
        $y = int $self->y->pixels_to_reals($y); #-- #highlight fix
      } else {
        ($x, $y) = ($max_x, $max_y);
      }

      ($wx, $wy) = xy_fit($pdl, $x, $y);

      #$self->get_parent->notify("Close"); 
    },
  );

  return ($wx, $wy);
}

sub xy_fit {
  my ($pdl, $x, $y) = @_;

  my $x_lineout = $pdl->slice(",($y)");
  my $y_lineout = $pdl->slice("($x),");

  # pixels are binned in twos
  my (undef, undef, $fwhm_x) = fitgauss1d(
    $x_lineout->sequence * 2 * 5.4,
    $x_lineout,
  );

  my (undef, undef, $fwhm_y) = fitgauss1d(
    $y_lineout->sequence * 2* 5.4,
    $y_lineout,
  );

  return 
    map { wconv * $_ }
    map {eval{$_->isa('PDL')} ? $_->list : $_} 
    ($fwhm_x, $fwhm_y);
}

sub handle_nd {
  my $files = shift;
  my %comps;

  for my $file (values %$files) {
    push @{$comps{$file->{polarizer}}}, $file;
  }

  my $factor = 1;
  for my $pol (sort { $b <=> $a } keys %comps) {
    my $comp = $comps{$pol};
    if ( @$comp < 2 ) {
      $comp->[0]->{yield} *= $factor;
      next;
    }

    die "Too many comps" if @$comp > 2;

    my ($low, $high) = sort { $a->{nd} <=> $b->{nd} } @$comp;
    $factor *= $low->{yield} / $high->{yield};

    $high->{yield} *= $factor;
    delete $files->{$low->{file}};
  }

  return $files;
}
