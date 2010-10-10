package Pacman::Character;
sub new {
  my $self = shift;
  my $icon = shift;
  bless +{
    ICON  => $icon,
    POS   => +[],
    ROUTE => +[],
    DIRECT => 'j',
  }, $self;
}

sub pos {
  my ($self, $h, $w) = @_;
  my $pos = $self->getPos();
  if ($pos->[0] == $h && $pos->[1] == $w) {
    return 1;
  }
  return 0;
}

sub getIcon {
  my $self = shift;
  return $self->{ICON};
}

sub setPos {
  my $self = shift;
  my ($h, $w, $direct) = @_;
  $self->{POS} = +[$h, $w, $direct];
  push(@{$self->{ROUTE}}, $self->{POS}); 
}

sub getPos {
  my $self = shift;
  return $self->{POS};
}

sub setDirect {
  my $self = shift;
  $self->{DIRECT} = shift;
}

sub getDirect {
  my $self = shift;
  return $self->{DIRECT};
}

sub route {
  my $self = shift;
  return $self->{ROUTE};
}

1;
