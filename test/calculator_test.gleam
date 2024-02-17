import argv
import calculator.{calculate}
import error.{DivideByZeroError, ParseError, UnknownCharacterError}
import gleam/io
import gleam/erlang/atom.{type Atom}
import gleeunit
import gleeunit/should

@external(erlang, "eunit", "test")
fn run_tests_in_module_atom(module: Atom) -> Nil

fn run_tests_in_module(module: String) {
  run_tests_in_module_atom(atom.create_from_string(module))
}

pub fn main() {
  case argv.load().arguments {
    [] -> gleeunit.main()
    [module] -> run_tests_in_module(module)
    _ -> io.println("Unknown argument")
  }
}

pub fn calculate_precedence_test() {
  calculate("1 + 2 * 3")
  |> should.be_ok
  |> should.equal(7)
}

pub fn calculate_simple_product_test() {
  calculate("4 * 2 * 3")
  |> should.be_ok
  |> should.equal(24)
}

pub fn calculate_parens_test() {
  calculate("(4 + 3) * 2")
  |> should.be_ok
  |> should.equal(14)
}

pub fn calculate_round_down_test() {
  calculate("4 / 3")
  |> should.be_ok
  |> should.equal(1)
}

pub fn calculate_round_up_test() {
  calculate("5 / 3")
  |> should.be_ok
  |> should.equal(2)
}

pub fn calculate_left_associative_test() {
  calculate("2 - 1 + 1")
  |> should.be_ok
  |> should.equal(2)
}

pub fn calculate_double_negation_test() {
  calculate("--2")
  |> should.be_ok
  |> should.equal(2)
}

pub fn calculate_parse_error_test() {
  calculate("+ 2 * 3")
  |> should.be_error
  |> should.equal(ParseError)
}

pub fn calculate_unknown_character_error_test() {
  calculate("1 + 2hello")
  |> should.be_error
  |> should.equal(UnknownCharacterError("h"))
}

pub fn calculate_simple_divide_by_zero_error_test() {
  calculate("1 / 0")
  |> should.be_error
  |> should.equal(DivideByZeroError)
}

pub fn calculate_complex_divide_by_zero_error_test() {
  calculate("1 / (3 - (2 + 1))")
  |> should.be_error
  |> should.equal(DivideByZeroError)
}
