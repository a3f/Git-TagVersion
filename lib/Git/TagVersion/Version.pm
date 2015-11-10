package Git::TagVersion::Version;

use Moose;

# VERSION
# ABSTRACT: class for working with a version number

use overload
  'cmp' => \&_cmp;

has 'digits' => (
  is => 'rw', isa => 'ArrayRef[Int]', default => sub { [] },
);

has 'seperator' => ( is => 'ro', isa => 'Str', default => '.' );

sub _cmp {
  my ( $obj_a, $obj_b ) = @_;

  my $i = 0;
  while(
      defined $obj_a->digits->[$i]
      && defined $obj_b->digits->[$i] ) {
    my $a = $obj_a->digits->[$i];
    my $b = $obj_b->digits->[$i];
    if( defined $a && ! defined $b ) {
      return 1;
    } elsif( ! defined ! $a && defined $b ) {
      return -1;
    } elsif( $a > $b ) {
      return 1;
    } elsif( $a < $b ) {
      return -1;
    }
    $i++
  }

  return 0;
}

sub clone {
  my $self = shift;
  return __PACKAGE__->new( digits => [ @{$self->digits} ] );
}

sub increment {
  my ( $self, $level ) = @_;
  my $i = -1 - $level;
  my @digits = @{$self->digits};

  my $value = $digits[$i];
  if( ! defined $value ) {
    die("cannot increment version at level $level");
  }

  $value++;
  splice @digits, $i, ($level + 1), ( $value, (0) x $level ) ;

  $self->digits( \@digits );
  return;
}

sub add_level {
  my ( $self, $level ) = @_;
  my @digits = @{$self->digits};
  foreach my $i (1..$level) {
    push( @digits, 0 );
  }
  $self->digits( \@digits );
  return;
}

sub as_string {
  my $self = shift;
  return( join( $self->seperator, @{$self->digits} ) );
}

sub parse_string {
  my ( $self, $string ) = @_;
  $string =~ s/^v//;

  my @digits = split(/\./, $string );

  foreach my $d ( @digits ) {
    if( $d !~ /^\d+$/ ) {
      die("$d is not numeric in version string");
    }
  }

  $self->digits( \@digits );

  return;
}

sub new_from_string {
  my ( $class, $string ) = @_;
  my $obj = $class->new;
  $obj->parse_string( $string );
  return $obj;
}

1;

