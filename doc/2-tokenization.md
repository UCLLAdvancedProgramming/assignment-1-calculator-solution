# Part 2: Tokenization

## Context

Parsing usually happens in two stages: first, there's the [lexical analysis](https://en.wikipedia.org/wiki/Lexical_analysis).
This turns the string into a list of tokens, hence it also being called tokenization.
These tokens are then later fed into the parser, which we will do in part 3.

[`src/token.gleam`](../src/token.gleam) contains the token type we'll be using. For example, we
want to turn the following string:

```
(11 + 2) * 3
```

Into:

```gleam
[LParen, Number(11), Plus, Number(2), RParen, Asterisk, Number(3)]
```

## Implementation

We'll implement the lexical analysis with the `tokenize` function, defined in
[`src/tokenize.gleam`](../src/tokenize.gleam). This function takes a string, and either returns `Ok` with
a list of tokens, or `Error(UnknownCharacterError)`, with the character that we failed
to tokenize.

Adjacent digits should be turned into a single number, e.g. `12` should become the token `Number(12)`,
not two tokens `[Number(1), Number(2)]`. Spaces should be discarded. Note however, that `1 2` should
still be interpreted as two separate tokens, i.e. `[Number(1), Number(2)]`.

Leading zeroes should be ignored, so `01` should become `Number(1)`.

If doing all of this in one go proves too difficult,
one possible approach could be to process the input character per character
(or rather, grapheme per grapheme, see the
[`to_graphemes`](https://hexdocs.pm/gleam_stdlib/gleam/string.html#to_graphemes) function),
and then do some extra steps to remove spaces (hence the inclusion of the `Space` token), and
to collapse adjacent `Number`s into a single `Number`.

Hint: the [list.try_map](https://hexdocs.pm/gleam_stdlib/gleam/list.html#try_map) function may also be of use.

Examples:

- `tokenize("")` returns `Ok([])`
- `tokenize("12")` returns `Ok([Number(12)])`
- `tokenize("hello")` returns `Error(UnknownCharacterError("h"))`
- `tokenize("1 2")` returns `Ok([Number(1), Number(2)])`
- `tokenize("1 + 2 * 3")` returns `Ok([Number(1), Plus, Number(2), Asterisk, Number(3)])`
- `tokenize("-2 - 3")` returns `Ok([Minus, Number(2), Minus, Number(3)])`

You can ignore the `Neg` token for now. We'll be using that in the next part of the assignment.

## Testing

The tests are defined in [`test/tokenize_test.gleam`](../test/tokenize_test.gleam). To only run
these tests, run:

```sh
gleam test tokenize_test
```

To run all tests, run:

```sh
gleam test
```