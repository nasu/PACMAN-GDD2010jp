package Pacman::EnemyAdapter;
use base qw/Pacman::Character/;
use Pacman::Enemy;
use Pacman::EnemyV;
use Pacman::EnemyH;
use Pacman::EnemyL;
use Pacman::EnemyR;
use Pacman::EnemyJ;

sub adapter {
  my ($char) = @_;
  if ($char eq 'V') {
    return Pacman::EnemyV->new($char);
  } elsif ($char eq 'H') {
    return Pacman::EnemyH->new($char);
  } elsif ($char eq 'L') {
    return Pacman::EnemyL->new($char);
  } elsif ($char eq 'R') {
    return Pacman::EnemyR->new($char);
  } elsif ($char eq 'J') {
    return Pacman::EnemyJ->new($char);
  } else {
    return Pacman::Enemy->new($char);
  }
}

1;
