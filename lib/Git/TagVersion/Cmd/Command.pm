package Git::TagVersion::Cmd::Command;

use Moose;

# VERSION
# ABSTRACT: base class for all git-tag-version subcommands

extends 'MooseX::App::Cmd::Command';

use Git::TagVersion;

has 'fetch' => (
  is => 'rw', isa => 'Bool', default => 0,
  traits => [ 'Getopt' ],
  cmd_aliases => 'f',
  documentation => 'fetch remote refs first',
);

has 'repo' => (
  is => 'ro', isa => 'Str', default => '.',
  traits => [ 'Getopt' ],
  cmd_aliases => 'r',
  documentation => 'path to git repository',
);

has 'tag_version' => (
  is => 'ro', isa => 'Git::TagVersion', lazy => 1,
  traits => [ 'NoGetopt' ],
  default => sub {
    my $self = shift;
    return Git::TagVersion->new(
      fetch => $self->fetch,
      root => $self->repo,
    );
  },
);

1;

