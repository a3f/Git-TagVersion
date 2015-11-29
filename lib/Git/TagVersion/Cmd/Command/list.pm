package Git::TagVersion::Cmd::Command::list;

use Moose;

extends 'Git::TagVersion::Cmd::Command';

# VERSION
# ABSTRACT: print all versions

sub execute {
  my ( $self, $opt, $args ) = @_;
 
  foreach my $v ( @{$self->tag_version->versions} ) {
    print $v->as_string."\n";
  }

  return;
}

1;

