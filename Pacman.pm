package Pacman;
use Pacman::EnemyAdapter;
use Pacman::Player;

sub new {
  my $self = shift;
  bless +{
    T => undef,
    W => undef,
    H => undef,
    FIELD => undef,
  }, $self;
}

sub init {
  my $self = shift;

  # 入力情報
  my ($T, $WH, @FIELD) = split(/\r?\n/, shift);
  my ($W, $H) = split(/ /, $WH);
  die 'ERR: invalid map format.' unless scalar(@FIELD) == $H;
  die 'ERR: invalid map format.' unless $FIELD[0]  =~ /^#+$/;
  die 'ERR: invalid map format.' unless $FIELD[-1] =~ /^#+$/;
  my $FIELD;
  for (@FIELD) {
    my $line = +[split //];
    die 'ERR: invalid map format.' unless scalar(@$line) == $W;
    push(@$FIELD, $line);
  }
  $self->{T} = $T;
  $self->{W} = $W;
  $self->{H} = $H;
  $self->{FIELD} = $FIELD;

  # 補完情報
  my $DOT_NUM = 0;
  my $ENEMIES = +[];
  my $PLAYER  = Pacman::Player->new('@');
  my $h = 1;
  for my $line (@$FIELD[$h..$#$FIELD-1]) {
    my $w = 1;
    for my $char (@$line[$w..$#$line-1]) {
      if ($char =~ /\./) {
        $DOT_NUM++;
      } elsif ($char =~ /@/) {
        $PLAYER->setPos($h, $w, '.');
      } elsif ($char =~ /^[VHLRJ]$/i) {
        my $enemy = Pacman::EnemyAdapter::adapter($char);
        $enemy->setPos($h, $w, '.');
        push(@$ENEMIES, $enemy);
      }
      $w++;
    }
    $h++;
  }
  $self->{DOT_NUM} = $DOT_NUM;
  $self->{ENEMIES} = $ENEMIES;
  $self->{PLAYER}  = $PLAYER;
}

sub remainDot {
  my $self = shift;
  return $self->{DOT_NUM};
}

sub route {
  my $self = shift;
  return $self->{PLAYER}->route();
}

sub nextT {
  my ($self, $way) = @_;
  # 自機
  my $pl_pos = $self->{PLAYER}->getPos();
  $self->{FIELD}->[$pl_pos->[0]]->[$pl_pos->[1]] = ' ';
  my ($res, $nph, $npw);
  if ($way) {
    ($res, $nph, $npw) = $self->{PLAYER}->auto_move($way, $self->{FIELD}, $self->{ENEMIES});
  } else {
    ($res, $nph, $npw) = $self->{PLAYER}->move($self->{FIELD}, $self->{ENEMIES}, $self);
  }

  # 敵機
  for my $enemy (@{$self->{ENEMIES}}) {
    my $pos = $enemy->getPos();
    my ($res, $neh, $new) = $enemy->move($self->{FIELD}, $pl_pos);
    # 接触
    if ($nph == $neh && $npw == $new) {
      return 0;
    }
    # すれ違い
    if ($pl_pos->[0] == $neh && $pl_pos->[1] == $new &&
      $nph == $pos->[0] && $npw == $pos->[1]) {
      return 0;
    }
    if ($self->{FIELD}->[$pos->[0]]->[$pos->[1]] =~ /^[A-Z]$/) {
      $self->{FIELD}->[$pos->[0]]->[$pos->[1]] = ' ';
    }
  }

  # ドットを食う
  if ($self->{FIELD}->[$nph]->[$npw] eq '.') {
    $self->{DOT_NUM}--;
  }
  $self->{FIELD}->[$nph]->[$npw] = '@';
  return 1;
}

sub display {
  my $self = shift;
  system("clear");
  my $h = 0;
H:for my $line (@{$self->{FIELD}}) {
    my $w = 0;
W:  for my $char (@$line) {
      if ($self->{PLAYER}->pos($h, $w)) {
        print $self->{PLAYER}->getIcon();
        $w++;
        next W;
      }
      for my $enemy (@{$self->{ENEMIES}}) {
        if ($enemy->pos($h, $w)) {
          print $enemy->getIcon();
          $w++;
          next W;
        }
      }
      print $char;
      $w++;
    }
    $h++;
    print "\n";
  }
  print "\n";
}

sub answer {
  my $self = shift;
#  print $_->[0],$_->[1],$_->[2] . "\n" for @{$self->route()};
  my $result = '';
  $result .= $_->[2] for @{$self->route()};
  return $result;
}

1;
