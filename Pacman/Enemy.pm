package Pacman::Enemy;
use base qw/Pacman::Character/;
use Pacman::Character;

sub default_move {
  my ($self, $field, $pl_pos) = @_;
  my $en_pos = $self->getPos();
  my @way = ([1,0,'j'],[0,-1,'h'],[-1,0,'k'],[0,1,'l']);
  for my $way (@way) {
    my $h = $en_pos->[0] + $way->[0];
    my $w = $en_pos->[1] + $way->[1];
    my $char = $field->[$h]->[$w];
    next if $char =~ /^[#]$/;
    return (0, $h, $w) if $char =~ /@/;
    $self->setPos($h, $w, $way->[2]);
    return (1, $h, $w);
  }
}

1;
