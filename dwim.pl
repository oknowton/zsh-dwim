#! /usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

print mangler($ARGV[0]);


sub mangler {
  $_=shift;

  if (/^apt-cache (search|show)/ ) {
    s/^apt-cache (search|show)/sudo apt-get install/;
    return $_;
  }

  if (/^scp .+:/) {
    s/^scp /mv /;
    s/ [A-Za-z0-9@\-]+:.*//;
    return $_;
  }

  if (/^tar (ft|tf)/) {
    s/^tar (ft|tf)/tar fx/;
    return $_;
  }

  if (/^ls ?/) {
    if (/^ls (-[A-Za-z0-9]+)/) {
      if ($1 eq '-s') {
        s/^ls -s/ls -str/;
      } elsif ($1 eq '-str') {
        s/^ls -str/ls -l/;
      } elsif ($1 eq '-l') {
        s/^ls -l/ls -ltr/;
      } elsif ($1 eq '-ltr') {
        s/^ls -ltr/ls/;
      }
    } else {
      s/^ls/ls -s/;
    }

    return $_;
  }

  if (/^ssh /) {
    if (/^ssh .*[\w\d]+@([\w\d.]+).*/) {
      $_="ssh-keygen -R $1";
    } else {
      s/^ssh /ssh-keygen -R /;
    }

    return $_;
  }

  if (/^wine /) {
    s/^wine /WINEDEBUG="-all" wine /;
    return $_;
  }

  if (/^sudo (service |\/etc\/init.d\/)[a-zA-Z0-9]+ stop/) {
    s/stop/start/;
    return $_;
  }

  if (/^sudo (service |\/etc\/init.d\/)[a-zA-Z0-9]+ start/) {
    s/start/stop/;
    return $_;
  }

  if (/^mkdir /) {
    s/^mkdir /cd /;
    return $_;
  }

  if (/^sudo /) {
    s/^sudo //;
    return $_;
  }

  return "sudo $_";
}
