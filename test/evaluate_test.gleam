import error.{DivideByZeroError}
import evaluate.{evaluate as eval}
import expression.{Add, Divide, Multiply, Negation, Number, Subtract}
import gleeunit/should

pub fn evaluate_number_zero_test() {
  eval(Number(0))
  |> should.be_ok
  |> should.equal(0)
}

pub fn evaluate_number_non_zero_test() {
  eval(Number(100))
  |> should.be_ok
  |> should.equal(100)
}

pub fn evaluate_negation_zero_test() {
  eval(Negation(Number(0)))
  |> should.be_ok
  |> should.equal(0)
}

pub fn evaluate_negation_non_zero_test() {
  eval(Negation(Number(42)))
  |> should.be_ok
  |> should.equal(-42)
}

pub fn evaluate_sum_test() {
  eval(Add(Number(2), Number(5)))
  |> should.be_ok
  |> should.equal(7)
}

pub fn evaluate_subtraction_test() {
  eval(Subtract(Number(1), Number(7)))
  |> should.be_ok
  |> should.equal(-6)
}

pub fn evaluate_product_test() {
  eval(Multiply(Number(2), Number(100)))
  |> should.be_ok
  |> should.equal(200)
}

pub fn evaluate_division_divisible_test() {
  eval(Divide(Number(6), Number(3)))
  |> should.be_ok
  |> should.equal(2)
}

pub fn evaluate_divide_zero_by_zero_test() {
  eval(Divide(Number(0), Number(0)))
  |> should.be_error
  |> should.equal(DivideByZeroError)
}

pub fn evaluate_divide_twelve_by_zero_test() {
  eval(Divide(Number(12), Number(0)))
  |> should.be_error
  |> should.equal(DivideByZeroError)
}

pub fn evaluate_division_round_down_test() {
  // 7 / 3 = 2.333..., should be rounded down to 2
  eval(Divide(Number(7), Number(3)))
  |> should.be_ok
  |> should.equal(2)
}

pub fn evaluate_division_round_half_up_test() {
  // 3 / 2 = 1.5, should be rounded up to 2
  eval(Divide(Number(3), Number(2)))
  |> should.be_ok
  |> should.equal(2)
  // 5 / 2 = 2.5, should be rounded up to 3
  eval(Divide(Number(5), Number(2)))
  |> should.be_ok
  |> should.equal(3)
}

pub fn evaluate_division_round_up_test() {
  // 8 / 3 = 2.666..., should be rounded up to 3
  eval(Divide(Number(8), Number(3)))
  |> should.be_ok
  |> should.equal(3)
}

pub fn evaluate_division_round_negative_away_from_zero_test() {
  // -5 / 2 = -2.5, should be rounded down (away from zero) to -3
  eval(Divide(Negation(Number(5)), Number(2)))
  |> should.be_ok
  |> should.equal(-3)
}

pub fn evaluate_complex_expression_test() {
  // (15 + 3 * -2) / 3 - 3 = 0
  eval(Subtract(
    Divide(Add(Number(15), Multiply(Number(3), Negation(Number(2)))), Number(3)),
    Number(3),
  ))
  |> should.be_ok
  |> should.equal(0)
}

pub fn evaluate_add_divide_by_zero_test() {
  // 1 + 1 / 0 -> error
  eval(Add(Number(1), Divide(Number(1), Number(0))))
  |> should.be_error
  |> should.equal(DivideByZeroError)
}
