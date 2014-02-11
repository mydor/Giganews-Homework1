Giganews-Homework1
==================

The evaluation assignment is available in C, Python or Perl.  The code is a simulated email authentication
system.  The program takes 2 args, the email address and a password.  There are two steps to this assignment.

  > The code is a simulated email authentication system
  > The program takes 2 args, he email address and a password

  1. Pick a language to work on and find it's corresponding file.
     The preference is C, then Python and then Perl.
     You only need to process one.
  2. Read and comprehend the code.
  3. Comment the code.
  4. Expand the code to accept any number of email address extensions (aliases), while maintaining authentication of the
     account itself.
     Email extensions are in the format of user+alias@domain.
     Document any changes made.
  5. Return the modified file to HR for review.
     Do not try and push changes back to git.
     Only submit changed file, not the entire repository.


The output template is as follows...

         |   Before modification                |           After modification
-------  |  -------------------                     |      ------------------
FAILURE  |  Invalid user/password1 or                    |  Invalid user/password1 or
         |  Invalid user/password2 or                    |  Invalid user/password2 or
         |  Invalid user/password3                       |  Invalid user/password3
         | |
SUCCESS  |  Authentication successful for <username>     |  Authentication successful for <username>
         |  User: ```<user>```                                 |  User: ```<user>```
         |  Domain: ```<domain>```                             |  Domain: ```<domain>```
         |  Username: ```<username>```                         |  Alias: ```<alias>```
         |                                               |  Username: ```<username>```
        | |
NOTES    |  ```<username>``` will include the alias since the  |  ```<username>``` should not include the alias, as
         |  code doesn't know about aliases              |  it's not actually part of the username

Test data is as follows...

User | password
---- | --------
user1@domain1.com | testpw1
user1@domain1.com | badpw
user2@domain1.com | testpw2
user2@domain1.com | badpw
unknown@domain2.com | something
user1+alias1@domain1.com | testpw1
user1+alias2@domain1.com | testpw1
