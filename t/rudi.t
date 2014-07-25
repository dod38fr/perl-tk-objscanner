# -*- cperl -*-

use warnings FATAL => qw(all);
###
### variant of test.pl for Tk:ObjScanner, with additional test cases
### by R Farkas rudif@lecroy.com 27 Jun 1999
###

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..4\n"; }
END {print "not ok 1\n" unless $loaded;}

use Tk ;
use ExtUtils::testlib ;
use Tk::ObjScanner ;

$loaded = 1;
my $idx = 1;
print "ok ",$idx++,"\n";
my $trace = shift || 0 ;

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

use strict ;

package toto ;

use FileHandle;
use Benchmark;
use Math::BigInt;

sub new
  {
     my $type = shift;
     # add recursive data only if interactive test
     my $tkstuff = $trace ? shift : "may be another time ..." ;

     my $scl = 'my scalar var';

    my $self = { 'scalar: key1'    => 'value1',
                 'ref array:'            => [qw/a b sdf/, {'v1' => '1', 'v2' =>
2},'dfg'],
                 'ref hash: key2'  => {
                                         'sub key1' => 'sv1',
                                         'sub key2' => 'sv2'
                                              },
                 'ref hash: piped|key'   => {a => 1 , b => 2},
                 'scalar: long'          => 'very long line'.'.' x 80 ,
                 'scalar: is undef'      => undef,
                 'scalar: some text'     => "some \n dummy\n Text\n",
                 'ref blessed hash: tk widget' => $tkstuff,

                    'ref const'          => \12345,
                    'ref scalar'         => \$scl,
                    'ref ref tk widget'  => \$tkstuff,            # ref to ref (assumes $tkstuff is a ref)
                    'ref code'                => sub { my $x = shift; sin($x) +
cos(2*$x) },
                    'ref blessed glob'   => new FileHandle,
                    'ref blessed array' => new Benchmark,
                    'ref blessed scalar' => new Math::BigInt '123 456 789 123
456 789',

             } ;

    bless $self,$type;
  }

package main;

my $toto ;
my $mw = MainWindow-> new ;
$mw->geometry('+10+10');

my $w_menu = $mw->Frame(-relief => 'raised', -borderwidth => 2);
$w_menu->pack(-fill => 'x');

my $f = $w_menu->Menubutton(-text => 'File', -underline => 0)
  -> pack(-side => 'left' );
$f->command(-label => 'Quit',  -command => sub{$mw->destroy;} );

print "creating dummy object \n" if $trace ;

my $dummy = new toto ($mw);

print "ok ",$idx++,"\n";

print "Creating obj scanner\n" if $trace ;
my $s = $mw -> ObjScanner
  (
   'caller' => $dummy,
   title => 'test scanner'
  );
$s  -> pack(-expand => 1, -fill => 'both') ;

print "ok ",$idx++,"\n";

$mw->idletasks;

sub scan
  {
    my $topName = shift ;
    $s->yview($topName) ;
    $mw->after(200); # sleep 300ms

    foreach my $c ($s->infoChildren($topName))
      {
        $s->displaySubItem($c);
        scan($c);
      }
    $mw->idletasks;
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

