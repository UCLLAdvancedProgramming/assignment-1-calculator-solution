//// This module defines the `Token` type, **do not modify this file**!

/// Represents a token
pub type Token {
  /// A number (greater than or equal to 0)
  Number(Int)
  /// Left parenthesis
  LParen
  /// Right parenthesis
  RParen
  /// A single space
  Space
  /// +, for addition
  Plus
  /// -, for subtraction
  Minus
  /// *, for multiplication
  Asterisk
  /// /, for division
  Slash
  /// -, for negation
  Neg
}
