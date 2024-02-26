# Assignment 1: Calculator

In this assignment you will be implementing a simple calculator using Gleam,
a functional programming language. You will have to implement different parts,
and then string them together to make a fully functioning calculator with support
for:

- integers (`...,-2,-1,0,1,2,...`)
- parentheses (`(` and `)`)
- negation, e.g. `-(3 * 4) = -12`
- addition, e.g. `2 + 4 = 6`
- subtraction, e.g. `2 - 4 = -2`
- multiplication, e.g. `2 * 4 = 8`
- division, e.g. `4 / 2 = 2`
  - an error should be returned when divide by zero is performed
  - results should be rounded to the nearest integer, e.g.
    `4 / 3 = 1` and `5 / 3 = 2`. `.5` is rounded up for positive numbers,
    and down for negative numbers (i.e. away from `0`), e.g.
    `3 / 2 = 2` and `-3 / 2 = -2`.

The assignment is split up into 4 parts:

- [Part 1: Evaluating](doc/1-evaluating.md)
- [Part 2: Tokenization](doc/2-tokenization.md)
- [Part 3: Parsing](doc/3-parsing.md)
- [Part 4: All together](doc/4-all-together.md)

The first 3 parts are all tested independent of each other. To run the entire test suite, use:

```console
gleam test
```

## Rules

- You may not depend on any more libraries than the ones that are already included. Your
  code should only use the
  [Gleam standard library](https://hexdocs.pm/gleam_stdlib/) and
  [Gleam Erlang](https://hexdocs.pm/gleam_erlang/).
- You may not use AI to generate code for you, but you can use it as a guide.
- Do not share your code with other students. You can help your fellow students,
  but your code should be your own!

## Installing Gleam on your computer

### Windows

The easiest way to install Gleam on Windows is to use [Scoop](https://scoop.sh/). You
can then use `scoop install gleam` to install Gleam.

### macOS

To install gleam on macOS, you can use [Homebrew](https://brew.sh/). You can then
use `brew install gleam` to install Gleam.

### Linux, etc.

You can find instructions on the [Installing Gleam](https://gleam.run/getting-started/installing/#installing-gleam)
page.

### Dev container

If you have a Docker daemon installed and running and dev container support enabled in Visual Studio code,
you can also develop inside of a dev container.

## IDE support

There is a Gleam extension for Visual Studio Code available. This project is set up
so that Visual Studio Code automatically recommends the installation of that extension.

## Documentation

You can view the generated documentation for all of the modules with:

```
gleam docs build --open
```

## Submitting the assignment

In order to submit your assignment, make a release (see Releases on the right), and tag it as `submission` with title "Submission".

Then, copy the commit hash (on the command line, you can use `git rev-parse HEAD`), and submit it on Toledo.
