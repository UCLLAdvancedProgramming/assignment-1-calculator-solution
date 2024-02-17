import error.{UnknownCharacterError}
import token.{Asterisk, LParen, Minus, Number, Plus, RParen, Slash}
import tokenize.{tokenize}
import gleeunit/should

pub fn tokenize_single_digit_test() {
  tokenize("1")
  |> should.be_ok
  |> should.equal([Number(1)])
}

pub fn tokenize_double_digit_test() {
  tokenize("12")
  |> should.be_ok
  |> should.equal([Number(12)])
}

pub fn tokenize_seperate_digits_test() {
  tokenize("1 2")
  |> should.be_ok
  |> should.equal([Number(1), Number(2)])
}

pub fn tokenize_empty_test() {
  tokenize("")
  |> should.be_ok
  |> should.equal([])
}

pub fn tokenize_unknown_character_test() {
  tokenize("hello")
  |> should.be_error
  |> should.equal(UnknownCharacterError("h"))
}

pub fn tokenize_unknown_character2_test() {
  tokenize("3b")
  |> should.be_error
  |> should.equal(UnknownCharacterError("b"))
}

pub fn tokenize_negative_number_test() {
  tokenize("-12")
  |> should.be_ok
  |> should.equal([Minus, Number(12)])
}

pub fn tokenize_all_tokens_test() {
  tokenize("()0123456789+-*/ ")
  |> should.be_ok
  |> should.equal([
    LParen,
    RParen,
    Number(123_456_789),
    Plus,
    Minus,
    Asterisk,
    Slash,
  ])
}
