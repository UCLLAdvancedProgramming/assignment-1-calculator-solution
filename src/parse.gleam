//// This module defines the `parse` function (part 3 of the assignment), along with its helper functions:
//// 
//// - `identify_negations`, to be implemented
//// - `compare_precedence`, to be implemented
//// - `associativity`, to be implemented
//// - `parse_rpn`, to be implemented
//// - `shunting_yard`, implementation provided, **do not change**!

import associativity.{type Associativity, Right}
import error.{type CalculatorError, ParseError}
import expression.{type Expression}
import token.{type Token}
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/order.{type Order, Eq, Gt}
import gleam/result

/// Parse the given list of tokens into an expression.
/// 
/// If parsing fails, then `Error(ParseError)` is returned.
pub fn parse(tokens: List(Token)) -> Result(Expression, CalculatorError) {
  use rpn <- result.try(
    tokens
    |> identify_negations
    |> shunting_yard,
  )
  parse_rpn([], rpn)
}

/// Returns the input, with all occurrences of Minus replaced by Neg
/// when the `-` represents negation (rather than subtraction).
/// 
/// Examples:
/// - `[Minus, Number(4)]` becomes `[Neg, Number(4)]`
/// - `[Number(1), Minus, Number(2)]` stays the same
/// - `[Minus, Number(1), Minus, Number(2)]` becomes `[Neg, Number(1), Minus, Number(2)]`
pub fn identify_negations(input: List(Token)) -> List(Token) {
  do_identify_negations(input, None)
}

fn do_identify_negations(
  input: List(Token),
  previous: Option(Token),
) -> List(Token) {
  case previous, input {
    None, [token.Minus, ..tail] -> [
      token.Neg,
      ..do_identify_negations(tail, Some(token.Neg))
    ]
    Some(operator), [token.Minus, ..tail] -> {
      case is_operator(operator) {
        True -> [token.Neg, ..do_identify_negations(tail, Some(token.Neg))]
        False -> [token.Minus, ..do_identify_negations(tail, Some(token.Minus))]
      }
    }
    None, [head, ..tail] -> [head, ..do_identify_negations(tail, Some(head))]
    Some(_), [head, ..tail] -> [head, ..do_identify_negations(tail, Some(head))]
    _, [] -> []
  }
}

fn is_operator(token: Token) -> Bool {
  case token {
    token.Plus -> True
    token.Minus -> True
    token.Asterisk -> True
    token.Slash -> True
    token.Neg -> True
    _ -> False
  }
}

/// Returns the associativity of the given operator
/// 
/// Returns Some(Left) if the argument is left-associative
/// Returns Some(Right) if the argument is right-associative
/// Returns None if the argument is not an operator
pub fn associativity(token: Token) -> Option(Associativity) {
  case token {
    token.Plus -> Some(associativity.Left)
    token.Minus -> Some(associativity.Left)
    token.Asterisk -> Some(associativity.Left)
    token.Slash -> Some(associativity.Left)
    token.Neg -> Some(associativity.Right)
    _ -> None
  }
}

/// Compares the precedence of the given two operators
/// 
/// Returns Some(Gt) if the first argument has higher precedence
/// Returns Some(Lt) if the second argument has higher precedence
/// Returns Some(Eq) if both arguments have higher precedence
/// Returns None if one of the arguments is not an operator
pub fn compare_precedence(left: Token, right: Token) -> Option(Order) {
  case precedence(left), precedence(right) {
    Some(l), Some(r) -> Some(int.compare(l, r))
    _, _ -> None
  }
}

fn precedence(token: Token) -> Option(Int) {
  case token {
    token.Plus | token.Minus -> Some(1)
    token.Asterisk | token.Slash -> Some(2)
    token.Neg -> Some(3)
    _ -> None
  }
}

/// Parse reverse Polish notation.
/// 
/// `before` is a list of expressions that come before the current position.
/// `after` is a list of tokens that come after the current position.
pub fn parse_rpn(
  before: List(Expression),
  after: List(Token),
) -> Result(Expression, CalculatorError) {
  case before, after {
    [e], [] -> Ok(e)
    _, [token.Number(i), ..new_after] ->
      parse_rpn([expression.Number(i), ..before], new_after)
    [r, l, ..new_before], [token.Plus, ..new_after] ->
      parse_rpn([expression.Add(l, r), ..new_before], new_after)
    [r, l, ..new_before], [token.Minus, ..new_after] ->
      parse_rpn([expression.Subtract(l, r), ..new_before], new_after)
    [r, l, ..new_before], [token.Asterisk, ..new_after] ->
      parse_rpn([expression.Multiply(l, r), ..new_before], new_after)
    [r, l, ..new_before], [token.Slash, ..new_after] ->
      parse_rpn([expression.Divide(l, r), ..new_before], new_after)
    [e, ..new_before], [token.Neg, ..new_after] ->
      parse_rpn([expression.Negation(e), ..new_before], new_after)
    _, _ -> Error(ParseError)
  }
}

/// Perform the shunting yard algorithm
/// 
/// Takes a list of tokens and returns this list of tokens in reverse Polish notation (RPN).
/// If an error occurs, `Error(ParseError)` is returned.
/// 
/// **Do not change this code!**
pub fn shunting_yard(
  tokens: List(Token),
) -> Result(List(Token), CalculatorError) {
  do_shunting_yard(tokens, [], [])
}

fn do_shunting_yard(
  tokens: List(Token),
  operand_stack: List(Token),
  operator_stack: List(Token),
) -> Result(List(Token), CalculatorError) {
  case tokens {
    [] -> {
      case operator_stack {
        [] -> Ok(list.reverse(operand_stack))
        [operator, ..tail] ->
          do_shunting_yard([], [operator, ..operand_stack], tail)
      }
    }
    [token.Number(i), ..tail] ->
      do_shunting_yard(tail, [token.Number(i), ..operand_stack], operator_stack)
    [token.LParen, ..tail] ->
      do_shunting_yard(tail, operand_stack, [token.LParen, ..operator_stack])
    [token.RParen, ..tail] -> {
      case operator_stack {
        [] -> Error(ParseError)
        [token.LParen, ..operator_stack_rest] ->
          do_shunting_yard(tail, operand_stack, operator_stack_rest)
        [t, ..operator_stack_rest] ->
          do_shunting_yard(tokens, [t, ..operand_stack], operator_stack_rest)
      }
    }
    [input_operator, ..tail] -> {
      case operator_stack {
        [] | [token.LParen, ..] -> {
          let new_operator_stack = [input_operator, ..operator_stack]
          do_shunting_yard(tail, operand_stack, new_operator_stack)
        }
        [stack_operator, ..operator_stack_rest] -> {
          let assert Some(order) =
            compare_precedence(input_operator, stack_operator)
          let assert Some(associativity) = associativity(input_operator)
          case order, associativity {
            Gt, _ | Eq, Right -> {
              let new_operator_stack = [input_operator, ..operator_stack]
              do_shunting_yard(tail, operand_stack, new_operator_stack)
            }
            _, _ -> {
              let new_operand_stack = [stack_operator, ..operand_stack]
              do_shunting_yard(tokens, new_operand_stack, operator_stack_rest)
            }
          }
        }
      }
    }
  }
}
