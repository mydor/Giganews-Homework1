#!/usr/bin/python

import crypt
import sys

db = {
  'users': [
  {
    'id': 1,
    'user': 'user1',
    'domain_id': 1,
    'password': 'testpw1',
    'hpw': 'a9cXlAGYp1YTg'
  },
  {
    'id': 2,
    'user': 'user2',
    'domain_id': 1,
    'password': 'testpw2',
    'hpw': 'E.cTWtAAuY4dg'
  }
  ],
  'domains': [
  {
    'id': 1,
    'domain': 'domain1.com'
  },
  {
    'id': 2,
    'domain': 'domain2.com'
  }
  ]
}

def usage():
    sys.stderr.write( sys.argv[0] + ' <username> <password>\n' )
    sys.exit(0)

def authUser( username, pw ):
    at = username.find( '@' )
    if at < 1:
      return 'Invalid user/password1 for ' + username

    user = username[:at]
    domain = username[at+1:]

    user_obj = getUser( user, domain )
    if user_obj is None:
      return 'Invalid user/password2 for ' + username

    if checkPassword( user_obj, pw ) != 1:
      return 'Invalid user/password3 for ' + username

    print 'Authentication successful for %s' % ( username )
    print 'User: %s\nDomain: %s\nUsername: %s' % ( user_obj['user'], user_obj['domain'], username )
    return None

def checkPassword( user, password ):
    if crypt.crypt( password, user['hpw'] ) == user['hpw']:
      return True

    return False

def isValidDomain( domain ):
    domain_obj = None

    for key in db['domains']:
      if domain == key.get('domain',None):
        domain_obj = key
        break
    
    return domain_obj

def getUser( user, domain ):
    dKey = isValidDomain( domain )

    if dKey is None:
      return None

    userid = None
    for key in db['users']:
      if user == key.get('user',None):
        userid = key
        break

    if userid is None:
      return None

    user_obj = dict(
      dKey.items() + userid.items()
    )

    return user_obj


if len(sys.argv) < 3:
    usage()

error = authUser( sys.argv[1], sys.argv[2] )
if error is not None:
    sys.stderr.write( error + '\n' )
    sys.exit(1)

sys.exit(0)
