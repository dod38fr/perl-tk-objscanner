# -*- cperl -*-
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; 
	print "1..", $] >= 5.009 ? '1' : '4' ,"\n"; }
END {print "not ok 1\n" unless $loaded;}
use Tk ;
use ExtUtils::testlib ; 
use Tk::ObjScanner ;
use warnings ;
$loaded = 1;
my $idx = 1;
print "ok ",$idx++,"\n";
my $trace = shift || 0 ;

######################### End of black magic.

exit if $] >= 5.009 ;

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

# define a class using pseudo hashes
package Bla;

use fields qw(a b c);

sub new {
    my $class = shift;
    no strict 'refs';
    my $self = bless [\%{"$class\::FIELDS"}], $class;
    $self;
}

sub new2 {
    my $class = shift;
    bless {}, $class;
}

package main;

use strict ;
print "ok ",$idx++,"\n";

my $top=tkinit;
$top->geometry('+10+10');

my $x = [{}, 1, 2, 3]; # not a pseudo hash
my $y = [{a => 3}, 3, 4, 2, 3, 4]; # not a pseudo hash
my $y3 = [{a => 1, c => 3}, 3, 4]; # not a pseudo hash # check not correct
my $y2 = [{a => 1, b => 2}, 3, 4]; # a possible pseudo hash
my $z = [{a => "bcd"}, 3, 4, 2, 3, 4]; # also not a pseudo hash
my $o = new Bla; # a pseudo hash
$o->{a} = "a";
$o->{b} = ["b", "d", $y2, $x, $y, $y3, $z];
my $b2 = $o->{c} =  new Bla;
$b2->{a} = "a2";
$b2->{b} = "b23";


my $s = $top->ObjScanner(caller => $o , -view_pseudo => 1);
$s->pack;

print "ok ",$idx++,"\n";

$top->idletasks;

sub scan
  {
    my $topName = shift ;
    $s->yview($topName) ;
    $top->after(200); # sleep 300ms

    foreach my $c ($s->infoChildren($topName))
      {
        $s->displaySubItem($c);
        scan($c);
      }
    $top->idletasks;
  }

if ($trace)
  {
    MainLoop ; # Tk's
  }
else
  {
    scan('root');
  }

print "ok ",$idx++,"\n";

