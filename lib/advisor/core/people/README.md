# People

All this module does is find people by different attributes.
There is a single structure representing any person, but there is one flag that
distinguishes `mentors` from other people.

You can search for people by `id`, `name`, or `email`, but also the role, such as `mentor/` or `mentee`.

* Mentor: Person tasked with facilitating the creation of a [questionnaire](lib/advisor/core/questionnaire/README.md) with the mentee.
* Mentee: The person that requested the advice from other people.
* Advisor: A person tasked with giving good [advice](lib/advisor/core/advice/README.md) to someone.


## Changes

Change this module if you need to find people by other criteria.
