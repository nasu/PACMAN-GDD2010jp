package Pacman::Player;
use base qw/Pacman::Character/;
use Term::ReadKey;

sub move {
  my ($self, $field, $enemy, $p) = @_;
  my $way;
  my ($h, $w) = (0, 0);
  while (1) {
    unless (defined @{$self->{stack}} && scalar(@{$self->{stack}})) {
      while (1) {
        print $p->display();
        print "Input next pos:";
        ReadMode "normal";
        chomp ($way = ReadLine());
        if ($way =~ /^[hjkl\.]+$/) {
          last;
        } elsif ($way =~ /^\x1b\x5b([A-D])/) {
          # Ìð°õ¤ÎÂÐ±þ
          if ($1 eq 'A') {
            $way = 'k';
          } elsif ($1 eq 'B') {
            $way = 'j';
          } elsif ($1 eq 'C') {
            $way = 'l';
          } elsif ($1 eq 'D') {
            $way = 'h';
          }
          last;
        } else {
          print "huh?\n";
        }
      }
      push(@{$self->{stack}}, split(//, $way));
    }
    $way = shift @{$self->{stack}};
    my $pl_pos = $self->getPos();
    if ($way eq 'h') {
      $h = $pl_pos->[0];
      $w = $pl_pos->[1] - 1;
    } elsif ($way eq 'j') {
      $h = $pl_pos->[0] + 1;
      $w = $pl_pos->[1];
    } elsif ($way eq 'k') {
      $h = $pl_pos->[0] - 1;
      $w = $pl_pos->[1];
    } elsif ($way eq 'l') {
      $h = $pl_pos->[0];
      $w = $pl_pos->[1] + 1;
    } else {
      $h = $pl_pos->[0];
      $w = $pl_pos->[1];
      $way = '.';
    }
    if ($field->[$h]->[$w] eq '#') {
      print "huh?\n";
      next;
    }
    last;
  }
  $self->setPos($h, $w, $way);
  return (1, $h, $w);
}

sub auto_move {
  my ($self, $way, $field, $enemy) = @_;
  my $pl_pos = $self->getPos();
  my ($h, $w);
  if ($way eq 'h') {
    $h = 0;
    $w = -1;
  } elsif ($way eq 'j') {
    $h = 1;
    $w = 0;
  } elsif ($way eq 'k') {
    $h = -1;
    $w = 0;
  } elsif ($way eq 'l') {
    $h = 1;
    $w = 0;
  } elsif ($way eq '.') {
    $h = $w = 0;
  }
  $self->setPos($pl_pos->[0] + $h, $pl_pos->[1] + $w, '.');
  return (1, $pl_pos->[0], $pl_pos->[1]);
}

1;
