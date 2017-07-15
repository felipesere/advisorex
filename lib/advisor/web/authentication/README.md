# Authentication

The modules here deal with protecting endpoints by knowing who is accessing them.
The `Gatekeeper` is a plug that will look for certain cookies or redirect users back to the login. It can even enforce a `group_leads` only policy.

The `Password` is an interim solution to a single hashed password until we deide to go with GitHub or Google Auth


## Changes

When we move to a different auth provider we'll definitly do changes here.
