# CoderNight 2016-11 Meetup Submission

## Goal

Produce a solution in Elixir that uses parallel processing to speed
execution.

## Approach

I first wrote and tested an implementation of a Levenshtein edit distance
algorithm patterned off of the "Iterative with two matrix rows" pseudocode
[described here](https://en.wikipedia.org/wiki/Levenshtein_distance).

Next, I wrote a module named Challenge that uses lightweight processes, instead
of a full OTP implementation, to process all of the search words in parallel.
Since CodeEval doesn't accept Elixir code, I was only able to test against the
four inputs and outputs that Harvey Chapman provided. My solution
matches those outputs. The maximum processing time was under 2 seconds for
input4 on my 2015 Macbook Pro, which is less than the CodeEval 10 second limit.

## To Run

Run unit tests via `mix test`.

Run the algorithm against the four input files via `iex -S mix` then
`TestInputs.run`.

The return value for each test is a tuple of the form `{ match, seconds, calculated_output, known_output }` where match is true or false based on whether the calculated output matches the known output.
