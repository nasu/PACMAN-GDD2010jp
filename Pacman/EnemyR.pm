package Pacman::EnemyR;
use base qw/Pacman::Enemy/;
sub move {
  my ($self, $field, $pl_pos) = @_;
  my $en_pos = $self->getPos();
  # 初期候補
  my @way;
  if ($en_pos->[2] eq 'h') {
    @way = ([-1,0,'k'],[0,-1,'h'],[1,0,'j'],[0,1,'l'])
  } elsif ($en_pos->[2] eq 'j') {
    @way = ([0,-1,'h'],[1,0,'j'],[0,1,'l'],[-1,0,'k'])
  } elsif ($en_pos->[2] eq 'k') {
    @way = ([0,1,'l'],[-1,0,'k'],[0,-1,'h'],[1,0,'j']);
  } elsif ($en_pos->[2] eq 'l') {
    @way = ([1,0,'j'],[0,1,'l'],[-1,0,'k'],[0,-1,'h'])
  } else {
    @way = ([1,0,'j'],[0,-1,'h'],[-1,0,'k'],[0,1,'l'])
  }
  # 進路決定
  my $avail_cnt = 0;
  for my $way (@way) {
    my $h = $en_pos->[0] + $way->[0];
    my $w = $en_pos->[1] + $way->[1];
    my $char = $field->[$h]->[$w];
    next if $char =~ /^[#]$/;
    return (0, $h, $w) if $char =~ /@/;
    $self->setPos($h, $w, $way->[2]);
    return (1, $h, $w);
  }
  # 通常はいらないはず
  $self->setPos($en_pos->[0], $en_pos->[1], '.');
  return (1, $en_pos->[0], $en_pos->[1]);

}

1;
