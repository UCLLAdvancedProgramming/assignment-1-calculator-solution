# Part 4: Putting it all together

Now we've got all of the parts, we can finally build our calculator.

## 1. Implement the `calculate` function

First, we need to implement the `calculate` function in [`src/calculator.gleam`](../src/calculator.gleam).
This function should take our mathematical expression as a string, and return either `Ok` with the
integer result, or return the appropriate error.

The tests for the `calculate` function are defined in [`test/calculator_test.gleam`](../test/calculator_test.gleam). To only run
these tests, run:

```sh
gleam test calculator_test
```

To run all tests, run:

```sh
gleam test
```

## 2. Implement the `main` function

Finally, we need to implement our `main` function in [`src/calculator.gleam`](../src/calculator.gleam).
The `main` function should prompt the user for an expression, and then output the result,
or the appropriate error. Here's an example session:

```
> 5 + 4
Result: 9
> 2 / 0
Error: Divide by zero
> 2 -
Error: Parse error
> hi
Error: Unknown character: 'h'
> q
```

It should prompt the user with `> `, after which the user can enter their input. Then, it should
output either "Result: " followed by the result of the calculation, or "Error: " followed by a
human-readable description of the error (use the `to_string` defined in [`src/error.gleam`](../src/error.gleam)).

If an error occurs when reading input, or the user types in "q", the program should abort.

You may have noticed that the [`gleam/io` module](https://hexdocs.pm/gleam_stdlib/gleam/io.html)
does not have any functions for reading standard input. This is because there isn't always a
"standard input" to speak of (e.g. when Gleam code is compiled to JavaScript, targeting the web browser).
For user input, you can use the [`get_line` function](https://hexdocs.pm/gleam_erlang/gleam/erlang.html#get_line)
from the `gleam_erlang` package.

To execute the `main` function, run:

```sh
gleam run
```