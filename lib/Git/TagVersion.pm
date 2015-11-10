package Git::TagVersion;

use Moose;

# VERSION
# ABSTRACT: module to manage version tags in git

use Git::TagVersion::Version;
use Git::Wrapper;


has 'fetch' => ( is => 'rw', isa => 'Bool', default => 0 );
has 'push' => ( is => 'rw', isa => 'Bool', default => 0 );

has 'root' => ( is => 'ro', isa => 'Str', default => '.' );
has 'repo' => (
  is => 'ro', isa => 'Git::Wrapper', lazy => 1,
  default => sub {
    my $self = shift;
    return Git::Wrapper->new( $self->root );
  },
);

has 'version_regex' => ( is => 'ro', isa => 'Str', default => '^v(\d.+)$' );

has 'versions' => (
  is => 'ro', isa => 'ArrayRef[Git::TagVersion::Version]', lazy => 1,
  default => sub {
    my $self = shift;
    my @versions;

    if( $self->fetch ) {
      $self->repo->fetch;
    }

    my $regex = $self->version_regex;
    foreach my $tag ( $self->repo->tag ) {
      if( my ($v_str) = $tag =~ /$regex/) {
        my $version;
        eval { $version = Git::TagVersion::Version->new_from_string( $v_str ) };
        if( $@ ) { next; }
        push( @versions, $version );
      }
    }
    return [ reverse sort @versions ];
  },
);

has 'last_version' => (
  is => 'ro', isa => 'Maybe[Git::TagVersion::Version]', lazy => 1,
  default => sub {
    my $self = shift;
    return( $self->versions->[0] );
  },
);

has 'incr_level' => ( is => 'rw', isa => 'Int', default => 0 );

has 'add_level' => ( is => 'rw', isa => 'Int', default => 0 );

has 'next_version' => (
  is => 'ro', isa => 'Maybe[Git::TagVersion::Version]', lazy => 1,
  default => sub {
    my $self = shift;
    if( ! defined $self->last_version ) {
      return;
    }
    if( $self->incr_level && $self->add_level ) {
      die('use increment or new minor version, not both');
    }
    my $next = $self->last_version->clone;
    if( $self->add_level ) {
      $next->add_level( $self->add_level );
    } else {
      $next->increment( $self->incr_level );
    }
    return $next;
  },
);

sub tag_next_version {
  my $self = shift;
  my $next = $self->next_version;

  if( ! defined $next ) {
    die('next version is not defined');
  }

  my $tag = 'v'.$next->as_string;
  $self->repo->tag($tag);

  if( $self->push ) {
    $self->repo->push('origin', $tag);
  }

  return $tag;
}

1;

