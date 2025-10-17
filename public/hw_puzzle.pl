#!/usr/bin/perl -w
# usage: ./hw_puzzle.pl > hw_puzzle.html
use strict;
my $img = `base64 hw_puzzle.jpg`;
$img =~ s/\s//g;

open(IN, "<", "hw_puzzle.html.in") or die "$!";
while(<IN>) {
  s/IMAGEHERE/$img/;
  print;
}
