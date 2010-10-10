#!/usr/bin/perl -w
use strict;
use lib "/home/game/users/nasu/pacman";
use Pacman;
use Pacman::Conf;

my $lv = defined $ARGV[0] ? $ARGV[0] : 1; 
my $pattern = defined $ARGV[1] ? $ARGV[1] : 0;
my $p = Pacman->new;
if ($pattern) {
  $p->init($Pacman::Conf::map->{$lv});
  for (split(//, $pattern)) {
    unless ($p->nextT($_)) {
      print "lose:" . $p->answer();
      last;
    }
    unless ($p->remainDot()) {
      print "win:" . $p->answer();
      last;
    }
  }
} else {
  $p->init($Pacman::Conf::map->{$lv});
  for (my $i=0, my $max=$p->{T}; $i <= $max; $i++) {
    print "You are lose.\n" and print "remain t:" . ($max - $i) . "\n" and last unless $p->nextT();
    print "remain t:" . ($max - $i) . "\n" and last unless $p->remainDot();
    print $p->answer() . "\n";
  }
  $p->display();
  print $p->answer() . "\n";
}

1;
