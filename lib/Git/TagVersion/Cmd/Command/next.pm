package Git::TagVersion::Cmd::Command::next;

use Moose;

extends 'Git::TagVersion::Cmd::Command';

# VERSION
# ABSTRACT: print next version

sub execute {
  my ( $self, $opt, $args ) = @_;
 
  if( defined $self->tag_version->next_version ) {
    print $self->tag_version->next_version->as_string."\n";
  }

  return;
}

1;

