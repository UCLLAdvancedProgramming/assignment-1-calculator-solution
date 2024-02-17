//// This module defines the `calculate` and `main` functions (part 4 of the assignment).

import error.{type CalculatorError}

/// Takes a mathematical expression as a string, and returns the result of the calculation.
/// 
/// If any error occurs, the appropriate CalculatorError is returned.
pub fn calculate(input: String) -> Result(Int, CalculatorError) {
  todo as "calculate function not implemented"
}

/// The main function of the application.
/// 
/// This function prompts the user for a mathematical expression,
/// and then either outputs the result, or an error. It will
/// then prompt the user for another mathematical expression, etc.
/// 
/// If an input error occurs, or the user enters "q", then the
/// main function returns.
/// 
/// Example session:
/// 
/// ```console
/// > 5 + 4
/// Result: 9
/// > 2 / 0
/// Error: Divide by zero
/// > 2 -
/// Error: Parse error
/// > hi
/// Error: Unknown character: 'h'
/// > q
/// ```
pub fn main() {
  todo as "main function not implemented"
}
