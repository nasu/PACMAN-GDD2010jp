package Pacman::EnemyH;
use base qw/Pacman::Enemy/;
sub move {
  my ($self, $field, $pl_pos) = @_;
  my $en_pos = $self->getPos();
  if ($en_pos->[2] eq '.') {
    return $self->default_move($field, $pl_pos);
  } else {
    my @way = grep {
      my $h = $en_pos->[0] + $_->[0];
      my $w = $en_pos->[1] + $_->[1];
      $field->[$h]->[$w] ne '#';
    } ([1,0,'j'],[0,-1,'h'],[-1,0,'k'],[0,1,'l']);
    my $way_cnt = scalar(@way);
    if ($way_cnt == 1) {
      my $way = $way[0];
      $self->setPos($en_pos->[0] + $way->[0], $en_pos->[1] + $way->[1], $way->[2]);
      return(1, $en_pos->[0] + $way->[0], $en_pos->[1] + $way->[1]);
    } elsif ($way_cnt == 2) {
      my $way;
      for (@way) {
        if ($en_pos->[2] eq 'j') {
          next if ($_->[2] eq 'k');
        } elsif ($en_pos->[2] eq 'h') {
          next if ($_->[2] eq 'l');
        } elsif ($en_pos->[2] eq 'k') {
          next if ($_->[2] eq 'j');
        } elsif ($en_pos->[2] eq 'l') {
          next if ($_->[2] eq 'h');
        }
        $way = $_;
      }
      $self->setPos($en_pos->[0] + $way->[0], $en_pos->[1] + $way->[1], $way->[2]);
      return(1, $en_pos->[0] + $way->[0], $en_pos->[1] + $way->[1]);
    } elsif ($way_cnt >= 3) {
      if ($en_pos->[1] - $pl_pos->[1] > 0 && $field->[$en_pos->[0]]->[$en_pos->[1] - 1] ne '#') {
        $self->setPos($en_pos->[0], $en_pos->[1] - 1, 'h');
        return (1, $en_pos->[0], $en_pos->[1] - 1);
      } elsif ($en_pos->[1] - $pl_pos->[1] < 0 && $field->[$en_pos->[0]]->[$en_pos->[1] + 1] ne '#') {
        $self->setPos($en_pos->[0], $en_pos->[1] + 1, 'l');
        return (1, $en_pos->[0], $en_pos->[1] + 1);
      } elsif ($en_pos->[0] - $pl_pos->[0] > 0 && $field->[$en_pos->[0] - 1]->[$en_pos->[1]] ne '#') {
        $self->setPos($en_pos->[0] - 1, $en_pos->[1], 'k');
        return (1, $en_pos->[0] - 1, $en_pos->[1]);
      } elsif ($en_pos->[0] - $pl_pos->[0] < 0 && $field->[$en_pos->[0] + 1]->[$en_pos->[1]] ne '#') {
        $self->setPos($en_pos->[0] + 1, $en_pos->[1], 'j');
        return (1, $en_pos->[0] + 1, $en_pos->[1]);
      } else {
        return $self->default_move($field, $pl_pos);
      }
    }
  }
}

1;
