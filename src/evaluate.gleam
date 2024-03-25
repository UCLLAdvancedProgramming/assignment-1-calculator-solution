//// This module defines the `evaluate` function (part 1 of the assignment).

import expression.{
  type Expression, Add, Divide, Multiply, Negation, Number, Subtract, operands,
}
import error.{type CalculatorError, DivideByZeroError}
import gleam/float
import gleam/int
import gleam/list
import gleam/result

/// Evaluates the given expression, either returns an integer or an error
pub fn evaluate(expression: Expression) -> Result(Int, CalculatorError) {
  use evaluated_operands <- result.try(
    operands(expression)
    |> list.try_map(evaluate),
  )
  case expression, evaluated_operands {
    Add(_, _), [l, r] -> Ok(l + r)
    Subtract(_, _), [l, r] -> Ok(l - r)
    Multiply(_, _), [l, r] -> Ok(l * r)
    Divide(_, _), [l, r] -> safe_divide(l, r)
    Negation(_), [i] -> Ok(-i)
    Number(i), [] -> Ok(i)
    _, _ -> panic as "Unhandled case"
  }
}

fn safe_divide(l: Int, r: Int) -> Result(Int, CalculatorError) {
  case r {
    0 -> Error(DivideByZeroError)
    _ -> Ok(float.round(int.to_float(l) /. int.to_float(r)))
  }
}
