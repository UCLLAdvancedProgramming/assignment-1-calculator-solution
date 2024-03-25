//// This module defines the `calculate` and `main` functions (part 4 of the assignment).

import error.{type CalculatorError}
import tokenize.{tokenize}
import parse.{parse}
import evaluate.{evaluate}
import gleam/erlang.{get_line}
import gleam/int
import gleam/io.{println}
import gleam/result
import gleam/string

/// Takes a mathematical expression as a string, and returns the result of the calculation.
/// 
/// If any error occurs, the appropriate CalculatorError is returned.
pub fn calculate(input: String) -> Result(Int, CalculatorError) {
  use tokens <- result.try(tokenize(input))
  use ast <- result.try(parse(tokens))
  evaluate(ast)
}

/// The main function of the application.
/// 
/// This function prompts the user for a mathematical expression,
/// and then either outputs the result, or an error. It will
/// then prompt the user for another mathematical expression, etc.
/// 
/// If an input error occurs, or the user enters "q", then the
/// main function returns.
/// 
/// Example session:
/// 
/// ```console
/// > 5 + 4
/// Result: 9
/// > 2 / 0
/// Error: Divide by zero
/// > 2 -
/// Error: Parse error
/// > hi
/// Error: Unknown character: 'h'
/// > q
/// ```
pub fn main() {
  // Get a line, stop on error
  case get_line("> ") {
    Ok("q\n") | Error(_) -> Nil
    Ok(line) -> {
      let trimmed_line = string.trim(line)
      case calculate(trimmed_line) {
        Ok(result) -> println("Result: " <> int.to_string(result))
        Error(error) -> println("Error: " <> error.to_string(error))
      }
      // Loop
      main()
    }
  }
}
