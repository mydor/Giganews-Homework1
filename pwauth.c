#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <crypt.h>

struct db_domain
{
  int id;
  char *domain;
  struct db_domain *next;
};

struct db_user
{
  int id;
  char *user;
  int domain_id;
  char *password;
  char *hpw;
  struct db_user *next;
};

struct user_obj
{
  struct db_domain *d_ref;
  struct db_user *u_ref;
};

struct db
{
  struct db_user *users;
  struct db_domain *domains;
} db;

int main( int, char ** );
void usage( char * );
int authUser( const char *, const char * );
struct user_obj *getUser( const char *, const char * );
int checkPassword( struct user_obj *, const char *);
struct db_domain *isValidDomain( const char *);
void init();

int main( int argc, char *argv[] )
{
  if( argc < 3 ) {
    usage( argv[0] );
    exit( 1 );
  }

  init();

  if( authUser( argv[1], argv[2] ) )
    exit( 0 );

  exit( 1 );
}

void init()
{
  static struct db_user user1 = {
    .id = 1,
    .user = "user1",
    .domain_id = 1,
    .password = "testpw1",
    .hpw = "a9cXlAGYp1YTg",
    .next = NULL
  };
  static struct db_user user2 = {
    .id = 2,
    .user = "user2",
    .domain_id = 1,
    .password = "testpw2",
    .hpw = "E.cTWtAAuY4dg",
    .next = NULL
  };
  user1.next = &user2;

  static struct db_domain domain1 = {
    .id = 1,
    .domain = "domain1.com",
    .next = NULL
  };
  static struct db_domain domain2 = {
    .id = 2,
    .domain = "domain2.com",
    .next = NULL
  };
  domain1.next = &domain2;

  db.domains = &domain1;
  db.users = &user1;
}

void usage( char *prog )
{
  printf( "%s <username> <password>\n", prog );
}

int authUser( const char *username, const char *pw ) {
  char *ptr = malloc( strlen( username ) + 1 );
  strcpy( ptr, username );

  char *at = index( ptr, '@' );
  if( !at ) {
    fprintf(stderr, "Invalid user/password1 for %s\n", username );
    return 0;
  }

  char *user = ptr;
  char *domain = at + 1;
  *at = '\0';
  
  struct user_obj *user_o = getUser( user, domain );
  if( ! user_o ) {
    fprintf(stderr, "Invalid user/password2 for %s\n", username );
    return 0;
  }

  if( ! checkPassword( user_o, pw ) ) {
    fprintf(stderr, "Invalid user/password3 for %s\n", username );
    return 0;
  }

  printf( "Authentication successful for %s\n", username );
  printf(
    "User: %s\nDomain: %s\nUsername: %s\n",
    user_o->u_ref->user,
    user_o->d_ref->domain,
    username
  );

  return 1;
}

struct user_obj *getUser( const char *user, const char *domain )
{
  struct db_domain *dKey = isValidDomain( domain );
  if(!dKey)
    return NULL;

  struct db_user *user_ref = NULL;
  struct db_user *user_idx = db.users;
  for( user_idx = db.users; ! user_ref && user_idx; user_idx = user_idx->next )
    if( ! strcmp( user, user_idx->user ) )
      user_ref = user_idx;

  if( ! user_ref )
    return NULL;

  struct user_obj *user_o = malloc( sizeof( struct user_obj ) );
  user_o->d_ref = dKey;
  user_o->u_ref = user_ref;

  return user_o;
}

struct db_domain *isValidDomain( const char *domain )
{
  struct db_domain *domain_idx = db.domains;
  struct db_domain *return_d = NULL;
  for( domain_idx = db.domains; ! return_d && domain_idx; domain_idx = domain_idx->next )
    if( !strcmp( domain, domain_idx->domain ) )
      return_d = domain_idx;

  if( return_d )
    return return_d;

  return NULL;
}

int checkPassword( struct user_obj *user, const char *password )
{
  char *hpw = (char *)crypt( password, user->u_ref->hpw );
  if( ! hpw ) {
    fprintf( stderr, "crypt failure\n" );
    return 0;
  }

  int result = strcmp( user->u_ref->hpw, hpw );

  if( ! result )
    return 1;

  return 0;
}

