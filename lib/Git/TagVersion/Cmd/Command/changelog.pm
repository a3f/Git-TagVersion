package Git::TagVersion::Cmd::Command::changelog;

use Moose;

extends 'Git::TagVersion::Cmd::Command';

# VERSION
# ABSTRACT: generate a changelog

has 'style' => (
  is => 'rw', isa => 'Str', default => 'simple',
  traits => [ 'Getopt' ],
  cmd_aliases => 's',
  documentation => 'format of changelog',
);

sub execute {
  my ( $self, $opt, $args ) = @_;

  foreach my $v ( @{$self->tag_version->versions} ) {
    print $v->render( $self->style );
  }

  return;
}

1;

