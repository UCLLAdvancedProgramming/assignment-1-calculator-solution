import expression.{Add, Divide, Multiply, Negation, Number, Subtract, operands}
import gleeunit/should

pub fn operands_number_test() {
  operands(Number(3))
  |> should.equal([])
}

pub fn operands_negation_test() {
  operands(Negation(Number(3)))
  |> should.equal([Number(3)])
  operands(Negation(Add(Number(1), Number(7))))
  |> should.equal([Add(Number(1), Number(7))])
}

pub fn operands_add_test() {
  operands(Add(Number(1), Number(5)))
  |> should.equal([Number(1), Number(5)])
  operands(Add(Number(1), Negation(Number(5))))
  |> should.equal([Number(1), Negation(Number(5))])
}

pub fn operands_subtract_test() {
  operands(Subtract(Number(3), Number(8)))
  |> should.equal([Number(3), Number(8)])
  operands(Subtract(Number(1), Negation(Number(5))))
  |> should.equal([Number(1), Negation(Number(5))])
}

pub fn operands_multiply_test() {
  operands(Multiply(Number(3), Number(8)))
  |> should.equal([Number(3), Number(8)])
  operands(Multiply(Number(1), Negation(Number(5))))
  |> should.equal([Number(1), Negation(Number(5))])
}

pub fn operands_divide_test() {
  operands(Divide(Number(3), Number(8)))
  |> should.equal([Number(3), Number(8)])
  operands(Divide(Number(1), Negation(Number(5))))
  |> should.equal([Number(1), Negation(Number(5))])
}
