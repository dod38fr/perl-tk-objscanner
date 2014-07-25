# -*- cperl -*-

use warnings FATAL => qw(all);
use ExtUtils::testlib;
use Test::More tests => 1 ;

use Tk ;
use Tk::ObjScanner ;
my $trace = shift || 0 ;

my $data = { foo => 'bar', bar => 'baz' } ;
my $animate = $trace ? 0 : 1 ;

Tk::ObjScanner::scan_object($data,$animate) ;
ok(1) ;
