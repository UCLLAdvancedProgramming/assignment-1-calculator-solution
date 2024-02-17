import associativity.{Left, Right}
import error.{ParseError}
import expression.{Add, Divide, Multiply, Negation, Subtract}
import parse.{parse}
import token.{Asterisk, LParen, Minus, Neg, Plus, RParen, Slash}
import gleam/order.{Eq, Gt, Lt}
import gleam/option.{None, Some}
import gleeunit/should

pub fn parse_number_test() {
  parse([token.Number(5)])
  |> should.be_ok
  |> should.equal(expression.Number(5))
}

pub fn parse_negation_test() {
  parse([Minus, token.Number(5)])
  |> should.be_ok
  |> should.equal(Negation(expression.Number(5)))
}

pub fn parse_double_negation_test() {
  parse([Minus, Minus, token.Number(5)])
  |> should.be_ok
  |> should.equal(Negation(Negation(expression.Number(5))))
}

pub fn parse_negation_with_parens_test() {
  parse([Minus, LParen, token.Number(3), RParen])
  |> should.be_ok
  |> should.equal(Negation(expression.Number(3)))
}

pub fn parse_addition_test() {
  parse([token.Number(12), Plus, token.Number(24)])
  |> should.be_ok
  |> should.equal(Add(expression.Number(12), expression.Number(24)))
}

pub fn parse_multiple_addition_test() {
  parse([token.Number(12), Plus, token.Number(24), Plus, token.Number(5)])
  |> should.be_ok
  |> should.equal(Add(
    Add(expression.Number(12), expression.Number(24)),
    expression.Number(5),
  ))
}

pub fn parse_subtraction_test() {
  parse([token.Number(12), Minus, token.Number(24)])
  |> should.be_ok
  |> should.equal(Subtract(expression.Number(12), expression.Number(24)))
}

pub fn parse_multiplication_test() {
  parse([token.Number(12), Asterisk, token.Number(24)])
  |> should.be_ok
  |> should.equal(Multiply(expression.Number(12), expression.Number(24)))
}

pub fn parse_division_test() {
  parse([token.Number(12), Slash, token.Number(24)])
  |> should.be_ok
  |> should.equal(Divide(expression.Number(12), expression.Number(24)))
}

pub fn parse_add_and_multiply_test() {
  parse([
    LParen,
    token.Number(12),
    Plus,
    token.Number(24),
    RParen,
    Asterisk,
    token.Number(3),
  ])
  |> should.be_ok
  |> should.equal(Multiply(
    Add(expression.Number(12), expression.Number(24)),
    expression.Number(3),
  ))
}

pub fn parse_add_and_multiply2_test() {
  parse([token.Number(12), Plus, token.Number(24), Asterisk, token.Number(3)])
  |> should.be_ok
  |> should.equal(Add(
    expression.Number(12),
    Multiply(expression.Number(24), expression.Number(3)),
  ))
}

pub fn double_divide_test() {
  parse([token.Number(1), Slash, token.Number(2), Slash, token.Number(3)])
  |> should.be_ok
  |> should.equal(Divide(
    Divide(expression.Number(1), expression.Number(2)),
    expression.Number(3),
  ))
}

pub fn double_divide2_test() {
  parse([
    token.Number(1),
    Slash,
    LParen,
    token.Number(2),
    Slash,
    token.Number(3),
    RParen,
  ])
  |> should.be_ok
  |> should.equal(Divide(
    expression.Number(1),
    Divide(expression.Number(2), expression.Number(3)),
  ))
}

pub fn divide_and_multiply_test() {
  parse([token.Number(3), Slash, token.Number(3), Asterisk, token.Number(5)])
  |> should.be_ok
  |> should.equal(Multiply(
    Divide(expression.Number(3), expression.Number(3)),
    expression.Number(5),
  ))
}

pub fn parse_empty_error_test() {
  parse([])
  |> should.be_error
  |> should.equal(ParseError)
}

pub fn parse_plus_error_test() {
  parse([Plus])
  |> should.be_error
  |> should.equal(ParseError)
}

pub fn parse_plus_number_error_test() {
  parse([token.Number(2), Plus])
  |> should.be_error
  |> should.equal(ParseError)
}

pub fn parse_two_numbers_error_test() {
  parse([token.Number(2), token.Number(4)])
  |> should.be_error
  |> should.equal(ParseError)
}

pub fn identify_negations_single_negation_test() {
  parse.identify_negations([Minus, token.Number(2)])
  |> should.equal([Neg, token.Number(2)])
}

pub fn identify_negations_double_negation_test() {
  parse.identify_negations([Minus, Minus, token.Number(5)])
  |> should.equal([Neg, Neg, token.Number(5)])
}

pub fn identify_negations_subtraction_test() {
  parse.identify_negations([token.Number(1), Minus, token.Number(2)])
  |> should.equal([token.Number(1), Minus, token.Number(2)])
}

pub fn identify_negations_subtract_negation_test() {
  parse.identify_negations([token.Number(1), Minus, Minus, token.Number(2)])
  |> should.equal([token.Number(1), Minus, Neg, token.Number(2)])
}

pub fn identify_negations_subtract_after_parens_test() {
  parse.identify_negations([
    LParen,
    token.Number(1),
    Plus,
    token.Number(2),
    RParen,
    Minus,
    token.Number(8),
  ])
  |> should.equal([
    LParen,
    token.Number(1),
    Plus,
    token.Number(2),
    RParen,
    Minus,
    token.Number(8),
  ])
}

pub fn identify_negations_multiply_negation_test() {
  parse.identify_negations([token.Number(3), Asterisk, Minus, token.Number(4)])
  |> should.equal([token.Number(3), Asterisk, Neg, token.Number(4)])
}

pub fn identify_negations_before_parens_test() {
  parse.identify_negations([
    token.Number(2),
    Plus,
    Minus,
    LParen,
    token.Number(5),
    RParen,
  ])
  |> should.equal([token.Number(2), Plus, Neg, LParen, token.Number(5), RParen])
}

pub fn associativity_plus_test() {
  parse.associativity(token.Plus)
  |> should.equal(Some(Left))
}

pub fn associativity_minus_test() {
  parse.associativity(token.Minus)
  |> should.equal(Some(Left))
}

pub fn associativity_asterisk_test() {
  parse.associativity(token.Asterisk)
  |> should.equal(Some(Left))
}

pub fn associativity_slash_test() {
  parse.associativity(token.Slash)
  |> should.equal(Some(Left))
}

pub fn associativity_neg_test() {
  parse.associativity(token.Neg)
  |> should.equal(Some(Right))
}

pub fn associativity_lparen_test() {
  parse.associativity(token.LParen)
  |> should.equal(None)
}

pub fn associativity_rparen_test() {
  parse.associativity(token.RParen)
  |> should.equal(None)
}

pub fn associativity_space_test() {
  parse.associativity(token.Space)
  |> should.equal(None)
}

pub fn associativity_number_test() {
  parse.associativity(token.Number(5))
  |> should.equal(None)
}

pub fn compare_precedence_plus_plus_test() {
  parse.compare_precedence(token.Plus, token.Plus)
  |> should.equal(Some(Eq))
}

pub fn compare_precedence_plus_minus_test() {
  parse.compare_precedence(token.Plus, token.Minus)
  |> should.equal(Some(Eq))
}

pub fn compare_precedence_asterisk_minus_test() {
  parse.compare_precedence(token.Asterisk, token.Minus)
  |> should.equal(Some(Gt))
}

pub fn compare_precedence_plus_slash_test() {
  parse.compare_precedence(token.Plus, token.Slash)
  |> should.equal(Some(Lt))
}

pub fn compare_precedence_neg_plus_test() {
  parse.compare_precedence(token.Neg, token.Plus)
  |> should.equal(Some(Gt))
}

pub fn compare_precedence_plus_neg_test() {
  parse.compare_precedence(token.Plus, token.Neg)
  |> should.equal(Some(Lt))
}

pub fn compare_precedence_neg_asterisk_test() {
  parse.compare_precedence(token.Neg, token.Asterisk)
  |> should.equal(Some(Gt))
}

pub fn compare_precedence_asterisk_neg_test() {
  parse.compare_precedence(token.Asterisk, token.Neg)
  |> should.equal(Some(Lt))
}

pub fn parse_rpn_negation_test() {
  parse.parse_rpn([], [token.Number(4), token.Neg])
  |> should.be_ok
  |> should.equal(expression.Negation(expression.Number(4)))
}

pub fn parse_rpn_double_negation_test() {
  parse.parse_rpn([], [token.Number(4), token.Neg, token.Neg])
  |> should.be_ok
  |> should.equal(
    expression.Negation(expression.Negation(expression.Number(4))),
  )
}

pub fn parse_rpn_subtract_test() {
  parse.parse_rpn([], [token.Number(1), token.Number(2), token.Minus])
  |> should.be_ok
  |> should.equal(expression.Subtract(
    expression.Number(1),
    expression.Number(2),
  ))
}

pub fn parse_rpn_extra_token_test() {
  parse.parse_rpn([], [token.Number(1), token.Plus])
  |> should.be_error
  |> should.equal(error.ParseError)
}

pub fn parse_rpn_excess_numbers_test() {
  parse.parse_rpn([], [token.Number(1), token.Number(2)])
  |> should.be_error
  |> should.equal(error.ParseError)
}

pub fn shunting_yard_plus_test() {
  parse.shunting_yard([token.Number(4), Plus, token.Number(5)])
  |> should.be_ok
  |> should.equal([token.Number(4), token.Number(5), Plus])
}

pub fn shunting_yard_minus_test() {
  parse.shunting_yard([token.Number(4), Minus, token.Number(5)])
  |> should.be_ok
  |> should.equal([token.Number(4), token.Number(5), Minus])
}

pub fn shunting_yard_left_associative_plus_test() {
  parse.shunting_yard([
    token.Number(4),
    Plus,
    token.Number(5),
    Plus,
    token.Number(6),
  ])
  |> should.be_ok
  |> should.equal([
    token.Number(4),
    token.Number(5),
    Plus,
    token.Number(6),
    Plus,
  ])
}

pub fn shunting_yard_multiply_and_add_test() {
  parse.shunting_yard([
    token.Number(4),
    Asterisk,
    token.Number(5),
    Plus,
    token.Number(6),
  ])
  |> should.be_ok
  |> should.equal([
    token.Number(4),
    token.Number(5),
    Asterisk,
    token.Number(6),
    Plus,
  ])
}

pub fn shunting_yard_add_and_multiply_precedence_test() {
  parse.shunting_yard([
    token.Number(4),
    Plus,
    token.Number(5),
    Asterisk,
    token.Number(6),
  ])
  |> should.be_ok
  |> should.equal([
    token.Number(4),
    token.Number(5),
    token.Number(6),
    Asterisk,
    Plus,
  ])
}

pub fn shunting_yard_complex_test() {
  parse.shunting_yard([
    token.Number(3),
    Plus,
    token.Number(4),
    Asterisk,
    token.Number(2),
    Slash,
    LParen,
    token.Number(1),
    Minus,
    token.Number(5),
    RParen,
  ])
  |> should.be_ok
  |> should.equal([
    token.Number(3),
    token.Number(4),
    token.Number(2),
    Asterisk,
    token.Number(1),
    token.Number(5),
    Minus,
    Slash,
    Plus,
  ])
}
