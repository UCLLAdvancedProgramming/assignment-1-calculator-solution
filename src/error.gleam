//// This module defines the `CalculatorError` type and its `to_string` function, **do not modify this file**!

/// CalculatorError is the error type that is returned
/// whenever any step in the calculation process produces
/// an error.
pub type CalculatorError {
  /// The user tried to divide by 0, can be returned by `evaluate.evaluate`.
  DivideByZeroError
  /// The user entered an unknown character, can be returned by `tokenize.tokenize`.
  UnknownCharacterError(character: String)
  /// The user tried to enter an invalid expression, that could not be parsed.
  /// This can be returned by `parse.parse`.
  ParseError
}

/// Returns a string representation for the given error.
pub fn to_string(error: CalculatorError) -> String {
  case error {
    DivideByZeroError -> "Divide by zero"
    UnknownCharacterError(character) ->
      "Unknown character: '" <> character <> "'"
    ParseError -> "Parse error"
  }
}
