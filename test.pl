#!/usr/bin/perl
#

use strict;
use Data::Dumper;
use IPC::Open3;

die "Usage: $0 <prog> <test>\n" unless( @ARGV == 2 );

my( $prog, $testbase ) = @ARGV;
if( $prog eq 'pwauth' && ! -f $prog && -f "$prog.c" ) {
  system( 'make', 'clean' );
  system( 'make' );
}

die "$prog not found" unless( -f $prog );

die "$prog not executable" unless( -x $prog );

die "$testbase not found\n" unless( -d "tests/$testbase" );

my @tests = sort map{ s/\.args$//; $_ } glob( "tests/$testbase/*.args" );
die "No tests found for $testbase\n" unless( @tests );

my $hdr = sprintf "%-20s  %6s  %6s  %7s",
  'Test',
  'STDOUT',
  'STDERR',
  'Passed?';

print "$hdr\n";
print '-'x(length($hdr)) . "\n";

foreach my $test ( @tests ) {
  my @args;
  my $out;
  my $error;

  if( -f "$test.args" ) {
    open( IN, "$test.args" );
    @args = <IN>;
    chop @args;
    close( IN );
  }

  if( -f "$test.out" ) {
    open( IN, "$test.out" );
    local $/ = undef;
    $out = <IN>;
    close( IN );
  }

  if( -f "$test.error" ) {
    open( IN, "$test.error" );
    local $/ = undef;
    $error = <IN>;
    close( IN );
  }

#  print Dumper \@args, $out, $error;

  open( OUT1, '>.out' );
  open( OUT2, '>.error' );
  my $pid = open3( \*OUT, ">&OUT1", ">&OUT2", './' . $prog, @args );
  die "Error executing $prog: $@" unless( $pid );

  close( OUT );

  waitpid( $pid, 0 );
  close( OUT1 );
  close( OUT2 );

  open( IN, '.out' );
  local $/ = undef;
  my $results_out = <IN>;
  close( IN );
  unlink( '.out' );

  open( IN, '.error' );
  local $/ = undef;
  my $results_error = <IN>;
  close( IN );
  unlink( '.error' );

  printf "%-20s  %6s  %6s  %7s\n",
    $test,
    ( $out eq $results_out ) ? 'OK' : 'FAILED',
    ( $error eq $results_error ) ? 'OK' : 'FAILED',
    ( $out eq $results_out && $error eq $results_error ) ? 'OK' : 'FAILED';
}
