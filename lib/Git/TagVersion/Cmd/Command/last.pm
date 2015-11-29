package Git::TagVersion::Cmd::Command::last;

use Moose;

extends 'Git::TagVersion::Cmd::Command';

# VERSION
# ABSTRACT: print last version

sub execute {
  my ( $self, $opt, $args ) = @_;
 
  if( defined $self->tag_version->last_version ) {
    print $self->tag_version->last_version->as_string."\n";
  }

  return;
}

1;

