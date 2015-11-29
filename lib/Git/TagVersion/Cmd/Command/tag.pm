package Git::TagVersion::Cmd::Command::tag;

use Moose;

extends 'Git::TagVersion::Cmd::Command';

# VERSION
# ABSTRACT: create a new version tag

has 'push' => (
  is => 'rw', isa => 'Bool', default => 0,
  traits => [ 'Getopt' ],
  cmd_aliases => 'p',
  documentation => 'push new created tag to remote',
);

has 'major' => (
  is => 'ro', isa => 'IncrOption', default => 0,
  traits => [ 'Getopt' ],
  cmd_aliases => [ 'm' ],
  documentation => 'do a (more) major release',
);

has 'minor' => (
  is => 'ro', isa => 'IncrOption', default => 0,
  traits => [ 'Getopt' ],
  documentation => 'add a new minor version level',
);

sub execute {
  my ( $self, $opt, $args ) = @_;

  $self->last_version->push( $self->push );
  if( $self->major ) {
    $self->tag_version->incr_level( $self->major );
  }
  if( $self->minor ) {
    $self->tag_version->add_level( $self->minor );
  }
 
  my $tag = $self->tag_next_version;
  print "tagged $tag\n";

  return;
}

1;

