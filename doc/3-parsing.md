# Part 3: Parsing

## Context

We can now evaluate our AST ([part 1](../doc/1-evaluating.md)),
and we can turn a string into a list of tokens ([part 2](../doc/2-tokenization.md)).

The only thing missing is the parsing step, so that we can turn our list of tokens into an AST.

Parsing mathematical expressions can be a little bit tricky, since operators have different **precedence**.
Multiplication should be evaluated before addition, e.g. `3 + 2 * 4` should yield `11` (`3 + 8`), not `20` (`5 * 4`).

Also, operations like **subtraction or division are left-associative**. This means that `3 - 2 - 1` should
be interpreted as `(3 - 2) - 1`, and yield `0`, not `2`, which we would get if we incorrectly interpreted it as `3 - (2 - 1)`.
Similarly, `8 / 4 / 2` should yield `1` (`(8 / 4) / 2` = `2 / 2` = `1`), not `4` (`8 / (4 / 2)` = `8 / 2` = `4`).

On the other hand, negation is **right-associative**. This means that `-- 1` should be interpreted as 
`- (- 1)`, not as `(- -) 1`, which just doesn't make sense.

We can make all of this work in three steps:

1. First, distinguish between subtraction (`a - b`) and negation (`- c`), since they should not be treated the same by our parser.
2. Use Edsger Dijkstra's [shunting yard algorithm](https://en.wikipedia.org/wiki/Shunting_yard_algorithm) to turn our list of tokens
   into [reverse Polish notation](https://en.wikipedia.org/wiki/Reverse_Polish_notation) (RPN). This will take care of our precedence
   and associativity rules.
3. Turn the RPN into an AST.

## Implementation

The implementation of the parser involves implementing all of the different steps, and then putting them all together.

### 1. Distinguish between subtraction and negation

Our tokenization step turned `- 3 - 2` into `[Minus, 3, Minus, 2]`. We now want to turn every `Minus` into
`Neg` if it's a negation, but keep it a `Minus` if it's a subtraction.

You'll need to implement the `identify_negations` function in [`src/parse.gleam`](../src/parse.gleam).

Hint: consider what comes **before** the `-` in each of these cases:

- `- 2` (should be `[Neg, Number(2)]`)
- `1 - 2` (should be `[Number(1), Minus, Number(2)]`)
- `(1 + 2) - 8` (should be `[LParen, Number(1), Plus, Number(2), RParen, Minus, Number(8)]`)
- `3 * -4` (should be `[Number(3), Asterisk, Neg, Number(4)]`)
- `- - 3` (should be `[Neg, Neg, Number(3)]`)

### 2. Implement helper functions for the shunting yard algorithm

I'll give you an implementation of the shunting yard algorithm, so you won't need to write it
yourself. However, it is not fully functional yet. To make it all work, we should implement
some helper functions.

The shunting yard algorithm needs to compare the precedence of different operators, and
whether they are left-associative or right-associative in order to make the right decisions.

Let's write two helper functions for this: the `compare_precedence` function compares the precedence
of two different operators, and the `associativity` function should return `Left` if the operator is
left-associative, or `Right` if the operator is right-associative.

#### The `compare_precedence` function

The `compare_precedence` function takes two operators (represented as `Token`s), and returns
`Some(Gt)` if the first argument has precedence over the second argument, `Some(Lt)` if the
second argument has precedence over the first argument, or `Some(Eq)` if they have the same
precedence.

Negation (`Neg`) has precedence over multiplication (`Asterisk`) and division (`Slash`),
multiplication and division have precedence over addition (`Plus`) and subtraction (`Minus`).

If one of the inputs is not an operator (`Neg`, `Plus`, `Minus`, `Asterisk`, or `Slash`), then
`None` is returned.

Examples:

```gleam
compare_precedence(Plus, Minus) // Returns `Some(Eq)`
compare_precedence(Plus, Asterisk) // Returns `Some(Lt)`
compare_precedence(Neg, Minus) // Returns `Some(Gt)`
compare_precedence(LParen, Minus) // Returns `None`, since `LParen` is not an operator
```

Hint: you could put all of the operators into their own "precedence class", and assign an
integer value to each.

#### The `associativity` function

The `associativity` function takes an operator (represented as a `Token`), and returns
`Some(Left)` if the operator is left-associative, and `Some(Right)` if the operator is right-associative.

Addition (`Plus`), subtraction (`Minus`), multiplication (`Asterisk`), and division (`Slash`)
are all left-associative operators, negation (`Neg`) is right-associative.

If one of the inputs is not an operator (`Neg`, `Plus`, `Minus`, `Asterisk`, or `Slash`), then
`None` is returned.

Examples:

- `associativity(Neg)` returns `Some(Right)`
- `associativity(Plus)` returns `Some(Left)`
- `associativity(LParen)` returns `None`

### 3. Turn the RPN into an AST

The shunting yard algorithm should now have turned our tokens into reverse Polish notation. The
last step is to take this notation, and turn it into an AST, so that we can evaluate it.

In reverse Polish notation we put the numbers first (in reverse), and the operator last, so we write
`1 - 2` as `1 2 -`.

Some examples of reverse Polish notation

- `1 - 2 - 3` becomes `1 2 - 3 -`
- `1 - (2 - 3)` becomes `1 2 3 - -`
- `1 + 2 * 3` becomes `1 2 3 * +`
- `(1 + 2) * 3` becomes `1 2 + 3 *`

We can evaluate RPN by repeatedly looking for the first operator and applying it to the two numbers that come
before it, for example:

1. If the input is `1 2 3 * +`, then the first operator is `*` and `2` and `3` come directly before it, so we
   calculate `2 * 3` and our expression becomes: `1 6 +`.
2. Now the first operator is `+`, and `1` and `6` come directly before it, so we can calculate
   `1 + 6` and our expression becomes: `7`
3. Now that we're left with just the number 7, we're done.

In RPN, we're only left with numbers and operators and we don't need to care about associativity and precedence anymore,
since the shunting yard algorithm took care of that.

Rather than evaluating the RPN by reducing it to just a number, though, I'd like you to reduce it into a single `Expression`. We can do that in a very similar way. We can use two lists for this: one "before" list that starts out empty, containing all of the parts of our expression so far, and another "after" list containing all of the tokens that we have not processed yet.

1. If the token list is `[token.Number(1), token.Number(2), token.Number(3), Asterisk, Plus]`, then we can take all of the numbers
   and turn them into expressions, turning our "before" list into `[expression.Number(3), expression.Number(2), expression.Number(1)]`.
   Note that we keep the expressions in reverse order: the first item is the previous number we visited, the second one is the number
   we visited before that, etc. Our "after" list when we encounter our first token is now just `[Asterisk, Plus]`.
2. Our token is an `Asterisk`, so we take the first two items from our "before" list, and combine them with a `Multiply` expression, so it
   becomes: `[Multiply(expression.Number(2), expression.Number(3)), expression.Number(1)]`, and now our "after" list is just `[Plus]`.
3. Our token is a `Plus`, so we take the first two items from our "before" list, and combine them with an `Add` expression, so it
   becomes: `[Add(expression.Number(1), Multiply(expression.Number(2), expression.Number(3)))]`. Our "after" list is now empty (`[]`).
4. We're now left with a "before" list with one item in it, and an empty "after" list, so we can return `Ok` with the single expression
   that's in the "before" list.

If our RPN does not properly reduce into a single expression, then we should return `Error(ParseError)`.

Examples:

- `parse_rpn([], [Number(2), Neg])` returns `Ok(Negation(Number(2)))`
- `parse_rpn([], [Number(1), Number(2), Minus])` returns `Ok(Subtract(Number(1), Number(2)))`
- `parse_rpn([], [Number(1), Plus])` returns `Error(ParseError)` (`Add` needs two expressions, but we only have one number)
- `parse_rpn([], [Number(1), Number(2)])` returns `Error(ParseError)` (we can't reduce this into a single expression)

### 4. Put all of these steps together into a single `parse` function

Our parse function should now do all of these steps in order:

1. `identify_negations`
2. `shunting_yard`
3. `parse_rpn`

## Testing

The tests are defined in [`test/parse_test.gleam`](../test/parse_test.gleam). To only run
these tests, run:

```sh
gleam test parse_test
```

To run all tests, run:

```sh
gleam test
```