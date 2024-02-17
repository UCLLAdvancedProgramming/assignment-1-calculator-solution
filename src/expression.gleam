//// This module defines the `Expression` type and the `operands` function, **do not modify this file**!

/// Represents a mathematical expression.
pub type Expression {
  /// Number represents a whole positive number (`0` or higher).
  Number(Int)
  /// Negation represents negation (`-`). It evaluates to the additive
  /// inverse of the inner expression.
  /// E.g. if the inner expression yields `4`, then the negation yields `-4`.
  Negation(Expression)
  /// Add represents a sum (`+`).
  Add(Expression, Expression)
  /// Subtract represents a subtraction (`-`).
  Subtract(Expression, Expression)
  /// Multiply represents a product (`*`).
  Multiply(Expression, Expression)
  /// Divide represents a division (`/`), rounded to the nearest integer.
  Divide(Expression, Expression)
}

/// Takes an expression and returns all of the operands of the expression
/// 
/// Examples:
/// - `operands(Add(Number(3), Number(4)))` returns `[Number(3), Number(4)]`
/// - `operands(Negation(Number(2)))` returns `[Number(2)]`
/// - `operands(Number(10))` returns `[]` (empty list)
pub fn operands(expression: Expression) -> List(Expression) {
  case expression {
    Number(_) -> []
    Negation(e) -> [e]
    Add(l, r) | Subtract(l, r) | Multiply(l, r) | Divide(l, r) -> [l, r]
  }
}
