defmodule CalculatorTest do
  use ExUnit.Case
  doctest Calculator

  test "calculate" do
    # assert Calculator.calculate("3.5+4") == 7
    assert Calculator.calculate("3+4") == 7
    assert Calculator.calculate("3+4*2") == 11
    assert Calculator.calculate("(3+4)*2") == 14
    assert Calculator.calculate("(3+4)*2^2") == 28
    assert Calculator.calculate("((3+1)*2)^2") == 64
    assert Calculator.calculate("((3+1)*2)/2") == 4
    assert Calculator.calculate("(30-100)/2+35") == 0
    assert Calculator.calculate("((30+105-(5+35))/5)^(4/2-2)") == 1
  end
end
