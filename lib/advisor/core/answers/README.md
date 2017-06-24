# Answers

Anything related to storing and finding answers.
Normally, one would look up the ansers to a given [advice](lib/advisor/core/advice/README.md) entity. This module can also look through an entire list of advice entities.

To store answers, provide a hash like:
```json
{
  "1": "Phrase of answer to question 1",
  "2" : "Phrase of answer to question 2",
  "id" : "the id of the advice entity"
}
```
Other params will be ignored.

## Changes

You'll likely need to changes here if the way answers are submitted change.
Another source of changes could be different ways to find and represent answers.
