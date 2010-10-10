package Pacman::EnemyJ;
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
      unless (defined $self->{CROSS_CNT}) {
        $self->{CROSS_CNT} = 0;
      }
      $self->{CROSS_CNT}++;
      if ($self->{CROSS_CNT} % 2 == 1) {
        # 初期候補
        my @way;
        if ($en_pos->[2] eq 'h') {
          @way = ([1,0,'j'],[0,-1,'h'],[-1,0,'k'],[0,1,'l']);
        } elsif ($en_pos->[2] eq 'j') {
          @way = ([0,1,'l'],[1,0,'j'],[0,-1,'h'],[-1,0,'k']);
        } elsif ($en_pos->[2] eq 'k') {
          @way = ([0,-1,'h'],[-1,0,'k'],[0,1,'l'],[1,0,'j']);
        } elsif ($en_pos->[2] eq 'l') {
          @way = ([-1,0,'k'],[0,1,'l'],[1,0,'j'],[0,-1,'h']);
        } else {
          @way = ([1,0,'j'],[0,-1,'h'],[-1,0,'k'],[0,1,'l']);
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
      } else {
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
      }
    }
  }

}

1;
