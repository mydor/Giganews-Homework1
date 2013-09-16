#!/usr/bin/perl
#

use strict;
use Data::Dumper;

my %db = (
  'domains' => {
    '1' => { 'domain' => 'domain1.com' },
    '2' => { 'domain' => 'domain2.com' }
  },
  'users' => {
    '1' => {
      'user' => 'user1',
      'domain' => 1,
      'password' => 'testpw1',
      'hpw' => 'a9cXlAGYp1YTg'
    },
    '2' => {
      'user' => 'user2',
      'domain' => 1,
      'password' => 'testpw2',
      'hpw' => 'E.cTWtAAuY4dg'
    }
  }
);

usage() if( @ARGV < 2 );

my( $user, $passwd ) = @ARGV;

authUser( $user, $passwd );

exit 0;

sub usage {
  print STDERR "$0 <username> <password>\n";
  exit 1;
}

sub authUser {
  my( $username, $pw ) = @_;

  my $at = index( $username, '@' );
  die "Invalid user/password1 for $username\n" if( $at < 0 || $at > length( $username ) );

  my $user = substr( $username, 0, $at );
  my $domain = substr( $username, $at + 1 );

  my $user_obj = getUser( $user, $domain );
  die "Invalid user/password2 for $username\n" unless( $user_obj );

  die "Invalid user/password3 for $username\n" unless( checkPassword( $user_obj, $pw ) );

  print "Authentication successful for $username\n";
  printf "User: %s\nDomain: %s\nUsername: %s\n",
    $user_obj->{'user'},
    $user_obj->{'domain'},
    $username;
}

sub checkPassword {
  my( $user, $password ) = @_;

  return 1 if( crypt( $password, $user->{'hpw'} ) eq $user->{'hpw'} );
  return 0;
}

sub isValidDomain {
  my( $domain ) = @_;

  foreach my $domain_key ( keys %{$db{'domains'}} ) {
    return $domain_key if( $db{'domains'}{$domain_key}{'domain'} eq $domain );
  }

  return undef;
}

sub getUser {
  my( $user, $domain ) = @_;

  my $dKey = isValidDomain( $domain );
  return undef unless( $dKey );

  my $userid = undef;
  foreach my $user_key ( keys %{$db{'users'}} ) {
    next unless( $db{'users'}{$user_key}{'user'} eq $user );

    $userid = $user_key;
    last;
  }

  return undef unless( defined $userid );

  my %user_obj = (
    %{$db{'users'}{$userid}},
    %{$db{'domains'}{$db{'users'}{$userid}{'domain'}}}
  );
  return \%user_obj;
}
