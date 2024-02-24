//// This module defines the `tokenize` function (part 2 of the assignment).

import error.{type CalculatorError, UnknownCharacterError}
import token.{type Token}
import gleam/int
import gleam/list
import gleam/result
import gleam/string

/// Takes the input string, and turns it into a list of tokens.
/// 
/// If an unrecognized character is encountered, `Error(UnknownCharacterError)` is returned.
pub fn tokenize(input: String) -> Result(List(Token), CalculatorError) {
  use tokens <- result.map(
    input
    |> string.to_graphemes
    |> list.try_map(tokenize_grapheme),
  )
  tokens
  |> join_numbers
  |> remove_spaces
}

fn tokenize_grapheme(input: String) -> Result(Token, CalculatorError) {
  case input {
    "(" -> Ok(token.LParen)
    ")" -> Ok(token.RParen)
    "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" -> {
      let assert Ok(i) = int.parse(input)
      Ok(token.Number(i))
    }
    " " -> Ok(token.Space)
    "+" -> Ok(token.Plus)
    "-" -> Ok(token.Minus)
    "*" -> Ok(token.Asterisk)
    "/" -> Ok(token.Slash)
    _ -> Error(UnknownCharacterError(input))
  }
}

fn join_numbers(tokens: List(Token)) -> List(Token) {
  case tokens {
    [] -> []
    [token.Number(i), token.Number(j), ..tail] -> {
      join_numbers([token.Number(i * 10 + j), ..tail])
    }
    [head, ..tail] -> {
      [head, ..join_numbers(tail)]
    }
  }
}

fn remove_spaces(tokens: List(Token)) -> List(Token) {
  case tokens {
    [] -> []
    [token.Space, ..tail] -> remove_spaces(tail)
    [head, ..tail] -> [head, ..remove_spaces(tail)]
  }
}
